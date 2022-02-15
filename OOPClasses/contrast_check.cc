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

#include "contrast_check.h"

#include <string>

#include <abseil/absl/strings/str_format.h>
#include <abseil/absl/strings/substitute.h>
#include <abseil/absl/types/optional.h>
#include "metadata_map.h"
#include "proto_utils.h"
#include "typedefs.h"
#include "check.h"
#include "contrast_swatch.h"
#include "gtx_types.h"
#include "image_color_utils.h"
#include "localized_string_ids.h"
#include "localized_strings_manager.h"
#include "parameters.h"

namespace gtx {

constexpr char ContrastCheck::KEY_EXPECTED_CONTRAST_RATIO[];
constexpr char ContrastCheck::KEY_ACTUAL_CONTRAST_RATIO[];
constexpr char ContrastCheck::KEY_FOREGROUND_COLOR[];
constexpr char ContrastCheck::KEY_BACKGROUND_COLOR[];

namespace {
// Constructs a human readable string from the components of color.
std::string StringFromColor(const Color &color) {
  return absl::StrFormat("(%d, %d, %d, %d)", color.red, color.green, color.blue,
                         color.alpha);
}
}  // namespace

/**
 *  The minimum contrast ratio for given text to be considered accessible.
 */
static const float kMinContrastRatioForAccessibleText = 3.0;

std::string ContrastCheck::name() const { return "ContrastCheck"; }

CheckCategory ContrastCheck::Category() const {
  return CheckCategory::kLowContrast;
}

absl::optional<CheckResultProto> ContrastCheck::CheckElement(
    const UIElementProto &element, const Parameters &params) const {
  if (!IsStaticTextElement(element)) {
    return absl::nullopt;
  }
  Rect frame(element.ax_frame());
  Rect screenshot_bounds = params.ConvertRectToScreenshotSpace(frame);
  ContrastSwatch swatch =
      ContrastSwatch::Extract(params.screenshot(), screenshot_bounds);
  float contrast_ratio = image_color_utils::ContrastRatio(
      swatch.foreground().Luminance(), swatch.background().Luminance());
  if (contrast_ratio >= kMinContrastRatioForAccessibleText) {
    return absl::nullopt;
  }
  MetadataMap metadata;
  metadata.SetFloat(KEY_EXPECTED_CONTRAST_RATIO,
                    kMinContrastRatioForAccessibleText);
  metadata.SetFloat(KEY_ACTUAL_CONTRAST_RATIO, contrast_ratio);
  metadata.SetString(KEY_FOREGROUND_COLOR,
                     StringFromColor(swatch.foreground()));
  metadata.SetString(KEY_BACKGROUND_COLOR,
                     StringFromColor(swatch.background()));
  return CheckResult(RESULT_ID_INSUFFICIENT_CONTRAST_RATIO, element, metadata);
}

std::string ContrastCheck::GetRichShortMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDResultBriefMessageInsufficientContrast);
}

std::string ContrastCheck::GetRichTitle(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  return string_manager.LocalizedString(
      locale, kLocalizedStringIDCheckTitleInsufficientTextContrast);
}

std::string ContrastCheck::GetDefaultMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string format = string_manager.LocalizedString(
      locale, kLocalizedStringIDResultMessageInsufficientTextContrast);

  float expected_contrast_ratio =
      *metadata.GetFloat(KEY_EXPECTED_CONTRAST_RATIO);
  float actual_contrast_ratio = *metadata.GetFloat(KEY_ACTUAL_CONTRAST_RATIO);
  std::string foreground_color = *metadata.GetString(KEY_FOREGROUND_COLOR);
  std::string background_color = *metadata.GetString(KEY_BACKGROUND_COLOR);
  return absl::Substitute(format, actual_contrast_ratio, foreground_color,
                          background_color, expected_contrast_ratio);
}

}  // namespace gtx
