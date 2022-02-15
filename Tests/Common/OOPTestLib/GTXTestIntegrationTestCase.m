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

#import "GTXTestIntegrationTestCase.h"

#import "GTXUITestUtils.h"

/**
 *  Max time to wait for the app to start (come to foreground) for testing.
 */
static const NSTimeInterval kGTXTestAppStartTimeout = 3.0;

@implementation GTXTestIntegrationTestCase

- (void)setUp {
  [super setUp];

  _app = [[XCUIApplication alloc] init];
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [_app launch];
    XCTAssertTrue([_app waitForState:XCUIApplicationStateRunningForeground
                             timeout:kGTXTestAppStartTimeout]);
    [self clearTestArea];
  });
  self.clearTestAreaOnTeardown = YES;
}

- (void)tearDown {
  if (self.shouldClearTestAreaOnTeardown) {
    [self clearTestArea];
  }

  [super tearDown];
}

- (void)performTestActionNamed:(NSString *)actionName {
  [GTXUITestUtils performTestActionNamed:actionName inApp:_app];
}

- (void)clearTestArea {
  [GTXUITestUtils clearTestAreaInApp:_app];
}

- (BOOL)runAllGTXChecksOnTestElement {
  return [GTXUITestUtils runAllGTXChecksOnTestElementInApp:_app];
}

@end
