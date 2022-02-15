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

#ifndef GTXILIB_OOPCLASSES_CHECK_RESULT_SIMILARITY_H_
#define GTXILIB_OOPCLASSES_CHECK_RESULT_SIMILARITY_H_

#include <functional>

#include "check_result_in_hierarchy.h"

namespace gtx {

// Determines if two check results represent the same accessibility issue.
// Returns true if both result1 and result2 represent the same accessibility
// issue, false otherwise.
using CheckResultSimilarity =
    std::function<bool(const CheckResultInHierarchy &result1,
                       const CheckResultInHierarchy &result2)>;

}  // namespace gtx

#endif
