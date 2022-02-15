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

#ifndef GTXILIB_OOPCLASSES_CHECK_RESULT_IN_HIERARCHY_H_
#define GTXILIB_OOPCLASSES_CHECK_RESULT_IN_HIERARCHY_H_

#include "typedefs.h"

namespace gtx {

// Wraps a CheckResultProto and AccessibilityHierarchyProto. Does not take
// ownership of the check result or accessibility hierarchy. The client is
// responsible for ensuring this instance does not outlive its references.
struct CheckResultInHierarchy {
  const CheckResultProto &check_result;
  const AccessibilityHierarchyProto &accessibility_hierarchy;
};

}  // namespace gtx

#endif
