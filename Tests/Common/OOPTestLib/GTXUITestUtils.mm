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

#import "GTXUITestUtils.h"

#import "GTXImageRGBAData+GTXOOPAdditions.h"
#import "NSString+GTXAdditions.h"
#import "XCUIElement+GTXAdditions.h"
#include "toolkit.h"

#import "GTXTestViewController.h"

/**
 *  Max time to wait for the test to finish search action (for example scroll up/down to find an
 *  element).
 */
static const NSTimeInterval kGTXTestSearchActionTimeout = 5.0;

static const NSInteger kGTXTestBitsPerColorComponent = 255;

const NSInteger kBytesPerPixel = 4;

@implementation GTXUITestUtils

+ (void)clearTestAreaInApp:(XCUIApplication *)application {
  [application.buttons[kGTXTestAppClearTestAreaID] tap];
}

+ (void)performTestActionNamed:(NSString *)actionName inApp:(XCUIApplication *)application {
  if (application.buttons[actionName].isHittable) {
    [application.buttons[actionName] tap];
    return;
  } else {
    [application.buttons[kGTXTestAppScrollToTopID] tap];
  }
  XCUIElement *scrollView = application.scrollViews[kGTXTestAppActionsContainerID];
  NSTimeInterval timeoutTime =
      [NSDate timeIntervalSinceReferenceDate] + kGTXTestSearchActionTimeout;
  while (!application.buttons[actionName].isHittable &&
         [NSDate timeIntervalSinceReferenceDate] < timeoutTime) {
    XCUICoordinate *start = [scrollView coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.5)];
    XCUICoordinate *end =
        [start coordinateWithOffset:CGVectorMake(0, -scrollView.frame.size.height)];
    [start pressForDuration:0.01 thenDragToCoordinate:end];
  }
  [application.buttons[actionName] tap];
}

+ (BOOL)runAllGTXChecksOnTestElementInApp:(XCUIApplication *)application {
  XCUIElement *testElement = [[[[application descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] allElementsBoundByIndex] firstObject];
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
  return toolkit->CheckElement([testElement gtx_toProto], params).empty();
}

+ (void)fillRect:(CGRect)rect
       withColor:(UIColor *)color
        inBuffer:(unsigned char *)rgbaBuffer
          ofSize:(CGSize)size {
  CGFloat red, green, blue, alpha;
  [color getRed:&red green:&green blue:&blue alpha:&alpha];
  unsigned char r = (unsigned char)(red * kGTXTestBitsPerColorComponent);
  unsigned char g = (unsigned char)(green * kGTXTestBitsPerColorComponent);
  unsigned char b = (unsigned char)(blue * kGTXTestBitsPerColorComponent);
  unsigned char a = (unsigned char)(alpha * kGTXTestBitsPerColorComponent);
  NSInteger maxIndex = size.width * size.height;
  for (NSInteger y = CGRectGetMinY(rect); y < CGRectGetMaxY(rect); y++) {
    for (NSInteger x = CGRectGetMinX(rect); x < CGRectGetMaxX(rect); x++) {
      NSInteger index = x + y * size.width;
      if (index >= 0 && index < maxIndex) {
        rgbaBuffer[index * kBytesPerPixel] = r;
        rgbaBuffer[index * kBytesPerPixel + 1] = g;
        rgbaBuffer[index * kBytesPerPixel + 2] = b;
        rgbaBuffer[index * kBytesPerPixel + 3] = a;
      }
    }
  }
}

@end
