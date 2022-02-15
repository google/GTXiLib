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

#include "minimum_tappable_area_check.h"

#include <string>

#include <abseil/absl/strings/substitute.h>
#include <abseil/absl/types/optional.h>
#include "gtx.pb.h"
#include "metadata_map.h"
#include "proto_utils.h"
#include "typedefs.h"
#include "check.h"
#include "localized_string_ids.h"
#include "localized_strings_manager.h"
#include "parameters.h"

namespace gtx {

constexpr char MinimumTappableAreaCheck::KEY_EXPECTED_SIZE[];
constexpr char MinimumTappableAreaCheck::KEY_ACTUAL_WIDTH[];
constexpr char MinimumTappableAreaCheck::KEY_ACTUAL_HEIGHT[];

// The minimum size (width or height) for a given element to be easily
// accessible. Please read Material design guidelines for more on touch targets:
// https://material.io/design/layout/spacing-methods.html#touch-click-targets
static const float kMinSizeForAccessibleElements = 44.0;

std::string MinimumTappableAreaCheck::name() const {
  return "MinimumTappableAreaCheck";
}

CheckCategory MinimumTappableAreaCheck::Category() const {
  return CheckCategory::kTouchTargetSize;
}

absl::optional<CheckResultProto> MinimumTappableAreaCheck::CheckElement(
    const UIElementProto &element, const Parameters &params) const {
  if (!IsButtonElement(element)) {
    return absl::nullopt;
  }
  if (element.ax_frame().size().width() < kMinSizeForAccessibleElements ||
      element.ax_frame().size().height() < kMinSizeForAccessibleElements) {
    MetadataMap metadata;
    metadata.SetFloat(KEY_EXPECTED_SIZE, kMinSizeForAccessibleElements);
    metadata.SetFloat(KEY_ACTUAL_WIDTH, element.ax_frame().size().width());
    metadata.SetFloat(KEY_ACTUAL_HEIGHT, element.ax_frame().size().height());
    return CheckResult(RESULT_ID_INSUFFICIENT_TOUCH_TARGET_SIZE, element,
                       metadata);
  }
  return absl::nullopt;
}

std::string MinimumTappableAreaCheck::GetRichShortMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDResultBriefMessageInsufficientTouchTargetSize);
}

std::string MinimumTappableAreaCheck::GetRichTitle(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDCheckTitleInsufficientTouchTargetSize);
}

std::string MinimumTappableAreaCheck::GetDefaultMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string format = string_manager.LocalizedString(
      locale, kLocalizedStringIDResultMessageInsufficientTouchTargetSize);
  float expected_size = *metadata.GetFloat(KEY_EXPECTED_SIZE);
  float actual_width = *metadata.GetFloat(KEY_ACTUAL_WIDTH);
  float actual_height = *metadata.GetFloat(KEY_ACTUAL_HEIGHT);
  return absl::Substitute(format, actual_width, actual_height, expected_size);
}

}  // namespace gtx
