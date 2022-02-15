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

#ifndef GTXILIB_OOPCLASSES_NEAREST_ANCESTOR_RELATION_RESOURCE_ID_GENERATOR_H_
#define GTXILIB_OOPCLASSES_NEAREST_ANCESTOR_RELATION_RESOURCE_ID_GENERATOR_H_

#include <string>

#include "typedefs.h"

namespace gtx {

// Generates a unique identifier for a UIElementProto based on its position in
// the accessibility hierarchy.
class NearestAncestorRelationResourceIDGenerator {
 public:
  // Configures how indices should be used when generating a resource id.
  enum class IndexType {
    // Exclude the index of child elements in their parents when constructing a
    // string.
    kExclude = 0,
    // Include the index of child elements in their parents when constructing a
    // string.
    kInclude = 1
  };

  explicit NearestAncestorRelationResourceIDGenerator(IndexType index_type)
      : index_type_(index_type) {}

  NearestAncestorRelationResourceIDGenerator(
      NearestAncestorRelationResourceIDGenerator &&) = default;
  NearestAncestorRelationResourceIDGenerator(
      const NearestAncestorRelationResourceIDGenerator &) = default;
  NearestAncestorRelationResourceIDGenerator &operator=(
      const NearestAncestorRelationResourceIDGenerator &) = default;
  NearestAncestorRelationResourceIDGenerator &operator=(
      NearestAncestorRelationResourceIDGenerator &&) = default;

  // Returns a string representation of `element`. `hierarchy` must be the
  // accessibility hierarchy containing `element`. Behavior is undefined if
  // `hierarchy` does not contain `element`.
  std::string operator()(const UIElementProto &element,
                         const AccessibilityHierarchyProto &hierarchy) const;

 private:
  // Returns an identifier for `element` based only on itself, not its position
  // in the accessibility hierarchy. This identifier is not necessarily unique.
  std::string ResourceIdForElement(const UIElementProto &element) const;

  IndexType index_type_;
};

}  // namespace gtx

#endif
