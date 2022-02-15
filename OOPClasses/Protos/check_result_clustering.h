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

#ifndef GTXILIB_OOPCLASSES_PROTOS_CHECK_RESULT_CLUSTERING_H_
#define GTXILIB_OOPCLASSES_PROTOS_CHECK_RESULT_CLUSTERING_H_

#include <vector>

#include <abseil/absl/types/span.h>
#include "typedefs.h"
#include "check_result_in_hierarchy.h"
#include "check_result_similarity.h"

namespace gtx {

// Groups CheckResultProtos into clusters by comparing them using `similarity`.
std::vector<std::vector<CheckResultProto>> ClusterBySimilarity(
    absl::Span<const CheckResultInHierarchy> check_results,
    const CheckResultSimilarity &similarity);

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_PROTOS_CHECK_RESULT_CLUSTERING_H_
