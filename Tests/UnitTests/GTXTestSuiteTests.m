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

#import <XCTest/XCTest.h>

#import "GTXTestSuite.h"

#pragma mark - Test Classes

@interface GTXTestSuiteWithNoTests : NSObject
@end

@interface GTXTestSuiteWithOneTest : NSObject
@end

@interface GTXTestSuiteWithTwoTest : NSObject
@end

@interface GTXTestEmptyInheritedSuite : GTXTestSuiteWithOneTest
@end

@interface GTXTestBaseSuiteWithOneTest : NSObject
@end

@interface GTXTestInheritedSuiteWithOneTest : GTXTestBaseSuiteWithOneTest
@end

#pragma mark - Test Class Implementations

@implementation GTXTestSuiteWithNoTests
@end

@implementation GTXTestSuiteWithOneTest

- (void)gtxtest_dummyMethodWithWordtest {
  // nothing to do
}

- (void)testFirst {
  // nothing to test
}

@end

@implementation GTXTestSuiteWithTwoTest

- (void)testFirst {
  // nothing to test
}

- (void)gtxtest_dummyMethodWithWordtest {
  // nothing to do
}

- (void)testSecond {
  // nothing to test
}

- (void)gtxtest_secondDummyMethodWithWordtest {
  // nothing to do
}

@end

@implementation GTXTestEmptyInheritedSuite
@end

@implementation GTXTestBaseSuiteWithOneTest

- (void)testBaseSuite {
  // nothing to test
}

@end

@implementation GTXTestInheritedSuiteWithOneTest

- (void)testInheritedSuite {
  // nothing to test
}

@end

#pragma mark - Tests

@interface GTXTestSuiteTests : XCTestCase
@end

@implementation GTXTestSuiteTests

- (void)testGTXTestSuiteCanLoadEmptySuite {
  GTXTestSuite *suite =
      [GTXTestSuite suiteWithAllTestsInClass:[GTXTestSuiteWithNoTests class]];
  XCTAssertEqual(suite.tests.count, 0u);

  suite = [GTXTestSuite suiteWithClass:[GTXTestSuiteWithNoTests class] andTests:nil];
  XCTAssertEqual(suite.tests.count, 0u);
}

- (void)testGTXTestSuiteCanLoadOneTestCase {
  GTXTestSuite *suite =
      [GTXTestSuite suiteWithAllTestsInClass:[GTXTestSuiteWithOneTest class]];
  XCTAssertEqual(suite.tests.count, 1u);

  suite = [GTXTestSuite suiteWithClass:[GTXTestSuiteWithOneTest class]
                              andTests:@selector(testFirst), nil];
  XCTAssertEqual(suite.tests.count, 1u);

  suite = [GTXTestSuite suiteWithClass:[GTXTestSuiteWithTwoTest class]
                              andTests:@selector(testFirst), nil];
  XCTAssertEqual(suite.tests.count, 1u);
}

- (void)testGTXTestSuiteCanSkipLoadingTestsFromSuiteWithOneTest {
  GTXTestSuite *suite = [GTXTestSuite suiteWithClass:[GTXTestSuiteWithOneTest class]
                                         exceptTests:@selector(testFirst), nil];
  XCTAssertEqual(suite.tests.count, 0u);
}

- (void)testGTXTestSuiteCanSkipLoadingTestsFromSuiteWithTwoTests {
  // Skip one test.
  GTXTestSuite *suite = [GTXTestSuite suiteWithClass:[GTXTestSuiteWithTwoTest class]
                                         exceptTests:@selector(testFirst), nil];
  XCTAssertEqual(suite.tests.count, 1u);

  // Skip two tests.
  suite =
      [GTXTestSuite suiteWithClass:[GTXTestSuiteWithTwoTest class]
                       exceptTests:@selector(testFirst), @selector(testSecond), nil];
  XCTAssertEqual(suite.tests.count, 0u);
}

- (void)testGTXTestSuiteCanLoadAllTests {
  GTXTestSuite *suite =
      [GTXTestSuite suiteWithAllTestsInClass:[GTXTestSuiteWithOneTest class]];
  XCTAssertEqual(suite.tests.count, 1u);

  suite = [GTXTestSuite suiteWithAllTestsInClass:[GTXTestSuiteWithTwoTest class]];;
  XCTAssertEqual(suite.tests.count, 2u);
}

- (void)testGTXTestSuiteCanBeAppended {
  GTXTestSuite *suite1 =
      [GTXTestSuite suiteWithAllTestsInClass:[GTXTestSuiteWithOneTest class]];
  GTXTestSuite *suite2 =
      [GTXTestSuite suiteWithAllTestsInClass:[GTXTestSuiteWithTwoTest class]];
  XCTAssertEqual([suite2 suiteByAppendingSuite:suite1].tests.count, 3u);
  XCTAssertEqual([suite1 suiteByAppendingSuite:suite2].tests.count, 3u);
}

- (void)testGTXTestSuiteOnlyAllowsValidMethods {
  void (^createInvalidSuite)(void) = ^ {
    [GTXTestSuite suiteWithClass:[GTXTestSuiteWithOneTest class]
                        andTests:@selector(testSecond), nil];
  };
  XCTAssertThrows(createInvalidSuite());
}

- (void)testGTXTestSuiteDoesNotLoadInheritedTestsByDefault {
  Class inheritedClass = [GTXTestEmptyInheritedSuite class];
  Class baseClass = [GTXTestSuiteWithOneTest class];
  XCTAssertEqual([inheritedClass superclass], baseClass);

  GTXTestSuite *baseSuite = [GTXTestSuite suiteWithAllTestsInClass:baseClass];
  XCTAssertEqual(baseSuite.tests.count, 1u);
  GTXTestSuite *inheritedSuite = [GTXTestSuite suiteWithAllTestsInClass:inheritedClass];
  XCTAssertEqual(inheritedSuite.tests.count, 0u);
}

- (void)testGTXTestSuiteCanLoadInheritedTests {
  Class baseClass = [GTXTestBaseSuiteWithOneTest class];
  Class inheritedClass = [GTXTestInheritedSuiteWithOneTest class];
  XCTAssertEqual([inheritedClass superclass], baseClass);

  GTXTestSuite *baseSuite = [GTXTestSuite suiteWithAllTestsInClass:baseClass];
  XCTAssertEqual(baseSuite.tests.count, 1u);
  GTXTestSuite *inheritedSuite = [GTXTestSuite suiteWithAllTestsInClass:inheritedClass];
  XCTAssertEqual(inheritedSuite.tests.count, 1u);
  GTXTestSuite *fullSuite =
      [GTXTestSuite suiteWithAllTestsFromAllClassesInheritedFromClass:baseClass];
  // Expected count has baseSuite.tests.count twice because base class tests are also part of
  // inherited class tests.
  XCTAssertEqual(fullSuite.tests.count,
                 baseSuite.tests.count +
                 (baseSuite.tests.count + inheritedSuite.tests.count));
}

@end
