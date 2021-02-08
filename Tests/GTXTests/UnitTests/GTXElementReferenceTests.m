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

#import "GTXElementReference.h"

#import <XCTest/XCTest.h>

#import "NSError+GTXAdditions.h"
#import "GTXBaseTestCase.h"

static NSString *const kGTXTestAccessibilityLabel = @"Share";

static NSString *const kGTXTestAccessibilityIdentifier = @"kGTXTestShareButton";

@interface GTXElementReferenceTests : XCTestCase
@end

@implementation GTXElementReferenceTests

- (void)testInitWithElementSucceeds {
  CGRect frame = CGRectMake(0, 0, 10, 10);
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.accessibilityFrame = frame;
  view.accessibilityLabel = kGTXTestAccessibilityLabel;
  view.accessibilityIdentifier = kGTXTestAccessibilityIdentifier;
  GTXElementReference *elementReference = [[GTXElementReference alloc] initWithElement:view];
  XCTAssertEqual(elementReference.elementAddress, (NSUInteger)view);
  XCTAssertEqual(elementReference.elementClass, [view class]);
  XCTAssertEqualObjects(elementReference.accessibilityLabel, view.accessibilityLabel);
  XCTAssertEqualObjects(elementReference.accessibilityIdentifier, view.accessibilityIdentifier);
  XCTAssertTrue(CGRectEqualToRect(elementReference.accessibilityFrame, frame));
}

- (void)testInitWithErrorNoUserInfoFails {
  NSError *error = [NSError errorWithDomain:kGTXTestErrorDomain
                                       code:kGTXTestErrorCode
                                   userInfo:nil];
  XCTAssertThrows([[GTXElementReference alloc] initWithError:error]);
}

- (void)testInitWithErrorUIViewSucceeds {
  CGRect frame = CGRectMake(0, 0, 10, 10);
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.accessibilityFrame = frame;
  view.accessibilityLabel = kGTXTestAccessibilityLabel;
  view.accessibilityIdentifier = kGTXTestAccessibilityIdentifier;
  NSDictionary<NSString *, id> *userInfo = @{kGTXErrorFailingElementKey : view};
  NSError *error = [NSError errorWithDomain:kGTXTestErrorDomain
                                       code:kGTXTestErrorCode
                                   userInfo:userInfo];
  GTXElementReference *elementReference = [[GTXElementReference alloc] initWithError:error];
  XCTAssertEqual(elementReference.elementAddress, (NSUInteger)view);
  XCTAssertEqual(elementReference.elementClass, [view class]);
  XCTAssertEqualObjects(elementReference.accessibilityLabel, view.accessibilityLabel);
  XCTAssertEqualObjects(elementReference.accessibilityIdentifier, view.accessibilityIdentifier);
  XCTAssertTrue(CGRectEqualToRect(elementReference.accessibilityFrame, frame));
}

@end
