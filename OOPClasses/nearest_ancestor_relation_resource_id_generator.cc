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

#include "nearest_ancestor_relation_resource_id_generator.h"

#include <string>

#include <abseil/absl/strings/str_cat.h>
#include <abseil/absl/types/optional.h>
#include "accessibility_hierarchy_searching.h"
#include "typedefs.h"

namespace gtx {

std::string NearestAncestorRelationResourceIDGenerator::operator()(
    const UIElementProto &element,
    const AccessibilityHierarchyProto &hierarchy) const {
  std::string resource_id = ResourceIdForElement(element);
  absl::optional<UIElementProto> parent =
      ParentOfElementInHierarchy(element, hierarchy);
  if (!parent.has_value()) {
    return resource_id;
  }
  std::string index_string = "";
  if (index_type_ == IndexType::kInclude) {
    absl::optional<int> index = IndexOfElementInParent(element, *parent);
    if (index.has_value()) {
      index_string = absl::StrCat("[", *index, "]");
    }
  }
  std::string parent_resource_id = (*this)(*parent, hierarchy);
  return absl::StrCat(parent_resource_id, ":", resource_id, index_string);
}

std::string NearestAncestorRelationResourceIDGenerator::ResourceIdForElement(
    const UIElementProto &element) const {
  if (element.class_names_hierarchy_size() > 0) {
    return element.class_names_hierarchy(0);
  }
  // TODO: Find a value on element that can be used as an
  // identifier to differentiate elements.
  return "child";
}

}  // namespace gtx
