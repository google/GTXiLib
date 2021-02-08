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

#import "GTXHierarchyResultCollection.h"

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "NSError+GTXAdditions.h"
#import "GTXBaseTestCase.h"

@interface GTXHierarchyResultCollectionTests : GTXBaseTestCase

/**
 * A nonnil image to initialize @c GTXHierarchyResultCollection instances.
 */
@property(strong, nonatomic) UIImage *dummyImage;

/**
 * A nonnil element reference to initialize @c GTXElementResultCollection instances.
 */
@property(strong, nonatomic) GTXElementReference *dummyElementReference;

/**
 * A nonnil check result to initialize @c GTXElementResultCollection instances.
 */
@property(strong, nonatomic) GTXCheckResult *dummyCheckResult;

@end

@implementation GTXHierarchyResultCollectionTests

- (void)setUp {
  [super setUp];
  self.dummyImage = [[UIImage alloc] init];
  self.dummyElementReference =
      [[GTXElementReference alloc] initWithElementAddress:0
                                             elementClass:[UIView class]
                                       accessibilityLabel:@"View"
                                  accessibilityIdentifier:@"Identifier:"
                                       accessibilityFrame:CGRectMake(0, 0, 10, 10)
                                       elementDescription:@"Element"];
  self.dummyCheckResult = [[GTXCheckResult alloc] initWithCheckName:@"Check Name"
                                                   errorDescription:@"Error Description"];
}

- (void)testHierarchyResultCollectionFromErrorZeroViewsFails {
  XCTAssertThrows([[GTXHierarchyResultCollection alloc] initWithErrors:@[] rootViews:@[]]);
}

- (void)testHierarchyResultCollectionFromErrorZeroErrorsSucceeds {
  UIView *view = [self newAccessibleViewWithPropertiesSet];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithErrors:@[] rootViews:@[ view ]];
  XCTAssertEqual(result.elementResults.count, 0);
}

- (void)testHierarchyResultCollectionFromErrorNilErrorsSucceeds {
  UIView *view = [self newAccessibleViewWithPropertiesSet];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithErrors:nil rootViews:@[ view ]];
  XCTAssertEqual(result.elementResults.count, 0);
}

- (void)testHierarchyResultCollectionFromErrorEmptyErrorUserInfoFails {
  NSError *emptyUserInfoError = [NSError errorWithDomain:kGTXTestErrorDomain
                                                    code:kGTXTestErrorCode
                                                userInfo:nil];
  XCTAssertThrows([[GTXHierarchyResultCollection alloc] initWithErrors:@[ emptyUserInfoError ]
                                                             rootViews:@[]]);
}

- (void)testHierarchyResultCollectionFromErrorOneElementOneCheckSucceeds {
  UIView *element = [self newAccessibleViewWithPropertiesSet];
  NSDictionary<NSString *, id> *checkErrorUserInfo = @{
    kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName,
    NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription
  };
  NSError *checkError = [NSError errorWithDomain:kGTXTestErrorDomain
                                            code:kGTXTestErrorCode
                                        userInfo:checkErrorUserInfo];
  NSError *error = [NSError errorWithDomain:kGTXTestErrorDomain
                                       code:kGTXTestErrorCode
                                   userInfo:@{
                                     kGTXErrorFailingElementKey : element,
                                     kGTXErrorUnderlyingErrorsKey : @[ checkError ]
                                   }];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithErrors:@[ error ] rootViews:@[ element ]];
  XCTAssertEqual(result.elementResults.count, 1);
  GTXElementResultCollection *elementResult = result.elementResults[0];
  [self assertElementReference:elementResult.elementReference refersToElement:element];
  XCTAssertEqual(elementResult.checkResults.count, 1);
  XCTAssertEqualObjects(elementResult.checkResults[0].checkName,
                        kGTXTestAccessibilityLabelMissingCheckName);
  XCTAssertEqualObjects(elementResult.checkResults[0].errorDescription,
                        kGTXTestAccessibilityLabelMissingCheckDescription);
  XCTAssertTrue(CGSizeEqualToSize(result.screenshot.size, element.bounds.size));
}

