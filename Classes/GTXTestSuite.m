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

#import "GTXTestSuite.h"

#import <objc/runtime.h>

@implementation GTXTestSuite {
  NSMutableArray<GTXTestCase *> *mutableTests;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    mutableTests = [[NSMutableArray alloc] init];
    _tests = mutableTests;
  }
  return self;
}

+ (instancetype)suiteWithAllTestsFromAllClassesInheritedFromClass:(Class)baseClass {
  // Get a list of all classes.
  int totalClassesCount = objc_getClassList(NULL, 0);
  Class *allClasses =
      (__unsafe_unretained Class *)malloc(sizeof(Class) * (unsigned long)totalClassesCount);
  totalClassesCount = objc_getClassList(allClasses, totalClassesCount);
  NSMutableSet *applicableClasses = [[NSMutableSet alloc] initWithObjects:baseClass, nil];
  for (NSInteger i = 0; i < totalClassesCount; i++) {
    // Add all classes that inherit from the given baseClass
    Class currentClass = allClasses[i];
    Class currentSuperClass = currentClass;
    do {
      currentSuperClass = class_getSuperclass(currentSuperClass);
    } while(currentSuperClass && currentSuperClass != baseClass);

    if (currentSuperClass == baseClass) {
      [applicableClasses addObject:currentClass];
    }
  }

  // Create a suite with all the tests in applicableClasses set.
  GTXTestSuite *suite = [[GTXTestSuite alloc] init];
  for (Class currentClass in applicableClasses) {
    for (NSString *methodName in [self gtx_testMethodsInAllBaseClassesFromClass:currentClass]) {
      [suite->mutableTests addObject:
          [[GTXTestCase alloc] initWithTestClass:currentClass
                                        selector:NSSelectorFromString(methodName)]];
    }
  }

  free(allClasses);
  return suite;
}

+ (instancetype)suiteWithAllTestsInClass:(Class)testClass {
  GTXTestSuite *newSuite = [[GTXTestSuite alloc] init];
  for (NSString *methodName in [self gtx_testMethodsInClass:testClass]) {
    GTXTestCase *testCase =
        [[GTXTestCase alloc] initWithTestClass:testClass
                                      selector:NSSelectorFromString(methodName)];
    [newSuite->mutableTests addObject:testCase];
  }
  return newSuite;
}

+ (instancetype)suiteWithClass:(Class)testClass
                      andTests:(SEL)testMethod1, ... NS_REQUIRES_NIL_TERMINATION {
  GTXTestSuite *newSuite = [[GTXTestSuite alloc] init];

  va_list args;
  va_start(args, testMethod1);
  SEL testMethod = testMethod1;
  while (testMethod) {
    NSAssert([testClass instancesRespondToSelector:testMethod],
             @"Method %@ does not exist in %@", NSStringFromSelector(testMethod), testClass);
    GTXTestCase *testCase = [[GTXTestCase alloc] initWithTestClass:testClass selector:testMethod];
    [newSuite->mutableTests addObject:testCase];
    testMethod = va_arg(args, SEL);
  }

  va_end(args);
  return newSuite;
}

+ (instancetype)suiteWithClass:(Class)testClass
                   exceptTests:(SEL)testMethod1, ... NS_REQUIRES_NIL_TERMINATION {
  GTXTestSuite *suite = [GTXTestSuite suiteWithAllTestsInClass:testClass];

  // Remove the specified tests from the suite.
  va_list args;
  va_start(args, testMethod1);
  SEL testMethod = testMethod1;
  while (testMethod) {
    GTXTestCase *testCaseWithTestMethod;
    for (GTXTestCase *testCase in suite.tests) {
      if (testCase.testCaseSelector == testMethod) {
        testCaseWithTestMethod = testCase;
        break;
      }
    }
    NSAssert(testCaseWithTestMethod, @"Test %@ doesnot exist in %@ class",
             NSStringFromSelector(testMethod), testClass);
    [suite->mutableTests removeObject:testCaseWithTestMethod];
    testMethod = va_arg(args, SEL);
  }
  va_end(args);
  return suite;
}

- (GTXTestSuite *)suiteByAppendingSuite:(GTXTestSuite *)suite {
  GTXTestSuite *newSuite = [[GTXTestSuite alloc] init];
  [newSuite->mutableTests addObjectsFromArray:self.tests];
  [newSuite->mutableTests addObjectsFromArray:suite.tests];
  return newSuite;
}

- (BOOL)hasTestCaseWithClass:(Class)testClass testMethod:(SEL)testMethod {
  for (GTXTestCase *testCase in self.tests) {
    if (testCase.testCaseSelector == testMethod && testCase.testClass == testClass) {
      return YES;
    }
  }
  return NO;
}

- (GTXTestSuite *)intersection:(GTXTestSuite *)suite {
  GTXTestSuite *intersection = [[GTXTestSuite alloc] init];
  for (GTXTestCase *first in self.tests) {
    for (GTXTestCase *second in suite.tests) {
      if (first.testClass == second.testClass &&
          first.testCaseSelector == second.testCaseSelector) {
        [intersection->mutableTests addObject:first];
      }
    }
  }
  return intersection;
}

- (NSString *)description {
  NSMutableArray *items = [[NSMutableArray alloc] init];
  for (GTXTestCase *testcase in self.tests) {
    [items addObject:[NSString stringWithFormat:@"<Testcase Class=%@, Method=%@>",
                                                testcase.testClass,
                                                NSStringFromSelector(testcase.testCaseSelector)]];
  }
  return [NSString stringWithFormat:@"@[\n%@\n]", [items componentsJoinedByString:@"\n"]];
}

#pragma mark - Private

/**
 @return An array of all test methods in the given class and all of its super classes.
 */
+ (NSArray *)gtx_testMethodsInAllBaseClassesFromClass:(Class)inClass {
  Class currentClass = inClass;
  NSMutableSet *testMethods = [[NSMutableSet alloc] init];
  while (currentClass) {
    [testMethods addObjectsFromArray:[self gtx_testMethodsInClass:currentClass]];
    currentClass = [currentClass superclass];
  }
  return [testMethods allObjects];
}

/**
 @return An array of all test methods only in the given class (methods defined in its super classes
         are omitted).
 */
+ (NSArray *)gtx_testMethodsInClass:(Class)inClass {
  NSMutableSet *testMethods = [[NSMutableSet alloc] init];
  unsigned int allMethodsCount = 0;
  Method *allMethods = class_copyMethodList(inClass, &allMethodsCount);
  for (unsigned int i = 0; i < allMethodsCount; i++) {
    SEL methodSel = method_getName(allMethods[i]);
    NSString *methodName = NSStringFromSelector(methodSel);
    if ([methodName hasPrefix:@"test"]) {
      [testMethods addObject:methodName];
    }
  }
  free(allMethods);
  return [testMethods allObjects];
}

@end
