//
// Copyright 2021 Google Inc.
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

#import "GTXiLib.h"
#import "GTXUITestBaseTestCase.h"

#import <XCTest/XCTest.h>

/**
 Tests that verify GTX is able to detect issues in test cases when XCUIApplication is
 created in testcase (and reference discarded) rather than in setUp.
 */
@interface GTXTestAppInitIntegrationTest : GTXUITestBaseTestCase
@end

@implementation GTXTestAppInitIntegrationTest

+ (void)setUp {
  [super setUp];

  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:[GTXChecksCollection allGTXChecks]
          elementExcludeLists:@[]];
}

- (void)testFailingTestCase {
  [self setExpectedFailureCount:1];
  XCUIApplication *application = [[XCUIApplication alloc] init];
  [application launch];
}

@end
