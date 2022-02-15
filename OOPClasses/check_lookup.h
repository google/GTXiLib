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

#ifndef GTXILIB_OOPCLASSES_CHECK_LOOKUP_H_
#define GTXILIB_OOPCLASSES_CHECK_LOOKUP_H_

#include <memory>
#include <vector>

#include <abseil/absl/strings/string_view.h>
#include "check.h"

namespace gtx {

// Different checks are grouped into different versions. Most users should use
// LATEST, but new checks which are being tested internally will be implemented
// in PRERELEASE. Users may opt into the most cutting edge checks.
enum class Version { kLatest, kPrerelease };

// Returns the built in checks associated with `version`.
std::vector<std::unique_ptr<gtx::Check>> ChecksForVersion(Version version);

// Returns the built in check with the given name, or nullptr if no such
// check exists.
std::unique_ptr<gtx::Check> CheckForName(absl::string_view name);

}  // namespace gtx

#endif  // GOOGLEMAC_IPHONE_SHARED_TESTING_ACCESSIBILITY_AXEOOPLIB_CLASSES_CHECKS_H_
