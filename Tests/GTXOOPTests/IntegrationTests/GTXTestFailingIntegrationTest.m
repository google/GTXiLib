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

#import "GTXiLib.h"

/**
 Tests that verify GTX is able to fail the test cases when accessibility issues are detected.
 */
@interface GTXTestFailingIntegrationTest : GTXTestIntegrationTestCase
@end

@implementation GTXTestFailingIntegrationTest

+ (void)setUp {
  [super setUp];

  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:@[ [GTXChecksCollection checkForMinimumTappableArea] ]
          elementExcludeLists:@[]];
}

- (void)testFailingTestCase {
  [self performTestActionNamed:kAddTinyTappableElement];
  [self setExpectedFailureCount:1];
}

@end
