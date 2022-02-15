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

#ifndef GTXILIB_OOPCLASSES_RESULT_SIMILARITY_H_
#define GTXILIB_OOPCLASSES_RESULT_SIMILARITY_H_

#include "check_result_in_hierarchy.h"
#include "resource_id_generator.h"

namespace gtx {

// Compares two check results based on their check result class, result id, and
// a resource id.
class CheckResultResourceSimilarity {
 public:
  explicit CheckResultResourceSimilarity(
      ResourceIdGenerator resource_id_generator)
      : resource_id_generator_(resource_id_generator) {}

  CheckResultResourceSimilarity(const CheckResultResourceSimilarity &) =
      default;
  CheckResultResourceSimilarity(CheckResultResourceSimilarity &&) = default;
  CheckResultResourceSimilarity &operator=(
      const CheckResultResourceSimilarity &) = default;
  CheckResultResourceSimilarity &operator=(CheckResultResourceSimilarity &&) =
      default;

  bool operator()(const CheckResultInHierarchy &result1,
                  const CheckResultInHierarchy &result2);

 private:
  ResourceIdGenerator resource_id_generator_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_RESULT_SIMILARITY_H_
