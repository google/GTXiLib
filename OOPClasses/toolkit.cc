//
// Copyright 2020 Google Inc.
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

#include "toolkit.h"

#include <assert.h>

#include <iostream>
#include <memory>
#include <string>
#include <utility>
#include <vector>

#include <abseil/absl/types/optional.h>
#include "typedefs.h"
#include "accessibility_label_not_punctuated_check.h"
#include "check.h"
#include "contrast_check.h"
#include "minimum_tappable_area_check.h"
#include "no_label_check.h"
#include "parameters.h"

namespace gtx {

std::unique_ptr<Toolkit> Toolkit::ToolkitWithAllDefaultChecks() {
  auto toolkit = std::make_unique<Toolkit>();
  std::unique_ptr<gtx::Check> no_label_check = std::make_unique<NoLabelCheck>();
  std::unique_ptr<gtx::Check> minimum_tappable_area_check =
      std::make_unique<MinimumTappableAreaCheck>();
  std::unique_ptr<gtx::Check> contrast_check =
      std::make_unique<ContrastCheck>();
  std::unique_ptr<gtx::Check> accessibility_label_not_punctuated_check =
      std::make_unique<AccessibilityLabelNotPunctuatedCheck>();
  toolkit->RegisterCheck(no_label_check);
  toolkit->RegisterCheck(minimum_tappable_area_check);
  toolkit->RegisterCheck(contrast_check);
  toolkit->RegisterCheck(accessibility_label_not_punctuated_check);
  return toolkit;
}

bool Toolkit::RegisterCheck(std::unique_ptr<Check> &check) {
  // Look for duplicate checks before adding a new check.
  const std::string &check_name = check->name();
  for (const auto &registered_check : registered_checks_) {
    const std::string &registered_check_name = registered_check->name();
    if (check_name == registered_check_name) {
      // It is invalid to register duplicate checks with the same name.
      std::cerr << "attempted to register check with existing name '"
                << check_name << "'" << std::endl;
      return false;
    }
  }

  registered_checks_.push_back(std::move(check));
  return true;
}

const gtx::Check &Toolkit::GetRegisteredCheckNamed(
    const std::string &check_name) const {
  for (auto &check : registered_checks_) {
    if (check->name() == check_name) {
      return *check;
    }
  }
  assert(false);
  Check *null_check = nullptr;
  return *null_check;
}

std::vector<CheckResultProto> Toolkit::CheckElement(
    const UIElementProto &element, const Parameters &params) {
  std::vector<CheckResultProto> result;
  if (!element.is_ax_element()) {
    // Currently all checks are only applicable to accessibility elements.
    return result;
  }

  for (const auto &check : registered_checks_) {
    absl::optional<CheckResultProto> check_result =
        check->CheckElement(element, params);
    if (check_result.has_value()) {
      result.push_back(*check_result);
    }
  }
  return result;
}

std::vector<CheckResultProto> Toolkit::CheckElements(
    const AccessibilityHierarchyProto &root_element, const Parameters &params) {
  std::vector<CheckResultProto> result;
  for (const auto &element : root_element.elements()) {
    auto errors = CheckElement(element, params);
    if (!errors.empty()) {
      result.insert(result.end(), errors.begin(), errors.end());
    }
  }
  return result;
}

}  // namespace gtx
