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

#import "GTXToolKit.h"
#import "GTXAnalytics.h"
#import "GTXBlacklistFactory.h"
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

- (void)testRegisterCheckRaisesExceptionForDuplicateCheckNames {
  GTXToolKit *toolkit = [[GTXToolKit alloc] init];
  NSString *checkName = @"foo";
  [toolkit registerCheck:[GTXToolKit checkWithName:checkName block:noOpCheckBlock]];
  XCTAssertThrows([toolkit registerCheck:[GTXToolKit checkWithName:checkName
                                                             block:noOpCheckBlock]]);
}

- (void)testCheckElementReportsFailures {
  GTXToolKit *toolkit = [[GTXToolKit alloc] init];
  NSObject *failingElement = [self newAccessibleElement];
  NSObject *passingElement = [self newAccessibleElement];
  id<GTXChecking> check = [GTXToolKit checkWithName:@"Foo"
                                              block:^BOOL(id _Nonnull element,
                                                          GTXErrorRefType errorOrNil) {
                                                return element == passingElement;
                                              }];
  [toolkit registerCheck:check];
  NSError *error;
  XCTAssertTrue([toolkit checkElement:passingElement error:nil]);
  XCTAssertTrue([toolkit checkElement:passingElement error:&error]);
  XCTAssertFalse([toolkit checkElement:failingElement error:nil]);
  XCTAssertFalse([toolkit checkElement:failingElement error:&error]);
}

- (void)testCheckElementsFromRootElementsReportsFailures {
  GTXToolKit *toolkit = [[GTXToolKit alloc] init];
  NSObject *root = [self newInAccessibleElement];
  NSObject *child1 = [self newAccessibleElement];
  NSObject *child2 = [self newInAccessibleElement];
  id<GTXChecking> checkFailIfChild1 = [GTXToolKit checkWithName:@"Foo"
                                                           block:^BOOL(id _Nonnull element,
                                                                       GTXErrorRefType errorOrNil) {
                                                             return element != child1;
                                                           }];
  [self createTreeFromPreOrderTraversal:@[root,
                                                  child1, child2, [NSNull null],
                                                  ]];
  [toolkit registerCheck:checkFailIfChild1];
  NSError *error;
  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[root] error:nil]);
  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[root] error:&error]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[child2] error:nil]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[child2] error:&error]);
}

- (void)testCheckElementsFromRootElementsSkipsHiddenAXElements {
  GTXToolKit *toolkit = [[GTXToolKit alloc] init];
  NSObject *root = [self newAccessibleElement];
  // Since root is an accessibile element its children are hidden.
  NSObject *child1 = [self newAccessibleElement];
  NSObject *child2 = [self newInAccessibleElement];
  id<GTXChecking> checkFailIfChild1 = [GTXToolKit checkWithName:@"Foo"
                                                          block:^BOOL(id _Nonnull element,
                                                                      GTXErrorRefType errorOrNil) {
                                                            return element != child1;
                                                          }];
  [self createTreeFromPreOrderTraversal:@[root,
                                                  child1, child2, [NSNull null],
                                                  ]];
  [toolkit registerCheck:checkFailIfChild1];
  NSError *error;
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[root] error:nil]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[root] error:&error]);
}

- (void)testBlacklistAPICanSkipElementsFromChecks {
  GTXToolKit *toolkit = [[GTXToolKit alloc] init];
  NSObject *failingElement = [self newAccessibleElement];
  id<GTXChecking> check = [GTXToolKit checkWithName:@"Foo"
                                              block:^BOOL(id _Nonnull element,
                                                          GTXErrorRefType errorOrNil) {
                                                return NO;
                                              }];
  [toolkit registerCheck:check];
  XCTAssertFalse([toolkit checkElement:failingElement error:nil]);
  [toolkit registerBlacklist:
      [GTXBlacklistFactory blacklistWithClassName:NSStringFromClass([failingElement class])]];
  XCTAssertTrue([toolkit checkElement:failingElement error:nil]);
}

- (void)testBlacklistAPICanSkipElementsFromSpecificChecks {
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
  id<GTXChecking> check1 = [GTXToolKit checkWithName:check1Name
                                               block:^BOOL(id _Nonnull element,
                                                           GTXErrorRefType errorOrNil) {
                                                 return NO;
                                               }];
  id<GTXChecking> check2 = [GTXToolKit checkWithName:check2Name
                                               block:^BOOL(id _Nonnull element,
                                                           GTXErrorRefType errorOrNil) {
                                                 return element != allChecksFailingElement;
                                               }];

  GTXToolKit *toolkit1 = [[GTXToolKit alloc] init];
  [toolkit1 registerCheck:check1];
  [toolkit1 registerCheck:check2];
  XCTAssertFalse([toolkit1 checkElement:check1FailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:allChecksFailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:check3FailingElement error:nil]);

  [toolkit1 registerBlacklist:
      [GTXBlacklistFactory blacklistWithAccessibilityIdentifier:@"check3FailingElement"
                                                      checkName:check1Name]];
  XCTAssertFalse([toolkit1 checkElement:check1FailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:allChecksFailingElement error:nil]);
  XCTAssertTrue([toolkit1 checkElement:check3FailingElement error:nil]);

  [toolkit1 registerBlacklist:
      [GTXBlacklistFactory blacklistWithClassName:NSStringFromClass([check1FailingElement class])]];
  [toolkit1 registerBlacklist:
      [GTXBlacklistFactory blacklistWithClassName:NSStringFromClass([check1FailingElement class])]];
  XCTAssertTrue([toolkit1 checkElement:check1FailingElement error:nil]);
  XCTAssertFalse([toolkit1 checkElement:allChecksFailingElement error:nil]);
  XCTAssertTrue([toolkit1 checkElement:check3FailingElement error:nil]);

  NSString *allChecksFailingElementClass = NSStringFromClass([allChecksFailingElement class]);
  [toolkit1 registerBlacklist:
      [GTXBlacklistFactory blacklistWithClassName:allChecksFailingElementClass]];
  XCTAssertTrue([toolkit1 checkElement:allChecksFailingElement error:nil]);
}

@end
