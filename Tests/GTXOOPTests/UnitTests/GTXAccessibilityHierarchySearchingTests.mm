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

#include "accessibility_hierarchy_searching.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/strings/str_cat.h>
#include <abseil/absl/types/optional.h>
#include "accessibility_hierarchy_searching.h"
#include "gtx.pb.h"
#include "typedefs.h"

@interface GTXAccessibilityHierarchySearchingTests : XCTestCase
@end

@implementation GTXAccessibilityHierarchySearchingTests

- (void)testElementWithIdInHierarchyReturnsNullForEmptyHierarchy {
  AccessibilityHierarchyProto hierarchy;

  XCTAssertEqual(gtx::ElementWithIdInHierarchy(1, hierarchy), absl::nullopt);
}

- (void)testElementWithIdInHierarchyReturnsNullForMissingElement {
  AccessibilityHierarchyProto hierarchy;
  hierarchy.add_elements()->set_id(2);

  XCTAssertEqual(gtx::ElementWithIdInHierarchy(1, hierarchy), absl::nullopt);
}

- (void)testElementWithIdInHierarchyWithSingleElementReturnsElement {
  UIElementProto element;
  element.set_id(1);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = element;

  absl::optional<UIElementProto> actualElement = gtx::ElementWithIdInHierarchy(1, hierarchy);

  XCTAssertNotEqual(actualElement, absl::nullopt);
  // Protos do not override ==, so compare ids to test for equality.
  XCTAssertEqual(actualElement->id(), element.id());
}

- (void)testElementWithIdInHierarchyWithMultipleElementsReturnsElement {
  UIElementProto element1;
  element1.set_id(1);
  UIElementProto element2;
  element2.set_id(2);
  gtx::AddElementAsChildToParent(element2, element1);
  UIElementProto element3;
  element3.set_id(3);
  gtx::AddElementAsChildToParent(element3, element1);
  UIElementProto element4;
  element4.set_id(4);
  gtx::AddElementAsChildToParent(element4, element2);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = element1;
  *hierarchy.add_elements() = element2;
  *hierarchy.add_elements() = element3;
  *hierarchy.add_elements() = element4;

  absl::optional<UIElementProto> actualElement = gtx::ElementWithIdInHierarchy(3, hierarchy);

  XCTAssertNotEqual(actualElement, absl::nullopt);
  XCTAssertEqual(actualElement->id(), element3.id());
}

- (void)testParentOfElementInHierarchyWithEmptyHierarchyReturnsNull {
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child;
  child.set_id(2);
  gtx::AddElementAsChildToParent(child, parent);
  AccessibilityHierarchyProto hierarchy;

  XCTAssertEqual(gtx::ParentOfElementInHierarchy(child, hierarchy), absl::nullopt);
}

- (void)testParentOfElementInHierarchyWithNoParentReturnsNull {
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child;
  child.set_id(2);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = parent;
  *hierarchy.add_elements() = child;

  XCTAssertEqual(gtx::ParentOfElementInHierarchy(child, hierarchy), absl::nullopt);
}

- (void)testParentOfElementInHierarchyWithParentReturnsParent {
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child;
  child.set_id(2);
  gtx::AddElementAsChildToParent(child, parent);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = parent;
  *hierarchy.add_elements() = child;

  absl::optional<UIElementProto> actualParent = gtx::ParentOfElementInHierarchy(child, hierarchy);

  XCTAssertTrue(actualParent.has_value());
  XCTAssertEqual(actualParent->id(), parent.id());
}

- (void)testParentOfElementInHierarchyWithMultipleElementsReturnsParent {
  UIElementProto element1;
  element1.set_id(1);
  UIElementProto element2;
  element2.set_id(2);
  gtx::AddElementAsChildToParent(element2, element1);
  UIElementProto element3;
  element3.set_id(3);
  gtx::AddElementAsChildToParent(element3, element1);
  UIElementProto element4;
  element4.set_id(4);
  gtx::AddElementAsChildToParent(element4, element2);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = element1;
  *hierarchy.add_elements() = element2;
  *hierarchy.add_elements() = element3;
  *hierarchy.add_elements() = element4;

  absl::optional<UIElementProto> actualParent =
      gtx::ParentOfElementInHierarchy(element3, hierarchy);

  XCTAssertTrue(actualParent.has_value());
  XCTAssertEqual(actualParent->id(), element1.id());
}

- (void)testAddElementAsChildToParentSetsIDs {
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child;
  child.set_id(2);

  XCTAssertEqual(parent.child_ids_size(), 0);
  XCTAssertFalse(child.has_parent_id());
  gtx::AddElementAsChildToParent(child, parent);
  XCTAssertEqual(parent.child_ids_size(), 1);
  XCTAssertEqual(parent.child_ids(0), 2);
  XCTAssertEqual(child.parent_id(), 1);
}

- (void)testIndexOfElementInParentWithNoParentReturnsNull {
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child;
  child.set_id(2);

  XCTAssertEqual(gtx::IndexOfElementInParent(child, parent), absl::nullopt);
}

- (void)testIndexOfElementInParentWithParentWithOneChildReturnsIndex {
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child;
  child.set_id(2);
  gtx::AddElementAsChildToParent(child, parent);

  XCTAssertEqual(gtx::IndexOfElementInParent(child, parent), 0);
}

- (void)testIndexOfElementInParentWithParentWithMultipleChildrenReturnsIndex {
  UIElementProto element1;
  element1.set_id(1);
  UIElementProto element2;
  element2.set_id(2);
  gtx::AddElementAsChildToParent(element2, element1);
  UIElementProto element3;
  element3.set_id(3);
  gtx::AddElementAsChildToParent(element3, element1);
  UIElementProto element4;
  element4.set_id(4);
  gtx::AddElementAsChildToParent(element4, element2);

  XCTAssertEqual(gtx::IndexOfElementInParent(element2, element1), 0);
  XCTAssertEqual(gtx::IndexOfElementInParent(element3, element1), 1);
}

- (void)testIndexOfElementInGrandparentReturnsNull {
  UIElementProto element1;
  element1.set_id(1);
  UIElementProto element2;
  element2.set_id(2);
  gtx::AddElementAsChildToParent(element2, element1);
  UIElementProto element3;
  element3.set_id(3);
  gtx::AddElementAsChildToParent(element3, element2);

  XCTAssertEqual(gtx::IndexOfElementInParent(element3, element1), absl::nullopt);
}

@end
