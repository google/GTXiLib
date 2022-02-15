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

@interface GTXTestXCUIElementProtoTests : GTXTestIntegrationTestCase
@end

@implementation GTXTestXCUIElementProtoTests

- (void)testToProtoNonAccessibilityElement {
  // The testing area has a subview when the test app launches. Remove it so there is only one
  // element.
  [self clearTestArea];
  XCUIElement *actionContainer = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingAreaID] element];
  UIElementProto proto = [actionContainer gtx_toProto];
  XCTAssertFalse(proto.has_parent_id());
  XCTAssertEqual(proto.child_ids_size(), 0);
  // TODO: Assert is_ax_element is false once a reliable way to collect this property
  // is determined.
  XCTAssertTrue(proto.has_ax_identifier());
  XCTAssertEqualObjects([NSString gtx_stringFromSTDString:proto.ax_identifier()],
                        kGTXTestTestingAreaID);
  // XCUIElement label is never nil. If they don't exist, they return the empty string.
  XCTAssertEqual(proto.ax_label(), "");
  XCTAssertFalse(proto.has_ax_hint());
  ElementTypeProto expectedElementType =
      [XCUIElement gtxtest_elementTypeFromXCUIElementType:actionContainer.elementType];
  XCTAssertEqual(proto.element_type(), expectedElementType);
}

- (void)testToProtoIsAccessibilityElement {
  [self performTestActionNamed:kAddNonpunctuatedLabelElementActionName];
  XCUIElement *label = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingElementID] element];
  UIElementProto proto = [label gtx_toProto];
  XCTAssertFalse(proto.has_parent_id());
  XCTAssertEqual(proto.child_ids_size(), 0);
  // TODO: Assert is_ax_element is true once a reliable way to collect this property is
  // determined.
  XCTAssertEqual(proto.ax_identifier(), [kGTXTestTestingElementID gtx_stdString]);
  XCTAssertTrue(proto.has_ax_label());
  XCTAssertEqualObjects([NSString gtx_stringFromSTDString:proto.ax_label()], label.label);
  XCTAssertFalse(proto.has_ax_hint());
  ElementTypeProto expectedElementType =
      [XCUIElement gtxtest_elementTypeFromXCUIElementType:label.elementType];
  XCTAssertEqual(proto.element_type(), expectedElementType);
}

- (void)testToHierarchyProtoWithNoChildren {
  XCUIElement *actionContainer = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingAreaID] element];
  XCTAssertNotNil(actionContainer);
  AccessibilityHierarchyProto hierarchy = [actionContainer gtx_toHierarchyProto];
  XCTAssertEqual(hierarchy.elements_size(), 1);
}

- (void)testToHierarchyProtoWithOneChild {
  [self performTestActionNamed:kAddNoLabelElementActionName];
  XCUIElement *actionContainer = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingAreaID] element];
  XCTAssertNotNil(actionContainer);
  AccessibilityHierarchyProto hierarchy = [actionContainer gtx_toHierarchyProto];
  XCTAssertEqual(hierarchy.elements_size(), 2);
  XCTAssertEqual(hierarchy.elements(0).child_ids_size(), 1);
  XCTAssertEqual(hierarchy.elements(1).child_ids_size(), 0);
  [self gtxtest_assertRelationBetweenParent:hierarchy.elements(0) andChild:hierarchy.elements(1)];
}

- (void)testToHierarchyProtoWithManyChildrenAndSubchildren {
  [self performTestActionNamed:kAddMultipleElementsWithChildren];
  XCUIElement *actionContainer = [[[self.app descendantsMatchingType:XCUIElementTypeAny]
      matchingIdentifier:kGTXTestTestingAreaID] element];
  XCTAssertNotNil(actionContainer);
  AccessibilityHierarchyProto hierarchy = [actionContainer gtx_toHierarchyProto];
  // Add one because the containing element is also included.
  int expectedSize = (int)kGTXTestMultipleTestingElementIDsCount + 1;
  XCTAssertEqual(hierarchy.elements_size(), expectedSize);
  // Elements retrieved from XCUIElementQuery are not guaranteed to be in the same order
  // they were added to the view hierarchy. Search for them based on accessibility identifier
  // to ensure the correct elements are being referenced.
  UIElementProto testArea = [self gtx_elementInHierarchy:hierarchy
                                          withIdentifier:kGTXTestTestingAreaID];
  UIElementProto parent = [self gtx_elementInHierarchy:hierarchy
                                        withIdentifier:kGTXTestMultipleTestingElementsIDs[0]];
  UIElementProto child1 = [self gtx_elementInHierarchy:hierarchy
                                        withIdentifier:kGTXTestMultipleTestingElementsIDs[1]];
  UIElementProto child2 = [self gtx_elementInHierarchy:hierarchy
                                        withIdentifier:kGTXTestMultipleTestingElementsIDs[2]];
  UIElementProto subchild1 = [self gtx_elementInHierarchy:hierarchy
                                           withIdentifier:kGTXTestMultipleTestingElementsIDs[3]];
  [self gtxtest_assertRelationBetweenParent:testArea andChild:parent];
  [self gtxtest_assertRelationBetweenParent:parent andChild:child1];
  [self gtxtest_assertRelationBetweenParent:parent andChild:child2];
  [self gtxtest_assertRelationBetweenParent:child1 andChild:subchild1];
}

#pragma mark - Private

/**
 * Finds the element in @c elements with ax_identifier @c identifier. Fails the test if no such
 * element is found.
 * @param hierarchy A hierarchy of @c UIElements
 * @param identifier The accessibility identifier to search for.
 * @return A copy of the UIElement in @c elements with ax_identifier equal to @c identifier, or an
 * empty element if none could be found.
 */
- (UIElementProto)gtx_elementInHierarchy:(const AccessibilityHierarchyProto &)hierarchy
                          withIdentifier:(NSString *)identifier {
  std::string stdIdentifier = [identifier gtx_stdString];
  for (const UIElementProto &element : hierarchy.elements()) {
    if (element.ax_identifier() == stdIdentifier) {
      return element;
    }
  }
  XCTFail(@"could not find element");
  // Return dummy element to satisfy compiler.
  return UIElementProto();
}

/**
 * Asserts that @c parent contains @c child as a child and @c child has @c parent as its parent.
 * @param parent The parent element of child.
 * @param child The child element of parent.
 */
- (void)gtxtest_assertRelationBetweenParent:(const UIElementProto &)parent
                                   andChild:(const UIElementProto &)child {
  [self gtxtest_assertField:parent.child_ids() containsElementExactlyOnce:child.id()];
  XCTAssertEqual(parent.id(), child.parent_id());
}

/**
 * Determines if a repeated proto field contains @c value exactly once. Passes if @c field contains
 * @c value exactly one time, fails the test if it contains @c value 0 or more than 1 times.
 * @param field A repeated integer proto field.
 * @param value The value to search for.
 */
- (void)gtxtest_assertField:(const proto2::RepeatedField<int32> &)field
    containsElementExactlyOnce:(int32)value {
  auto first = std::find(field.cbegin(), field.cend(), value);
  if (first == field.cend()) {
    XCTFail(@"%d value was not found in repeated field", value);
    return;
  }
  auto second = std::find(first + 1, field.cend(), value);
  // If searching the subsequence of the vector after the first match
  // finds no match, then there must be only one match. If it finds
  // a second match separate from the first, there are multiple matches.
  XCTAssert(second == field.cend(), @"%d value was found in repeated field multiple times", value);
}

@end

NS_ASSUME_NONNULL_END
