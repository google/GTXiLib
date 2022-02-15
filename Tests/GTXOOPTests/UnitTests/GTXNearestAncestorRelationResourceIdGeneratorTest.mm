#include "nearest_ancestor_relation_resource_id_generator.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/strings/str_cat.h>
#include "accessibility_hierarchy_searching.h"
#include "gtx.pb.h"
#include "metadata_map.h"
#include "typedefs.h"
#import "GTXObjCPPTestUtils.h"

@interface GTXNearestAncestorRelationResourceIdGeneratorTest : XCTestCase
@end

@implementation GTXNearestAncestorRelationResourceIdGeneratorTest

- (void)testSingleElementInHierarchyReturnsResourceID {
  UIElementProto element;
  element.set_id(2);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = element;
  auto idGenerator = gtx::NearestAncestorRelationResourceIDGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kInclude);

  [GTXObjCPPTestUtils assertString:idGenerator(element, hierarchy) equalsString:"child"];
}

- (void)testMultipleElementsInHierarchyReturnsResourceID {
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
  gtx::AddElementAsChildToParent(element4, element3);
  AccessibilityHierarchyProto hierarchy;
  *hierarchy.add_elements() = element1;
  *hierarchy.add_elements() = element2;
  *hierarchy.add_elements() = element3;
  *hierarchy.add_elements() = element4;
  auto idGeneratorWithIndices = gtx::NearestAncestorRelationResourceIDGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kInclude);
  auto idGeneratorWithoutIndices = gtx::NearestAncestorRelationResourceIDGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);

  [GTXObjCPPTestUtils assertString:idGeneratorWithIndices(element2, hierarchy)
                      equalsString:"child:child[0]"];
  [GTXObjCPPTestUtils assertString:idGeneratorWithIndices(element4, hierarchy)
                      equalsString:"child:child[1]:child[0]"];
  [GTXObjCPPTestUtils assertString:idGeneratorWithoutIndices(element2, hierarchy)
                      equalsString:"child:child"];
  [GTXObjCPPTestUtils assertString:idGeneratorWithoutIndices(element4, hierarchy)
                      equalsString:"child:child:child"];
}

- (void)testEmptyHierarchyReturnsIndividualResourceID {
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
  gtx::AddElementAsChildToParent(element4, element3);
  AccessibilityHierarchyProto hierarchy;
  auto idGenerator = gtx::NearestAncestorRelationResourceIDGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kInclude);

  [GTXObjCPPTestUtils assertString:idGenerator(element2, hierarchy) equalsString:"child"];
  [GTXObjCPPTestUtils assertString:idGenerator(element4, hierarchy) equalsString:"child"];
}

@end
