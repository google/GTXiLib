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

#import "GTXElementResultCollection.h"

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "NSError+GTXAdditions.h"
#import "GTXBaseTestCase.h"

@interface GTXElementResultCollectionTests : GTXBaseTestCase
@end

@implementation GTXElementResultCollectionTests

- (void)testElementResultCollectionFromErrorEmptyFails {
  NSError *error = [self gtx_testErrorWithUserInfo:@{}];
  XCTAssertThrows([[GTXElementResultCollection alloc] initWithError:error]);
}

- (void)testElementResultCollectionFromErrorNoUnderylingErrorsFails {
  UIView *element = [self newAccessibleViewWithPropertiesSet];
  NSError *error = [self gtx_testErrorWithUserInfo:@{kGTXErrorFailingElementKey : element}];
  XCTAssertThrows([[GTXElementResultCollection alloc] initWithError:error]);
}

- (void)testElementResultCollectionFromErrorNoElementFails {
  NSDictionary<NSString *, id> *checkErrorUserInfo = @{
    kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName,
    NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription
  };
  NSError *checkError = [self gtx_testErrorWithUserInfo:checkErrorUserInfo];
  NSError *error =
      [self gtx_testErrorWithUserInfo:@{kGTXErrorUnderlyingErrorsKey : @[ checkError ]}];
  XCTAssertThrows([[GTXElementResultCollection alloc] initWithError:error]);
}

- (void)testElementResultCollectionFromErrorOneCheckSucceeds {
  UIView *element = [self newAccessibleViewWithPropertiesSet];
  NSDictionary<NSString *, id> *checkErrorUserInfo = @{
    kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName,
    NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription
  };
  NSError *checkError = [self gtx_testErrorWithUserInfo:checkErrorUserInfo];
  NSError *error = [self gtx_testErrorWithUserInfo:@{
    kGTXErrorFailingElementKey : element,
    kGTXErrorUnderlyingErrorsKey : @[ checkError ]
  }];
  GTXElementResultCollection *result = [[GTXElementResultCollection alloc] initWithError:error];
  [self assertElementReference:result.elementReference refersToElement:element];
  XCTAssertEqualObjects(result.checkResults[0].checkName,
                        kGTXTestAccessibilityLabelMissingCheckName);
  XCTAssertEqualObjects(result.checkResults[0].errorDescription,
                        kGTXTestAccessibilityLabelMissingCheckDescription);
}

#pragma mark - Private

/**
 * Constructs an @c NSError with a test domain and code with the given user info dictionary.
 *
 * @param userInfo The value for the error's @c userInfo.
 * @return An @c NSError object with @c userInfo for its @c userInfo property.
 */
- (NSError *)gtx_testErrorWithUserInfo:(NSDictionary<NSString *, id> *)userInfo {
  return [NSError errorWithDomain:kGTXTestErrorDomain code:kGTXTestErrorCode userInfo:userInfo];
}

@end
