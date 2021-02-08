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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GTXAnalytics.h"
#import "GTXExcludeListFactory.h"
#import "GTXToolKit.h"
#import "GTXBaseTestCase.h"

@interface GTXTestElementClass1 : UIAccessibilityElement
@end

@implementation GTXTestElementClass1
@end

@interface GTXTestElementClass2 : UIAccessibilityElement
@end

@implementation GTXTestElementClass2
@end

@interface GTXTestElementClass3 : UIAccessibilityElement
@end

@implementation GTXTestElementClass3
@end

@interface GTXToolKitTests : GTXBaseTestCase
@end

@implementation GTXToolKitTests

- (void)testToolkitCreationMethods {
  XCTAssertNotNil([GTXToolKit defaultToolkit]);
  XCTAssertNotNil([GTXToolKit toolkitWithNoChecks]);
  XCTAssertNotNil([GTXToolKit toolkitWithAllDefaultChecks]);
}

- (void)testRegisterCheckRaisesExceptionForDuplicateCheckNames {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSString *checkName = @"foo";
  [toolkit registerCheck:[GTXToolKit checkWithName:checkName block:gNoOpCheckBlock]];
  XCTAssertThrows([toolkit registerCheck:[GTXToolKit checkWithName:checkName
                                                             block:gNoOpCheckBlock]]);
}

- (void)testCheckElementReportsFailures {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSObject *failingElement = [self newAccessibleElement];
  NSObject *passingElement = [self newAccessibleElement];
  id<GTXChecking> check =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element == passingElement;
                          }];
  [toolkit registerCheck:check];
  [self gtxtest_assertElement:passingElement succeedsWhenCheckedWithToolkit:toolkit];
  [self gtxtest_assertElement:failingElement failsWhenCheckedWithToolkit:toolkit];
}

- (void)testCheckElementReportsFailuresOnViews {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  UIView *failingElement = [self newTestViewObject];
  UIView *passingElement = [self newTestViewObject];
  UIWindow *testWindow = [[UIWindow alloc] init];
  [testWindow addSubview:failingElement];
  [testWindow addSubview:passingElement];
  id<GTXChecking> check =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element == passingElement;
                          }];
  [toolkit registerCheck:check];
  [self gtxtest_assertElement:passingElement succeedsWhenCheckedWithToolkit:toolkit];
  [self gtxtest_assertElement:failingElement failsWhenCheckedWithToolkit:toolkit];
}

- (void)testChecksCanSkipElementsNotInViewHierarchy {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  UIView *failingElement = [self newTestViewObject];
  id<GTXChecking> failingCheck =
      [GTXToolKit checkWithName:@"Foo"
                 requiresWindow:YES
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  [toolkit registerCheck:failingCheck];
  [self gtxtest_assertElement:failingElement succeedsWhenCheckedWithToolkit:toolkit];
}

- (void)testCheckElementsFromRootElementsReportsFailures {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSObject *root = [self newInaccessibleElement];
  NSObject *child1 = [self newAccessibleElement];
  NSObject *child2 = [self newInaccessibleElement];
  id<GTXChecking> checkFailIfChild1 =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element != child1;
                          }];
  [self createTreeFromPreOrderTraversal:@[
    root,
    child1,
    child2,
    [NSNull null],
  ]];
  [toolkit registerCheck:checkFailIfChild1];
  NSError *error;
  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[ root ] error:nil]);
  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[ root ] error:&error]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ child2 ] error:nil]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ child2 ] error:&error]);
}

- (void)testResultFromCheckingAllElementsFromRootElementsReportsFailures {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSObject *root = [self newInaccessibleElement];
  NSObject *child1 = [self newAccessibleElement];
  NSObject *child2 = [self newInaccessibleElement];
  id<GTXChecking> checkFailIfChild1 =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element != child1;
                          }];
  [self createTreeFromPreOrderTraversal:@[
    root,
    child1,
    child2,
    [NSNull null],
  ]];
  [toolkit registerCheck:checkFailIfChild1];
  XCTAssertFalse(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ root ]] allChecksPassed]);
  XCTAssertTrue(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ child2 ]] allChecksPassed]);
}

- (void)testCheckElementsFromRootElementsSkipsHiddenAXElements {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSObject *root = [self newAccessibleElement];
  // Since root is an accessibile element its children are hidden.
  NSObject *child1 = [self newAccessibleElement];
  NSObject *child2 = [self newInaccessibleElement];
  id<GTXChecking> checkFailIfChild1 =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element != child1;
                          }];
  [self createTreeFromPreOrderTraversal:@[
    root,
    child1,
    child2,
    [NSNull null],
  ]];
  [toolkit registerCheck:checkFailIfChild1];
  NSError *error;
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ root ] error:nil]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ root ] error:&error]);
}

- (void)testResultFromCheckingAllElementsFromRootElementsSkipsHiddenAXElements {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSObject *root = [self newAccessibleElement];
  // Since root is an accessibile element its children are hidden.
  NSObject *child1 = [self newAccessibleElement];
  NSObject *child2 = [self newInaccessibleElement];
  id<GTXChecking> checkFailIfChild1 =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element != child1;
                          }];
  [self createTreeFromPreOrderTraversal:@[
    root,
    child1,
    child2,
    [NSNull null],
  ]];
  [toolkit registerCheck:checkFailIfChild1];
  XCTAssertTrue(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ root ]] allChecksPassed]);
}

