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
#import "GTXAnalyticsUtils.h"
#import "GTXToolKit.h"
#import "GTXBaseTestCase.h"

@interface GTXAnalyticsTests : GTXBaseTestCase
@end

@implementation GTXAnalyticsTests {
  BOOL prevAnalyticsEnabled;
  GTXAnalyticsHandlerBlock prevAnalyticsHandler;
}

- (void)setUp {
  [super setUp];

  prevAnalyticsEnabled = GTXAnalytics.enabled;
  prevAnalyticsHandler = GTXAnalytics.handler;
}

- (void)tearDown {
  GTXAnalytics.enabled = prevAnalyticsEnabled;
  GTXAnalytics.handler = prevAnalyticsHandler;

  [super tearDown];
}

- (void)testClientIDIsAccurate {
  NSString *expectedClientID = @"90940a64d60ad6c98c3fb6c6307e1d36";
  XCTAssertEqualObjects(expectedClientID,
                        [GTXAnalyticsUtils clientIDForBundleID:@"com.google.gtx.test"]);
}

- (void)testCheckElementReportsAnalyticsCorrectly {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  __block NSInteger successEventsCount = 0;
  __block NSInteger failureEventsCount = 0;
  [GTXAnalytics setHandler:^(GTXAnalyticsEvent event) {
    if (event == GTXAnalyticsEventChecksPerformed) {
      successEventsCount += 1;
    } else {
      failureEventsCount += 1;
    }
  }];
  NSObject *failingElement = [self newAccessibleElement];
  NSObject *passingElement = [self newAccessibleElement];
  id<GTXChecking> check =
      [GTXToolKit checkWithName:@"Foo"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return element == passingElement;
                          }];
  [toolkit registerCheck:check];
  NSError *error;
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 0);

  XCTAssertTrue([toolkit checkElement:passingElement error:nil]);
  XCTAssertEqual(successEventsCount, 1);
  XCTAssertEqual(failureEventsCount, 0);

  XCTAssertTrue([toolkit checkElement:passingElement error:&error]);
  XCTAssertEqual(successEventsCount, 2);
  XCTAssertEqual(failureEventsCount, 0);

  XCTAssertFalse([toolkit checkElement:failingElement error:nil]);
  XCTAssertEqual(successEventsCount, 2);
  XCTAssertEqual(failureEventsCount, 1);

  XCTAssertFalse([toolkit checkElement:failingElement error:&error]);
  XCTAssertEqual(successEventsCount, 2);
  XCTAssertEqual(failureEventsCount, 2);
}

- (void)testCheckElementsFromRootElementsReportsAnalyticsCorrectly {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  __block NSInteger successEventsCount = 0;
  __block NSInteger failureEventsCount = 0;
  [GTXAnalytics setHandler:^(GTXAnalyticsEvent event) {
    if (event == GTXAnalyticsEventChecksPerformed) {
      successEventsCount += 1;
    } else {
      failureEventsCount += 1;
    }
  }];
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
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 0);

  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[ root ] error:nil]);
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 1);

  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[ root ] error:&error]);
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 2);

  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ child2 ] error:nil]);
  XCTAssertEqual(successEventsCount, 1);
  XCTAssertEqual(failureEventsCount, 2);

  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ child2 ] error:&error]);
  XCTAssertEqual(successEventsCount, 2);
  XCTAssertEqual(failureEventsCount, 2);
}

- (void)testResultFromCheckingAllElementsFromRootElementsReportsAnalyticsCorrectly {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  __block NSInteger successEventsCount = 0;
  __block NSInteger failureEventsCount = 0;
  [GTXAnalytics setHandler:^(GTXAnalyticsEvent event) {
    if (event == GTXAnalyticsEventChecksPerformed) {
      successEventsCount += 1;
    } else {
      failureEventsCount += 1;
    }
  }];
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
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 0);

  XCTAssertFalse(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ root ]] allChecksPassed]);
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 1);

  XCTAssertFalse(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ root ]] allChecksPassed]);
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 2);

  XCTAssertTrue(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ child2 ]] allChecksPassed]);
  XCTAssertEqual(successEventsCount, 1);
  XCTAssertEqual(failureEventsCount, 2);

  XCTAssertTrue(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ child2 ]] allChecksPassed]);
  XCTAssertEqual(successEventsCount, 2);
  XCTAssertEqual(failureEventsCount, 2);
}

- (void)testAnalyticsCanBeDisabled {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  __block NSInteger successEventsCount = 0;
  __block NSInteger failureEventsCount = 0;
  [GTXAnalytics setHandler:^(GTXAnalyticsEvent event) {
    if (event == GTXAnalyticsEventChecksPerformed) {
      successEventsCount += 1;
    } else {
      failureEventsCount += 1;
    }
  }];

  GTXAnalytics.enabled = NO;

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
  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 0);

  XCTAssertTrue([toolkit checkElement:root error:nil]);
  XCTAssertTrue([toolkit checkElement:root error:&error]);
  XCTAssertFalse([toolkit checkElement:child1 error:nil]);
  XCTAssertFalse([toolkit checkElement:child1 error:&error]);
  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[ root ] error:nil]);
  XCTAssertFalse([toolkit checkAllElementsFromRootElements:@[ root ] error:&error]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ child2 ] error:nil]);
  XCTAssertTrue([toolkit checkAllElementsFromRootElements:@[ child2 ] error:&error]);
  XCTAssertFalse(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ root ]] allChecksPassed]);
  XCTAssertTrue(
      [[toolkit resultFromCheckingAllElementsFromRootElements:@[ child2 ]] allChecksPassed]);

  XCTAssertEqual(successEventsCount, 0);
  XCTAssertEqual(failureEventsCount, 0);
}

- (void)testInvokingDefaultAnalyticsHandlerFailsWhenAnalyticsDisabled {
  GTXAnalytics.enabled = NO;
  XCTAssertThrows(GTXAnalytics.handler(GTXAnalyticsEventChecksPerformed));
  XCTAssertThrows(GTXAnalytics.handler(GTXAnalyticsEventChecksFailed));
}

@end
