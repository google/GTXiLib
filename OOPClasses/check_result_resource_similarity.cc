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

#include <functional>
#include <string>

#include <abseil/absl/types/optional.h>
#include "accessibility_hierarchy_searching.h"
#include "typedefs.h"
#include "check_result_in_hierarchy.h"
#include "resource_id_generator.h"

namespace gtx {

bool CheckResultResourceSimilarity::operator()(
    const CheckResultInHierarchy &result1,
    const CheckResultInHierarchy &result2) {
  absl::optional<UIElementProto> element1 =
      ElementWithIdInHierarchy(result1.check_result.hierarchy_source_id(),
                               result1.accessibility_hierarchy);
  absl::optional<UIElementProto> element2 =
      ElementWithIdInHierarchy(result2.check_result.hierarchy_source_id(),
                               result2.accessibility_hierarchy);
  if (!element1.has_value() || !element2.has_value()) {
    return false;
  }
  if (result1.check_result.source_check_class() !=
          result2.check_result.source_check_class() ||
      result1.check_result.result_id() != result2.check_result.result_id()) {
    return false;
  }
  std::string resource_id1 =
      resource_id_generator_(*element1, result1.accessibility_hierarchy);
  std::string resource_id2 =
      resource_id_generator_(*element2, result2.accessibility_hierarchy);
  return resource_id1 == resource_id2;
}

}  // namespace gtx
