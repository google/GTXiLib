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

#include "check_result_clustering.h"

#import <XCTest/XCTest.h>
#include <string>
#include <vector>

#include <abseil/absl/strings/str_cat.h>
#include "accessibility_hierarchy_searching.h"
#include "gtx.pb.h"
#include "typedefs.h"
#import "GTXObjCPPTestUtils.h"

// Returns `true` if both check results have the same source check class name,
// `false` otherwise.
bool GTXSimilarityByCheckName(const gtx::CheckResultInHierarchy &checkResult1,
                              const gtx::CheckResultInHierarchy &checkResult2);

@interface GTXCheckResultClusteringTests : XCTestCase
@end

@implementation GTXCheckResultClusteringTests

- (void)testClusterBySimilarityWithEmptyResultsReturnsNoClusters {
  std::vector<gtx::CheckResultInHierarchy> checkResults;

  XCTAssertEqual(ClusterBySimilarity(checkResults, GTXSimilarityByCheckName).size(), 0ul);
}

- (void)testClusterBySimilarityWithDifferentResultsReturnsMultipleClusters {
  AccessibilityHierarchyProto hierarchy;
  CheckResultProto checkResult1;
  checkResult1.set_source_check_class("check");
  CheckResultProto checkResult2;
  checkResult2.set_source_check_class("different check");
  CheckResultProto checkResult3;
  checkResult3.set_source_check_class("yet another check");
  std::vector<gtx::CheckResultInHierarchy> checkResults{
      {checkResult1, hierarchy}, {checkResult2, hierarchy}, {checkResult3, hierarchy}};

  std::vector<std::vector<CheckResultProto>> clusters =
      ClusterBySimilarity(checkResults, GTXSimilarityByCheckName);
  XCTAssertEqual(clusters.size(), 3lu);
  XCTAssertEqual(clusters[0].size(), 1lu);
  XCTAssertEqual(clusters[1].size(), 1lu);
  XCTAssertEqual(clusters[2].size(), 1lu);
  [self gtxtest_assertProto:clusters[0][0] equalsProto:checkResult1];
  [self gtxtest_assertProto:clusters[1][0] equalsProto:checkResult2];
  [self gtxtest_assertProto:clusters[2][0] equalsProto:checkResult3];
}

- (void)testClusterBySimilarityWithSameAndDifferentResultsReturnsMultipleClusters {
  AccessibilityHierarchyProto hierarchy;
  CheckResultProto checkResult1;
  checkResult1.set_source_check_class("check");
  CheckResultProto checkResult2;
  checkResult2.set_source_check_class("different check");
  CheckResultProto checkResult3;
  checkResult3.set_source_check_class("check");
  std::vector<gtx::CheckResultInHierarchy> checkResults{
      {checkResult1, hierarchy}, {checkResult2, hierarchy}, {checkResult3, hierarchy}};

  std::vector<std::vector<CheckResultProto>> clusters =
      ClusterBySimilarity(checkResults, GTXSimilarityByCheckName);
  XCTAssertEqual(clusters.size(), 2lu);
  XCTAssertEqual(clusters[0].size(), 2lu);
  XCTAssertEqual(clusters[1].size(), 1lu);
  [self gtxtest_assertProto:clusters[0][0] equalsProto:checkResult1];
  [self gtxtest_assertProto:clusters[0][1] equalsProto:checkResult3];
  [self gtxtest_assertProto:clusters[1][0] equalsProto:checkResult2];
}

/**
 * Asserts that two check result protos are equal. Fails the test if any of their fields (except for
 * metadata) are not equal.
 *
 * @param proto1 The first proto to compare.
 * @param proto2 The second proto to compare.
 */
- (void)gtxtest_assertProto:(const CheckResultProto &)proto1
                equalsProto:(const CheckResultProto &)proto2 {
  [GTXObjCPPTestUtils assertString:proto1.source_check_class()
                      equalsString:proto2.source_check_class()];
  XCTAssertEqual(proto1.result_id(), proto2.result_id());
  XCTAssertEqual(proto1.hierarchy_source_id(), proto2.hierarchy_source_id());
  XCTAssertEqual(proto1.result_type(), proto2.result_type());
}

@end

bool GTXSimilarityByCheckName(const gtx::CheckResultInHierarchy &checkResult1,
                              const gtx::CheckResultInHierarchy &checkResult2) {
  return checkResult1.check_result.source_check_class() ==
         checkResult2.check_result.source_check_class();
}
