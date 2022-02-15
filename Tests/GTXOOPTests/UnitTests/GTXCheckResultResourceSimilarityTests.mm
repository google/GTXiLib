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

#include "check_result_resource_similarity.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/strings/str_cat.h>
#include "accessibility_hierarchy_searching.h"
#include "gtx.pb.h"
#include "metadata_map.h"
#include "typedefs.h"
#include "nearest_ancestor_relation_resource_id_generator.h"
#import "GTXObjCPPTestUtils.h"

@interface GTXCheckResultResourceSimilarityTests : XCTestCase
@end

@implementation GTXCheckResultResourceSimilarityTests

- (void)testCompareWithEmptyHierarchiesReturnsFalse {
  CheckResultProto result1;
  CheckResultProto result2;
  AccessibilityHierarchyProto hierarchy1;
  AccessibilityHierarchyProto hierarchy2;
  gtx::CheckResultInHierarchy resultInHierarchy1{result1, hierarchy1};
  gtx::CheckResultInHierarchy resultInHierarchy2{result2, hierarchy2};
  gtx::NearestAncestorRelationResourceIDGenerator resourceIdGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);
  gtx::CheckResultResourceSimilarity similarity(resourceIdGenerator);

  XCTAssertFalse(similarity(resultInHierarchy1, resultInHierarchy2));
}

- (void)testCompareWithEqualValuesReturnsTrue {
  CheckResultProto result1;
  result1.set_source_check_class("check");
  result1.set_result_id(1);
  result1.set_hierarchy_source_id(2);
  CheckResultProto result2;
  result2.set_source_check_class("check");
  result2.set_result_id(1);
  result2.set_hierarchy_source_id(3);

  AccessibilityHierarchyProto hierarchy;
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child1;
  child1.set_id(2);
  UIElementProto child2;
  child2.set_id(3);
  gtx::AddElementAsChildToParent(child1, parent);
  gtx::AddElementAsChildToParent(child2, parent);
  *hierarchy.add_elements() = parent;
  *hierarchy.add_elements() = child1;
  *hierarchy.add_elements() = child2;

  gtx::CheckResultInHierarchy resultInHierarchy1{result1, hierarchy};
  gtx::CheckResultInHierarchy resultInHierarchy2{result2, hierarchy};
  gtx::NearestAncestorRelationResourceIDGenerator resourceIdGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);
  gtx::CheckResultResourceSimilarity similarity(resourceIdGenerator);

  XCTAssertTrue(similarity(resultInHierarchy1, resultInHierarchy2));
}

- (void)testCompareWithEqualValuesInDifferentHierarchiesReturnsTrue {
  CheckResultProto result1;
  result1.set_source_check_class("check");
  result1.set_result_id(1);
  result1.set_hierarchy_source_id(2);
  CheckResultProto result2;
  result2.set_source_check_class("check");
  result2.set_result_id(1);
  result2.set_hierarchy_source_id(2);

  AccessibilityHierarchyProto hierarchy1;
  AccessibilityHierarchyProto hierarchy2;
  UIElementProto parent1;
  parent1.set_id(1);
  UIElementProto child1;
  child1.set_id(2);
  UIElementProto parent2;
  parent2.set_id(1);
  UIElementProto child2;
  child2.set_id(2);
  gtx::AddElementAsChildToParent(child1, parent1);
  gtx::AddElementAsChildToParent(child2, parent2);
  *hierarchy1.add_elements() = parent1;
  *hierarchy1.add_elements() = child1;
  *hierarchy2.add_elements() = parent2;
  *hierarchy2.add_elements() = child2;

  gtx::CheckResultInHierarchy resultInHierarchy1{result1, hierarchy1};
  gtx::CheckResultInHierarchy resultInHierarchy2{result2, hierarchy2};
  gtx::NearestAncestorRelationResourceIDGenerator resourceIdGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);
  gtx::CheckResultResourceSimilarity similarity(resourceIdGenerator);

  XCTAssertTrue(similarity(resultInHierarchy1, resultInHierarchy2));
}