- (void)testExcludeListAPICanSkipElementsFromChecks {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  NSObject *failingElement = [self newAccessibleElement];
  id<GTXChecking> check =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  [toolkit registerCheck:check];
  XCTAssertFalse([toolkit checkElement:failingElement error:nil]);
  [toolkit
      registerExcludeList:[GTXExcludeListFactory
                              excludeListWithClassName:NSStringFromClass([failingElement class])]];
  XCTAssertTrue([toolkit checkElement:failingElement error:nil]);
}

- (void)testExcludeListAPICanSkipElementsFromSpecificChecks {
  GTXTestElementClass1 *check1FailingElement = [[GTXTestElementClass1 alloc] init];
  check1FailingElement.isAccessibilityElement = YES;
  check1FailingElement.accessibilityIdentifier = @"check1FailingElement";

  GTXTestElementClass2 *allChecksFailingElement = [[GTXTestElementClass2 alloc] init];
  allChecksFailingElement.isAccessibilityElement = YES;

  GTXTestElementClass3 *check3FailingElement = [[GTXTestElementClass3 alloc] init];
  check3FailingElement.isAccessibilityElement = YES;
  check3FailingElement.accessibilityIdentifier = @"check3FailingElement";

  NSString *check1Name = @"Check 1";
  NSString *check2Name = @"Check 2";
  id<GTXChecking> check1 =
      [GTXToolKit checkWithName:check1Name
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  id<GTXChecking> check2 =
      [GTXToolKit checkWithName:check2Name
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element != allChecksFailingElement;
                          }];

  GTXToolKit *toolkit1 = [GTXToolKit toolkitWithNoChecks];
  [toolkit1 registerCheck:check1];
  [toolkit1 registerCheck:check2];
  XCTAssertFalse([toolkit1 checkElement:check1FailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:allChecksFailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:check3FailingElement error:nil]);

  [toolkit1 registerExcludeList:[GTXExcludeListFactory
                                    excludeListWithAccessibilityIdentifier:@"check3FailingElement"
                                                                 checkName:check1Name]];
  XCTAssertFalse([toolkit1 checkElement:check1FailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:allChecksFailingElement error:nil]);
  XCTAssertTrue([toolkit1 checkElement:check3FailingElement error:nil]);

  [toolkit1 registerExcludeList:[GTXExcludeListFactory
                                    excludeListWithClassName:NSStringFromClass(
                                                                 [check1FailingElement class])]];
  [toolkit1 registerExcludeList:[GTXExcludeListFactory
                                    excludeListWithClassName:NSStringFromClass(
                                                                 [check1FailingElement class])]];
  XCTAssertTrue([toolkit1 checkElement:check1FailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:allChecksFailingElement error:nil]);
  XCTAssertTrue([toolkit1 checkElement:check3FailingElement error:nil]);

  NSString *allChecksFailingElementClass = NSStringFromClass([allChecksFailingElement class]);
  [toolkit1 registerExcludeList:[GTXExcludeListFactory
                                    excludeListWithClassName:allChecksFailingElementClass]];
  XCTAssertTrue([toolkit1 checkElement:allChecksFailingElement error:nil]);
}

- (void)testElementsWithNilWindowAreIgnored {
  UIView *viewWithoutWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  viewWithoutWindow.isAccessibilityElement = YES;
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  id<GTXChecking> failingCheck =
      [GTXToolKit checkWithName:@"Failing Check"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  [toolkit registerCheck:failingCheck];
  XCTAssertTrue([toolkit checkElement:viewWithoutWindow error:nil]);
}

- (void)testElementsWithNonNilWindowAreChecked {
  UIView *viewWithWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  viewWithWindow.isAccessibilityElement = YES;
  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [window addSubview:viewWithWindow];
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  id<GTXChecking> failingCheck =
      [GTXToolKit checkWithName:@"Failing Check"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  [toolkit registerCheck:failingCheck];
  XCTAssertFalse([toolkit checkElement:viewWithWindow error:nil]);
}

#pragma mark - Private

// Asserts that the given @c element passes all checks registered on @c toolkit.
- (void)gtxtest_assertElement:(id)element succeedsWhenCheckedWithToolkit:(GTXToolKit *)toolkit {
  XCTAssertTrue([toolkit checkElement:element error:nil]);
  // Also verify API works with error object.
  NSError *error;
  XCTAssertTrue([toolkit checkElement:element error:&error]);
  XCTAssertNil(error);
}

// Asserts that the given @c element fails one or more checks registered on @c toolkit.
- (void)gtxtest_assertElement:(id)element failsWhenCheckedWithToolkit:(GTXToolKit *)toolkit {
  XCTAssertFalse([toolkit checkElement:element error:nil]);
  // Also verify API works with error object.
  NSError *error;
  XCTAssertFalse([toolkit checkElement:element error:&error]);
  XCTAssertNotNil(error);
}

@end
