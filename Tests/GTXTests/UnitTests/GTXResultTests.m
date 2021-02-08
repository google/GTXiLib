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

#import "GTXResult.h"
#import "NSError+GTXAdditions.h"
#import "GTXBaseTestCase.h"

static const NSInteger kGTXTestNonZeroElements = 9;

@interface GTXResultTests : XCTestCase
@end

@implementation GTXResultTests

- (void)testResultReportsSuccessForZeroErrorsZeroElementsScanned {
  XCTAssertTrue([[[GTXResult alloc] initWithErrorsFound:@[] elementsScanned:0] allChecksPassed]);
}

- (void)testResultReportsSuccessForZeroErrorsNonZeroElementsScanned {
  XCTAssertTrue([[[GTXResult alloc] initWithErrorsFound:@[]
                                        elementsScanned:kGTXTestNonZeroElements] allChecksPassed]);
}

- (void)testResultResultsInNilAggregateForZeroErrors {
  XCTAssertNil([[[GTXResult alloc] initWithErrorsFound:@[] elementsScanned:0] aggregatedError]);
  XCTAssertNil([[[GTXResult alloc] initWithErrorsFound:@[]
                                       elementsScanned:kGTXTestNonZeroElements] aggregatedError]);
}

- (void)testAggregateErrorContainsIndividualIssuesWithOneIssue {
  NSError *error = [NSError errorWithDomain:kGTXTestErrorDomain code:0 userInfo:nil];
  GTXResult *result = [[GTXResult alloc] initWithErrorsFound:@[ error ]
                                             elementsScanned:kGTXTestNonZeroElements];
  XCTAssertEqualObjects([[result aggregatedError] userInfo][kGTXErrorUnderlyingErrorsKey],
                        @[ error ]);
}

- (void)testAggregateErrorContainsIndividualIssuesWithMultipleIssues {
  NSError *error1 = [NSError errorWithDomain:kGTXTestErrorDomain code:0 userInfo:nil];
  NSError *error2 = [NSError errorWithDomain:kGTXTestErrorDomain code:0 userInfo:nil];
  NSSet *actualErrorsSet = [NSSet setWithObjects:error1, error2, nil];
  GTXResult *result = [[GTXResult alloc] initWithErrorsFound:[actualErrorsSet allObjects]
                                             elementsScanned:kGTXTestNonZeroElements];
  XCTAssertEqualObjects(
      actualErrorsSet,
      [NSSet setWithArray:[[result aggregatedError] userInfo][kGTXErrorUnderlyingErrorsKey]]);
}

@end
