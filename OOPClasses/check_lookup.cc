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

#include "check_lookup.h"

#include <memory>
#include <vector>

#include <abseil/absl/strings/string_view.h>
#include "accessibility_label_not_punctuated_check.h"
#include "contrast_check.h"
#include "minimum_tappable_area_check.h"
#include "no_label_check.h"

namespace gtx {

std::vector<std::unique_ptr<gtx::Check>> ChecksForVersion(Version version) {
  std::vector<std::unique_ptr<gtx::Check>> checks;
  switch (version) {
    case Version::kPrerelease:
      // fallthrough
    case Version::kLatest:
      checks.push_back(
          std::make_unique<AccessibilityLabelNotPunctuatedCheck>());
      checks.push_back(std::make_unique<NoLabelCheck>());
      checks.push_back(std::make_unique<MinimumTappableAreaCheck>());
      checks.push_back(std::make_unique<ContrastCheck>());
      break;
  }
  return checks;
}

std::unique_ptr<gtx::Check> CheckForName(absl::string_view name) {
  // Only prerelease is guaranteed to include all checks.
  auto checks = ChecksForVersion(Version::kPrerelease);
  for (auto &check : checks) {
    if (check->name() == name) {
      return std::move(check);
    }
  }
  return nullptr;
}

}  // namespace gtx
