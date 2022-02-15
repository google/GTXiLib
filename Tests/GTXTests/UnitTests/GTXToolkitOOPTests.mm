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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GTXAnalytics.h"
#import "GTXToolKit.h"
#import "GTXToolKit+GTXOOPAdditions.h"
#include "metadata_map.h"
#include "typedefs.h"
#include "check.h"
#include "error_message.h"
#include "gtxtest_always_failing_check.h"
#include "gtxtest_always_passing_check.h"
#import "GTXBaseTestCase.h"

#pragma mark - Test Classes

@interface GTXToolkitOOPTests : GTXBaseTestCase
@end

@implementation GTXToolkitOOPTests

- (void)testToolkitReportsFailuresFromFailingChecks {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  std::unique_ptr<gtx::Check> check =
      std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("failingCheck"));
  [toolkit registerOOPCheck:check];
  XCTAssertFalse([toolkit checkElement:[self newAccessibleElement] error:NULL]);
}

- (void)testToolkitReportsSuccessFromPassingChecks {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  std::unique_ptr<gtx::Check> check =
      std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("passingCheck"));
  [toolkit registerOOPCheck:check];
  XCTAssertTrue([toolkit checkElement:[self newAccessibleElement] error:NULL]);
}

- (void)testToolkitCanMixChecksAndReportsFailuresWhenObjCCheckFails {
  std::unique_ptr<gtx::Check> cppCheck =
      std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("passingCheck"));
  NSObject *testElement = [self newAccessibleElement];
  id<GTXChecking> objCCheck =
      [GTXToolKit checkWithName:@"failingCheck"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  [toolkit registerOOPCheck:cppCheck];
  [toolkit registerCheck:objCCheck];
  XCTAssertFalse([toolkit checkElement:testElement error:NULL]);

  cppCheck = std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("passingCheck"));
  GTXToolKit *toolkitReversed = [GTXToolKit toolkitWithNoChecks];
  // Register objc check first.
  [toolkitReversed registerCheck:objCCheck];
  [toolkitReversed registerOOPCheck:cppCheck];
  XCTAssertFalse([toolkitReversed checkElement:testElement error:NULL]);
}

- (void)testToolkitCanMixChecksAndReportsFailuresWhenCppCheckFails {
  std::unique_ptr<gtx::Check> cppCheck =
      std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("failingCheck"));
  NSObject *testElement = [self newAccessibleElement];
  id<GTXChecking> objCCheck =
      [GTXToolKit checkWithName:@"passingCheck"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return YES;
                          }];
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  [toolkit registerOOPCheck:cppCheck];
  [toolkit registerCheck:objCCheck];
  XCTAssertFalse([toolkit checkElement:testElement error:NULL]);

  // Re-assign cppCheck since it has been invalidated/moved when used.
  cppCheck = std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("failingCheck"));
  GTXToolKit *toolkitReversed = [GTXToolKit toolkitWithNoChecks];
  // Register objc check first.
  [toolkitReversed registerCheck:objCCheck];
  [toolkitReversed registerOOPCheck:cppCheck];
  XCTAssertFalse([toolkitReversed checkElement:testElement error:NULL]);
}

- (void)testToolkitCanMixChecksAndReportsSuccessWhenAllChecksPass {
  std::unique_ptr<gtx::Check> cppCheck =
      std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("passingCheck1"));
  NSObject *testElement = [self newAccessibleElement];
  id<GTXChecking> objCCheck =
      [GTXToolKit checkWithName:@"passingCheck2"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return YES;
                          }];
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  [toolkit registerOOPCheck:cppCheck];
  [toolkit registerCheck:objCCheck];
  XCTAssertTrue([toolkit checkElement:testElement error:NULL]);

  cppCheck = std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("passingCheck1"));
  GTXToolKit *toolkitReversed = [GTXToolKit toolkitWithNoChecks];
  // Register objc check first.
  [toolkitReversed registerCheck:objCCheck];
  [toolkitReversed registerOOPCheck:cppCheck];
  XCTAssertTrue([toolkitReversed checkElement:testElement error:NULL]);
}

- (void)testToolkitCanMixChecksAndReportsFailuresWhenBothChecksFails {
  std::unique_ptr<gtx::Check> cppCheck =
      std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("failingCheck1"));
  NSObject *testElement = [self newAccessibleElement];
  id<GTXChecking> objCCheck =
      [GTXToolKit checkWithName:@"failingCheck2"
                          block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                            return NO;
                          }];
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  [toolkit registerOOPCheck:cppCheck];
  [toolkit registerCheck:objCCheck];
  XCTAssertFalse([toolkit checkElement:testElement error:NULL]);

  cppCheck = std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("failingCheck1"));
  GTXToolKit *toolkitReversed = [GTXToolKit toolkitWithNoChecks];
  // Register objc check first.
  [toolkitReversed registerCheck:objCCheck];
  [toolkitReversed registerOOPCheck:cppCheck];
  XCTAssertFalse([toolkitReversed checkElement:testElement error:NULL]);
}

@end
