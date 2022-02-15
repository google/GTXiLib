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

#ifndef GTXILIB_OOPCLASSES_PROTOS_ACCESSIBILITY_HIERARCHY_SEARCHING_H_
#define GTXILIB_OOPCLASSES_PROTOS_ACCESSIBILITY_HIERARCHY_SEARCHING_H_

#include <abseil/absl/types/optional.h>
#include "typedefs.h"

namespace gtx {

/**
 * Returns the `UIElementProto` in `hierarchy` with the given id. If no such
 * element exists, returns `absl::nullopt`.
 */
absl::optional<UIElementProto> ElementWithIdInHierarchy(
    int id, const AccessibilityHierarchyProto &hierarchy);

/**
 * Returns the parent of `element` in `hierarchy` based on its id. If no such
 * parent exists, returns `absl::nullopt`.
 */
absl::optional<UIElementProto> ParentOfElementInHierarchy(
    const UIElementProto &element,
    const AccessibilityHierarchyProto &hierarchy);

// Adds `child` as a child to `parent` and vice versa. It is the caller's
// responsibility to ensure `child` is removed from its previous parent, if one
// exists (including the given `parent`).
void AddElementAsChildToParent(UIElementProto &child, UIElementProto &parent);

/**
 * Returns the index `child` can be found in `parent`'s child_ids array by id.
 * If `child`'s id does not exist in `parent`'s child_ids, returns
 * `absl::nullopt`.
 */
absl::optional<int> IndexOfElementInParent(const UIElementProto &child,
                                           const UIElementProto &parent);

}  // namespace gtx

#endif
