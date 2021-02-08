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

#import "GTXCheckResult.h"

#import <XCTest/XCTest.h>

#import "NSError+GTXAdditions.h"
#import "GTXBaseTestCase.h"

@interface GTXCheckResultTests : XCTestCase
@end

@implementation GTXCheckResultTests

- (void)testCheckResultFromErrorEmptyUserInfoFails {
  NSError *error = [[NSError alloc] initWithDomain:kGTXTestErrorDomain
                                              code:kGTXTestErrorCode
                                          userInfo:nil];
  XCTAssertThrows([GTXCheckResult checkResultFromError:error]);
}

- (void)testCheckResultFromErrorNoNameFails {
  NSDictionary<NSString *, id> *userInfo =
      @{NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription};
  NSError *error = [[NSError alloc] initWithDomain:kGTXTestErrorDomain
                                              code:kGTXTestErrorCode
                                          userInfo:userInfo];
  XCTAssertThrows([GTXCheckResult checkResultFromError:error]);
}

- (void)testCheckResultFromErrorNoDescriptionFails {
  NSDictionary<NSString *, id> *userInfo =
      @{kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName};
  NSError *error = [[NSError alloc] initWithDomain:kGTXTestErrorDomain
                                              code:kGTXTestErrorCode
                                          userInfo:userInfo];
  XCTAssertThrows([GTXCheckResult checkResultFromError:error]);
}

- (void)testCheckResultFromErrorNameAndDescriptionPasses {
  NSDictionary<NSString *, id> *userInfo = @{
    kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName,
    NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription
  };
  NSError *error = [[NSError alloc] initWithDomain:kGTXTestErrorDomain
                                              code:kGTXTestErrorCode
                                          userInfo:userInfo];
  GTXCheckResult *result = [GTXCheckResult checkResultFromError:error];
  XCTAssertEqual(result.checkName, kGTXTestAccessibilityLabelMissingCheckName);
  XCTAssertEqual(result.errorDescription, kGTXTestAccessibilityLabelMissingCheckDescription);
}

@end