- (void)testCompareWithDifferentCheckClassesReturnsFalse {
  CheckResultProto result1;
  result1.set_source_check_class("check");
  result1.set_result_id(1);
  result1.set_hierarchy_source_id(2);
  CheckResultProto result2;
  result2.set_source_check_class("different check");
  result2.set_result_id(1);
  result2.set_hierarchy_source_id(3);

  AccessibilityHierarchyProto hierarchy;
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child1;
  child1.set_id(2);
  UIElementProto child2;
  child2.set_id(3);
  gtx::AddElementAsChildToParent(child1, parent);
  gtx::AddElementAsChildToParent(child2, parent);
  *hierarchy.add_elements() = parent;
  *hierarchy.add_elements() = child1;
  *hierarchy.add_elements() = child2;

  gtx::CheckResultInHierarchy resultInHierarchy1{result1, hierarchy};
  gtx::CheckResultInHierarchy resultInHierarchy2{result2, hierarchy};
  gtx::NearestAncestorRelationResourceIDGenerator resourceIdGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);
  gtx::CheckResultResourceSimilarity similarity(resourceIdGenerator);

  XCTAssertFalse(similarity(resultInHierarchy1, resultInHierarchy2));
}

- (void)testCompareWithDifferentResultIdsReturnsFalse {
  CheckResultProto result1;
  result1.set_source_check_class("check");
  result1.set_result_id(1);
  result1.set_hierarchy_source_id(2);
  CheckResultProto result2;
  result2.set_source_check_class("check");
  result2.set_result_id(2);
  result2.set_hierarchy_source_id(3);

  AccessibilityHierarchyProto hierarchy;
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child1;
  child1.set_id(2);
  UIElementProto child2;
  child2.set_id(3);
  gtx::AddElementAsChildToParent(child1, parent);
  gtx::AddElementAsChildToParent(child2, parent);
  *hierarchy.add_elements() = parent;
  *hierarchy.add_elements() = child1;
  *hierarchy.add_elements() = child2;

  gtx::CheckResultInHierarchy resultInHierarchy1{result1, hierarchy};
  gtx::CheckResultInHierarchy resultInHierarchy2{result2, hierarchy};
  gtx::NearestAncestorRelationResourceIDGenerator resourceIdGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);
  gtx::CheckResultResourceSimilarity similarity(resourceIdGenerator);

  XCTAssertFalse(similarity(resultInHierarchy1, resultInHierarchy2));
}

- (void)testCompareWithElementsWithDifferentResourceIdsReturnsFalse {
  CheckResultProto result1;
  result1.set_source_check_class("check");
  result1.set_result_id(1);
  result1.set_hierarchy_source_id(1);
  CheckResultProto result2;
  result2.set_source_check_class("check");
  result2.set_result_id(2);
  result2.set_hierarchy_source_id(3);

  AccessibilityHierarchyProto hierarchy;
  UIElementProto parent;
  parent.set_id(1);
  UIElementProto child1;
  child1.set_id(2);
  UIElementProto child2;
  child2.set_id(3);
  gtx::AddElementAsChildToParent(child1, parent);
  gtx::AddElementAsChildToParent(child2, parent);
  *hierarchy.add_elements() = parent;
  *hierarchy.add_elements() = child1;
  *hierarchy.add_elements() = child2;

  gtx::CheckResultInHierarchy resultInHierarchy1{result1, hierarchy};
  gtx::CheckResultInHierarchy resultInHierarchy2{result2, hierarchy};
  gtx::NearestAncestorRelationResourceIDGenerator resourceIdGenerator(
      gtx::NearestAncestorRelationResourceIDGenerator::IndexType::kExclude);
  gtx::CheckResultResourceSimilarity similarity(resourceIdGenerator);

  XCTAssertFalse(similarity(resultInHierarchy1, resultInHierarchy2));
}

@end
