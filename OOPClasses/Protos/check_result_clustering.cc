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

#include <vector>

#include <abseil/absl/types/span.h>
#include "typedefs.h"
#include "check_result_in_hierarchy.h"
#include "check_result_similarity.h"

namespace gtx {

namespace {
std::vector<std::vector<CheckResultProto>>
CheckResultClustersFromCheckResultInHierarchyClusters(
    absl::Span<const std::vector<CheckResultInHierarchy>> clusters) {
  std::vector<std::vector<CheckResultProto>> check_result_clusters;
  check_result_clusters.reserve(clusters.size());

  for (const auto &cluster : clusters) {
    std::vector<CheckResultProto> check_result_cluster;
    check_result_cluster.reserve(cluster.size());
    for (const auto &check_result_in_hierarchy : cluster) {
      check_result_cluster.push_back(check_result_in_hierarchy.check_result);
    }
    check_result_clusters.push_back(check_result_cluster);
  }
  return check_result_clusters;
}
}  // namespace

std::vector<std::vector<CheckResultProto>> ClusterBySimilarity(
    absl::Span<const CheckResultInHierarchy> check_results,
    const CheckResultSimilarity &similarity) {
  std::vector<std::vector<CheckResultInHierarchy>> clusters;
  for (const CheckResultInHierarchy &check_result_in_hierarchy :
       check_results) {
    bool cluster_found = false;
    for (std::vector<CheckResultInHierarchy> &cluster : clusters) {
      if (similarity(cluster[0], check_result_in_hierarchy)) {
        cluster.push_back(check_result_in_hierarchy);
        cluster_found = true;
        break;
      }
    }
    if (!cluster_found) {
      clusters.push_back({check_result_in_hierarchy});
    }
  }
  return CheckResultClustersFromCheckResultInHierarchyClusters(clusters);
}

}  // namespace gtx
