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

#include "no_label_check.h"

#include <string>

#include <abseil/absl/types/optional.h>
#include "metadata_map.h"
#include "typedefs.h"
#include "check.h"
#include "localized_string_ids.h"
#include "localized_strings_manager.h"
#include "parameters.h"

namespace gtx {

std::string NoLabelCheck::name() const { return "NoLabelCheck"; }

CheckCategory NoLabelCheck::Category() const {
  return CheckCategory::kAccessibilityLabel;
}

absl::optional<CheckResultProto> NoLabelCheck::CheckElement(
    const UIElementProto &element, const Parameters &params) const {
  // TODO: Ignore non accessibility elements when an accurate way
  // to determine isAccessibilityElement is found.
  if (element.ax_label().empty()) {
    return CheckResult(RESULT_ID_MISSING_ACCESSIBILITY_LABEL, element,
                       MetadataMap());
  }
  return absl::nullopt;
}

std::string NoLabelCheck::GetRichShortMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDResultMessageBriefNoAccessibilityLabel);
}

std::string NoLabelCheck::GetRichTitle(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDCheckTitleNoAccessibilityLabel);
}

std::string NoLabelCheck::GetDefaultMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDResultMessageNoAccessibilityLabel);
}

}  // namespace gtx