- (void)testHierarchyResultCollectionFromErrorManyElementsOneCheckSucceeds {
  UIView *element1 = [self newAccessibleViewWithPropertiesSet];
  UIView *element2 = [self newAccessibleViewWithPropertiesSet];
  element1.bounds = CGRectMake(0, 0, 20, 10);
  element2.bounds = CGRectMake(0, 0, 10, 30);
  NSDictionary<NSString *, id> *checkErrorUserInfo = @{
    kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName,
    NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription
  };
  NSError *checkError = [NSError errorWithDomain:kGTXTestErrorDomain
                                            code:kGTXTestErrorCode
                                        userInfo:checkErrorUserInfo];
  NSError *error1 = [NSError errorWithDomain:kGTXTestErrorDomain
                                        code:kGTXTestErrorCode
                                    userInfo:@{
                                      kGTXErrorFailingElementKey : element1,
                                      kGTXErrorUnderlyingErrorsKey : @[ checkError ]
                                    }];
  NSError *error2 = [NSError errorWithDomain:kGTXTestErrorDomain
                                        code:kGTXTestErrorCode
                                    userInfo:@{
                                      kGTXErrorFailingElementKey : element2,
                                      kGTXErrorUnderlyingErrorsKey : @[ checkError ]
                                    }];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithErrors:@[ error1, error2 ]
                                                 rootViews:@[ element1, element2 ]];
  XCTAssertEqual(result.elementResults.count, 2);
  [self assertElementReference:result.elementResults[0].elementReference refersToElement:element1];
  [self assertElementReference:result.elementResults[1].elementReference refersToElement:element2];
  for (GTXElementResultCollection *elementResult in result.elementResults) {
    XCTAssertEqual(elementResult.checkResults.count, 1);
    XCTAssertEqualObjects(elementResult.checkResults[0].checkName,
                          kGTXTestAccessibilityLabelMissingCheckName);
    XCTAssertEqualObjects(elementResult.checkResults[0].errorDescription,
                          kGTXTestAccessibilityLabelMissingCheckDescription);
  }
  CGSize enclosingSize = CGSizeMake(element1.bounds.size.width, element2.bounds.size.height);
  XCTAssertTrue(CGSizeEqualToSize(result.screenshot.size, enclosingSize));
}

- (void)testHierarchyResultCollectionFromErrorOneElementManyCheckSucceeds {
  NSString *insufficientTouchTargetSizeCheckName = @"insufficient touch target size";
  NSString *insufficientTouchTargetSizeCheckDescription =
      @"element has insufficient touch target size";
  UIView *element = [self newAccessibleViewWithPropertiesSet];
  NSDictionary<NSString *, id> *checkErrorUserInfo1 = @{
    kGTXErrorCheckNameKey : kGTXTestAccessibilityLabelMissingCheckName,
    NSLocalizedDescriptionKey : kGTXTestAccessibilityLabelMissingCheckDescription
  };
  NSDictionary<NSString *, id> *checkErrorUserInfo2 = @{
    kGTXErrorCheckNameKey : insufficientTouchTargetSizeCheckName,
    NSLocalizedDescriptionKey : insufficientTouchTargetSizeCheckDescription
  };
  NSError *checkError1 = [NSError errorWithDomain:kGTXTestErrorDomain
                                             code:kGTXTestErrorCode
                                         userInfo:checkErrorUserInfo1];
  NSError *checkError2 = [NSError errorWithDomain:kGTXTestErrorDomain
                                             code:kGTXTestErrorCode
                                         userInfo:checkErrorUserInfo2];
  NSError *error = [NSError errorWithDomain:kGTXTestErrorDomain
                                       code:kGTXTestErrorCode
                                   userInfo:@{
                                     kGTXErrorFailingElementKey : element,
                                     kGTXErrorUnderlyingErrorsKey : @[ checkError1, checkError2 ]
                                   }];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithErrors:@[ error ] rootViews:@[ element ]];
  XCTAssertEqual(result.elementResults.count, 1);
  GTXElementResultCollection *elementResult = result.elementResults[0];
  [self assertElementReference:elementResult.elementReference refersToElement:element];
  XCTAssertEqual(elementResult.checkResults.count, 2);
  XCTAssertEqualObjects(elementResult.checkResults[0].checkName,
                        kGTXTestAccessibilityLabelMissingCheckName);
  XCTAssertEqualObjects(elementResult.checkResults[0].errorDescription,
                        kGTXTestAccessibilityLabelMissingCheckDescription);
  XCTAssertEqualObjects(elementResult.checkResults[1].checkName,
                        insufficientTouchTargetSizeCheckName);
  XCTAssertEqualObjects(elementResult.checkResults[1].errorDescription,
                        insufficientTouchTargetSizeCheckDescription);
  XCTAssertTrue(CGSizeEqualToSize(result.screenshot.size, element.bounds.size));
}

