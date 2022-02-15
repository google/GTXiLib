//
// Copyright 2021 Google Inc.
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

#import "GTXTestIntegrationTestCase.h"

#include <algorithm>

#import "NSString+GTXAdditions.h"
#import "XCUIElement+GTXAdditions.h"
#import "GTXTestViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTXTestXCUIElementTraitsTests : GTXTestIntegrationTestCase
@end

@implementation GTXTestXCUIElementTraitsTests

- (void)testNoTraitsOnCustomElement {
  [self performTestActionNamed:kAddCustomTraitsTestElement];
  XCUIElement *testElement = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] element];
  auto elementProto = [testElement gtx_toProto];
  XCTAssertFalse(elementProto.ax_traits() & UIAccessibilityTraitButton);
  XCTAssertFalse(elementProto.ax_traits() & UIAccessibilityTraitPlaysSound);
}

- (void)testSingleButtonTraitsOnCustomElement {
  [self performTestActionNamed:kAddCustomTraitsTestElement];
  [self performTestActionNamed:kAddButtonTraitToCustomTraitsElement];
  XCUIElement *testElement = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] element];
  auto elementProto = [testElement gtx_toProto];
  XCTAssertTrue(elementProto.ax_traits() & UIAccessibilityTraitButton);
  XCTAssertFalse(elementProto.ax_traits() & UIAccessibilityTraitPlaysSound);
}

- (void)testSinglePlaysSoundTraitOnCustomElement {
  [self performTestActionNamed:kAddCustomTraitsTestElement];
  [self performTestActionNamed:kAddPlaysSoundTraitToCustomTraitsElement];
  XCUIElement *testElement = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] element];
  auto elementProto = [testElement gtx_toProto];
  XCTAssertFalse(elementProto.ax_traits() & UIAccessibilityTraitButton);
  XCTAssertTrue(elementProto.ax_traits() & UIAccessibilityTraitPlaysSound);
}

- (void)testMultipleTraitsOnCustomElement {
  [self performTestActionNamed:kAddCustomTraitsTestElement];
  [self performTestActionNamed:kAddButtonTraitToCustomTraitsElement];
  [self performTestActionNamed:kAddPlaysSoundTraitToCustomTraitsElement];
  XCUIElement *testElement = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] element];
  auto elementProto = [testElement gtx_toProto];
  XCTAssertTrue(elementProto.ax_traits() & UIAccessibilityTraitButton);
  XCTAssertTrue(elementProto.ax_traits() & UIAccessibilityTraitPlaysSound);
}

@end

NS_ASSUME_NONNULL_END
