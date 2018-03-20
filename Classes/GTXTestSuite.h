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

#import "GTXTestCase.h"

/**
 An immutable collection of test cases (GTXTestCase objects).
 */
@interface GTXTestSuite : NSObject

/**
 Array of test cases in this suite.
 */
@property (nonatomic, strong) NSArray<GTXTestCase *> *tests;

/**
 @return A test suite with all the test methods in the given class.
 */
+ (instancetype)suiteWithAllTestsInClass:(Class)testClass;

/**
 @return A test suite with all the test methods in the given class and all classes inherited from
         it.
 */
+ (instancetype)suiteWithAllTestsFromAllClassesInheritedFromClass:(Class)baseClass;

/**
 Returns a test suite containing the given methods of the given class, test method selectors must
 be passed in and must be terminated by nil.

 @param testClass The class to get the test methods from.
 @param testMethod1 Selector of the test method.
 @return A test suite containing the given methods of the given class
 */
+ (instancetype)suiteWithClass:(Class)testClass
                      andTests:(SEL)testMethod1,... NS_REQUIRES_NIL_TERMINATION;

/**
 Returns a test suite containing all test methods of the given class except the ones specified.

 @param testClass The class to get the test methods from.
 @param testMethod1 Selector of the test method to be ignored.
 @return A test suite containing all the tests of the given class except the ones specified.
 */
+ (instancetype)suiteWithClass:(Class)testClass
                   exceptTests:(SEL)testMethod1,... NS_REQUIRES_NIL_TERMINATION;

/**
 @return A new suite with all the test cases of @c suite added to it.
 */
- (GTXTestSuite *)suiteByAppendingSuite:(GTXTestSuite *)suite;

/**
 Checks to dind if the specified testcase is part of the given test suite.

 @param testClass Class that the test method belongs to.
 @param testMethod Test method
 @return @c YES if test case is part of the given test suite, @c NO otherwise.
 */
- (BOOL)hasTestCaseWithClass:(Class)testClass testMethod:(SEL)testMethod;

/**
 @return A suite with the intersection of tests of the current suite and the provided suite.
 */
- (GTXTestSuite *)intersection:(GTXTestSuite *)suite;

@end
