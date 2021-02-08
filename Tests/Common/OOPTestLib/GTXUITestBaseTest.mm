//
// Copyright 2020 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "GTXUITestBaseTest.h"

#import "GTXImageRGBAData+GTXOOPAdditions.h"
#import "NSObject+GTXAdditions.h"
#import "NSString+GTXAdditions.h"
#include "toolkit.h"

#import "XCUIElement+GTXTestAdditions.h"
#import "GTXTestViewController.h"

/**
 *  Max time to wait for the app to start (come to foreground) for testing.
 */
static const NSTimeInterval kGTXTestAppStartTimeout = 3.0;

/**
 *  Max time to wait for the test to finish search action (for example scroll up/down to find an
 *  element).
 */
static const NSTimeInterval kGTXTestSearchActionTimeout = 5.0;

@implementation GTXUITestBaseTest {
  XCUIApplication *_app;
}

- (void)setUp {
  [super setUp];

  _app = [[XCUIApplication alloc] init];
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [_app launch];
    XCTAssertTrue([_app waitForState:XCUIApplicationStateRunningForeground
                             timeout:kGTXTestAppStartTimeout]);
  });
  self.clearTestAreaOnTeardown = YES;
}

- (void)tearDown {
  if (self.shouldClearTestAreaOnTeardown) {
    [self clearTestArea];
  }

  [super tearDown];
}

- (void)clearTestArea {
  [_app.buttons[kGTXTestAppClearTestAreaID] tap];
}

- (void)performTestActionNamed:(NSString *)actionName {
  if (_app.buttons[actionName].isHittable) {
    [_app.buttons[actionName] tap];
  } else {
    [_app.buttons[kGTXTestAppScrollToTopID] tap];
  }
  XCUIElement *scrollView = _app.scrollViews[kGTXTestAppActionsContainerID];
  NSTimeInterval timeoutTime =
      [NSDate timeIntervalSinceReferenceDate] + kGTXTestSearchActionTimeout;
  while (!_app.buttons[actionName].isHittable &&
         [NSDate timeIntervalSinceReferenceDate] < timeoutTime) {
    XCUICoordinate *start = [scrollView coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.5)];
    XCUICoordinate *end =
        [start coordinateWithOffset:CGVectorMake(0, -scrollView.frame.size.height)];
    [start pressForDuration:0.01 thenDragToCoordinate:end];
  }
  [_app.buttons[actionName] tap];
}

- (BOOL)runAllGTXChecksOnTestElement {
  NSArray<XCUIElement *> *otherElements = [[[_app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] allElementsBoundByIndex];
  UIAccessibilityElement *testElement =
      [otherElements.firstObject gtxtest_accessibilityElementWithContainer:_app];
  if (!testElement) {
    return YES;
  }
  auto toolkit = gtx::Toolkit::ToolkitWithAllDefaultChecks();
  gtx::Parameters params;
  XCUIScreenshot *screenshot = XCUIScreen.mainScreen.screenshot;
  GTXImageRGBAData *rgbaData = [[GTXImageRGBAData alloc] initWithUIImage:screenshot.image];
  auto gtxImage = [rgbaData gtxImage];
  params.set_screenshot(*gtxImage);
  // Use screenshot to infer device size since UIScreen.mainScreen.bounds may not work from test
  // process.
  // TODO: Add radar ref once filed.
  gtx::Rect gtxDeviceBounds = gtx::Rect(0, 0, rgbaData.width, rgbaData.height);
  float scale = 1.0 / UIScreen.mainScreen.scale;
  params.set_device_bounds(gtxDeviceBounds.ScaledRect(scale, scale));
  return toolkit->CheckElement(*[testElement gtx_UIElement], params).empty();
}

@end
