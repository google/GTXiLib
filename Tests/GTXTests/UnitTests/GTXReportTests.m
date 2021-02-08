//
// Copyright 2019 Google Inc.
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

#import "GTXReport.h"

@interface GTXReportTests : XCTestCase
@end

@implementation GTXReportTests

- (void)testReportDedupeDetectsUniqueErrors {
  GTXReport *report = [[GTXReport alloc] init];
  GTXError *error = [GTXError errorWithElement:nil
                                     elementID:@"elementID1"
                                     checkName:@"checkName1"
                                    errorTitle:@""
                              errorDescription:@""];
  GTXError *errorSameElementID = [GTXError errorWithElement:nil
                                     elementID:@"elementID1"
                                     checkName:@"checkName2"
                                    errorTitle:@""
                              errorDescription:@""];
  GTXError *errorSameCheckName = [GTXError errorWithElement:nil
                                     elementID:@"elementID2"
                                     checkName:@"checkName1"
                                    errorTitle:@""
                              errorDescription:@""];
  NSArray *errors = @[error, errorSameElementID, errorSameCheckName];
  [report addByDeDupingErrors:errors];
  [self gtxtest_assertReport:report hasErrors:errors];
}

- (void)testReportDedupeDetectsDuplicateErrors {
  GTXReport *report = [[GTXReport alloc] init];
  GTXError *error = [GTXError errorWithElement:nil
                                     elementID:@"elementID"
                                     checkName:@"checkName"
                                    errorTitle:@"error1"
                              errorDescription:@"desc1"];
  // Create duplicate errors - same elementID and checkName but different title/desc.
  GTXError *errorDup1 = [GTXError errorWithElement:nil
                                     elementID:@"elementID"
                                     checkName:@"checkName"
                                    errorTitle:@"error1"
                              errorDescription:@"desc1"];
  GTXError *errorDup2 = [GTXError errorWithElement:nil
                                     elementID:@"elementID"
                                     checkName:@"checkName"
                                    errorTitle:@"error1"
                              errorDescription:@"desc1"];
  NSArray *errors = @[error, errorDup1, errorDup2, error];
  [report addByDeDupingErrors:errors];
  [self gtxtest_assertReport:report hasErrors:@[ error ]];
}

- (void)testReportDedupeDetectsUniqueErrorsWithNilElementID {
  GTXReport *report = [[GTXReport alloc] init];
  GTXError *error = [GTXError errorWithElement:nil
                                     elementID:nil
                                     checkName:@"checkName1"
                                    errorTitle:@"title1"
                              errorDescription:@""];
  GTXError *errorSameCheckName = [GTXError errorWithElement:nil
                                                  elementID:nil
                                                  checkName:@"checkName1"
                                                 errorTitle:@"title2"
                                           errorDescription:@""];
  NSArray *errors = @[error, errorSameCheckName];
  [report addByDeDupingErrors:errors];
  [self gtxtest_assertReport:report hasErrors:errors];
}

- (void)testReportDedupeDetectsUniqueErrorsWithNilCheckName {
  GTXReport *report = [[GTXReport alloc] init];
  GTXError *error = [GTXError errorWithElement:nil
                                     elementID:@"elementID"
                                     checkName:nil
                                    errorTitle:@"title1"
                              errorDescription:@""];
  GTXError *errorSameElementID = [GTXError errorWithElement:nil
                                                  elementID:@"elementID"
                                                  checkName:nil
                                                 errorTitle:@"title2"
                                           errorDescription:@""];
  NSArray *errors = @[error, errorSameElementID];
  [report addByDeDupingErrors:errors];
  [self gtxtest_assertReport:report hasErrors:errors];
}

#pragma mark - Private

- (void)gtxtest_assertReport:(GTXReport *)report hasErrors:(NSArray<GTXError *> *)expectedErrors {
  NSMutableArray *actual = [[NSMutableArray alloc] init];
  [report forEachError:^(GTXError *error) {
    XCTAssertTrue([expectedErrors containsObject:error]);
    [actual addObject:error];
  }];
  XCTAssertEqual(actual.count, expectedErrors.count);
}

@end
