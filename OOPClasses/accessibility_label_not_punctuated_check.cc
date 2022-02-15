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

#include "accessibility_label_not_punctuated_check.h"

#include <string>

#include <abseil/absl/strings/substitute.h>
#include <abseil/absl/types/optional.h>
#include "metadata_map.h"
#include "proto_utils.h"
#include "typedefs.h"
#include "check.h"
#include "localized_string_ids.h"
#include "localized_strings_manager.h"
#include "parameters.h"
#include "string_utils.h"

namespace gtx {

constexpr char AccessibilityLabelNotPunctuatedCheck::KEY_ACCESSIBILITY_LABEL[];

std::string AccessibilityLabelNotPunctuatedCheck::name() const {
  return "AccessibilityLabelNotPunctuatedCheck";
}

CheckCategory AccessibilityLabelNotPunctuatedCheck::Category() const {
  return CheckCategory::kAccessibilityLabel;
}

absl::optional<CheckResultProto>
AccessibilityLabelNotPunctuatedCheck::CheckElement(
    const UIElementProto &element, const Parameters &params) const {
  if (IsTextDisplayingElement(element)) {
    // This check is not applicable to text elements as accessibility labels can
    // hold static text that can be punctuated and formatted like a string.
    return absl::nullopt;
  }
  std::string accessibility_label = TrimWhitespace(element.ax_label());
  // This check is not applicable for container elements that combine individual
  // labels joined with commas.
  if (accessibility_label.find(',') != std::string::npos) {
    return absl::nullopt;
  }
  if (!EndsWithInvalidPunctuation(accessibility_label)) {
    return absl::nullopt;
  }
  MetadataMap metadata;
  metadata.SetString(KEY_ACCESSIBILITY_LABEL, accessibility_label);
  return CheckResult(RESULT_ID_ENDS_WITH_INVALID_PUNCTUATION, element,
                     metadata);
}

std::string AccessibilityLabelNotPunctuatedCheck::GetRichShortMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale,
      kLocalizedStringIDResultMessageBriefAccessibilityLabelIsPunctuated);
}

std::string AccessibilityLabelNotPunctuatedCheck::GetRichTitle(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDCheckTitleAccessibilityLabelIsPunctuated);
}

std::string AccessibilityLabelNotPunctuatedCheck::GetDefaultMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string format = string_manager.LocalizedString(
      locale, kLocalizedStringIDResultMessageAccessibilityLabelIsPunctuated);
  std::string original_accessibility_label =
      *metadata.GetString(KEY_ACCESSIBILITY_LABEL);
  return absl::Substitute(format, original_accessibility_label);
}

bool AccessibilityLabelNotPunctuatedCheck::EndsWithInvalidPunctuation(
    const std::string &str) const {
  // TODO: Account for all punctuation once it is confirmed that
  // this is Apple's intention.
  return !str.empty() && str.back() == '.';
}

}  // namespace gtx