- (void)testIssueCountZeroElementResults {
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithElementResults:@[] screenshot:self.dummyImage];
  NSUInteger expectedCheckResultCount = 0;
  XCTAssertEqual([result checkResultCount], expectedCheckResultCount);
}

- (void)testIssueCountOneElementResultOneCheckResult {
  GTXElementResultCollection *elementResult =
      [[GTXElementResultCollection alloc] initWithElement:self.dummyElementReference
                                             checkResults:@[ self.dummyCheckResult ]];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithElementResults:@[ elementResult ]
                                                        screenshot:self.dummyImage];
  NSUInteger expectedCheckResultCount = 1;
  XCTAssertEqual([result checkResultCount], expectedCheckResultCount);
}

- (void)testIssueCountOneElementResultManyCheckResults {
  GTXElementResultCollection *elementResult = [[GTXElementResultCollection alloc]
      initWithElement:self.dummyElementReference
         checkResults:@[ self.dummyCheckResult, self.dummyCheckResult, self.dummyCheckResult ]];
  GTXHierarchyResultCollection *result =
      [[GTXHierarchyResultCollection alloc] initWithElementResults:@[ elementResult ]
                                                        screenshot:self.dummyImage];
  NSUInteger expectedCheckResultCount = 3;
  XCTAssertEqual([result checkResultCount], expectedCheckResultCount);
}

- (void)testIssueCountManyElementResultsOneCheckResult {
  GTXElementResultCollection *elementResult =
      [[GTXElementResultCollection alloc] initWithElement:self.dummyElementReference
                                             checkResults:@[ self.dummyCheckResult ]];
  GTXHierarchyResultCollection *result = [[GTXHierarchyResultCollection alloc]
      initWithElementResults:@[ elementResult, elementResult, elementResult ]
                  screenshot:self.dummyImage];
  NSUInteger expectedCheckResultCount = 3;
  XCTAssertEqual([result checkResultCount], expectedCheckResultCount);
}

- (void)testIssueCountManyElementResultsManyCheckResults {
  GTXElementResultCollection *elementResult1 = [[GTXElementResultCollection alloc]
      initWithElement:self.dummyElementReference
         checkResults:@[ self.dummyCheckResult, self.dummyCheckResult, self.dummyCheckResult ]];
  GTXElementResultCollection *elementResult2 =
      [[GTXElementResultCollection alloc] initWithElement:self.dummyElementReference
                                             checkResults:@[ self.dummyCheckResult ]];
  GTXElementResultCollection *elementResult3 = [[GTXElementResultCollection alloc]
      initWithElement:self.dummyElementReference
         checkResults:@[ self.dummyCheckResult, self.dummyCheckResult ]];
  GTXHierarchyResultCollection *result = [[GTXHierarchyResultCollection alloc]
      initWithElementResults:@[ elementResult1, elementResult2, elementResult3 ]
                  screenshot:self.dummyImage];
  NSUInteger expectedCheckResultCount = 6;
  XCTAssertEqual([result checkResultCount], expectedCheckResultCount);
}

@end
