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

#include <abseil/absl/types/optional.h>
#include "typedefs.h"

namespace gtx {

absl::optional<UIElementProto> ElementWithIdInHierarchy(
    int id, const AccessibilityHierarchyProto &hierarchy) {
  for (const UIElementProto &current_element : hierarchy.elements()) {
    if (current_element.has_id() && current_element.id() == id) {
      return current_element;
    }
  }
  return absl::nullopt;
}

absl::optional<UIElementProto> ParentOfElementInHierarchy(
    const UIElementProto &element,
    const AccessibilityHierarchyProto &hierarchy) {
  if (!element.has_parent_id()) {
    return absl::nullopt;
  }
  return ElementWithIdInHierarchy(element.parent_id(), hierarchy);
}

void AddElementAsChildToParent(UIElementProto &child, UIElementProto &parent) {
  child.set_parent_id(parent.id());
  parent.add_child_ids(child.id());
}

absl::optional<int> IndexOfElementInParent(const UIElementProto &child,
                                           const UIElementProto &parent) {
  for (int i = 0; i < parent.child_ids_size(); i++) {
    if (parent.child_ids(i) == child.id()) {
      return i;
    }
  }
  return absl::nullopt;
}

}  // namespace gtx
