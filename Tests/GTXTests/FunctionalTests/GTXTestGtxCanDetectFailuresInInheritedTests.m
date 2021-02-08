//
// Copyright 2018 Google Inc.
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
#import "GTXTestBaseTest.h"

/**
 A global boolean that is used to ensure that at least one test is run.
 */
static BOOL gTeardownCalledAtleastOnce = NO;

#pragma mark - Interfaces

/**
 A super class that contains a single test method.
 */
@interface GTXTestSuperClassWithATestMethod : GTXTestBaseTest
@end

/**
 Class with tests that are only inherited.
 */
@interface GTXTestGtxCanDetectFailuresInInheritedTests : GTXTestSuperClassWithATestMethod
@end

#pragma mark - Implementations

@implementation GTXTestGtxCanDetectFailuresInInheritedTests

+ (void)setUp {
  [super setUp];
  GTXTestSuite *suite = [GTXTestSuite suiteWithAllTestsFromAllClassesInheritedFromClass:
      [GTXTestSuperClassWithATestMethod class]];
  [GTXiLib installOnTestSuite:suite checks:@[ gAlwaysFail ] elementExcludeLists:@[]];
  gTeardownCalledAtleastOnce = NO;
}

- (void)tearDown {
  static NSInteger expectedFailureCount = 1;
  [self assertFailureCount:expectedFailureCount];
  expectedFailureCount += 1; // Each test must cause exactly one failure.
  gTeardownCalledAtleastOnce = YES;

  [super tearDown];
}

+ (void)tearDown {
  NSAssert(gTeardownCalledAtleastOnce, @"No tests were run!");

  [super tearDown];
}

@end

@implementation GTXTestSuperClassWithATestMethod

- (void)testFirstEmpty {
  // This test exists to ensure teardown is called.
}

@end
