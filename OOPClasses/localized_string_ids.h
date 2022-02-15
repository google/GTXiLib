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

#ifndef GTXILIB_OOPCLASSES_LOCALIZED_STRING_IDS_H_
#define GTXILIB_OOPCLASSES_LOCALIZED_STRING_IDS_H_

#include <abseil/absl/strings/string_view.h>

namespace gtx {

// An identifier for a string that can be loaded by LocalizedStringsManager.
using LocalizedStringID = absl::string_view;

// The empty string.
inline constexpr LocalizedStringID kLocalizedStringIDEmptyString = "";

// An element is missing an accessibility label.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultMessageNoAccessibilityLabel =
        "result_message_no_accessibility_label";

// The title of the check determining if an element is missing an accessibility
// label.
inline constexpr LocalizedStringID
    kLocalizedStringIDCheckTitleNoAccessibilityLabel =
        "check_title_no_accessibility_label";

// A short description of a check result describing an element that is missing
// an accessibility label.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultMessageBriefNoAccessibilityLabel =
        "result_message_brief_no_accessibility_label";

// An element has an accessibility label containing punctuation when it
// shouldn't.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultMessageAccessibilityLabelIsPunctuated =
        "result_message_accessibility_label_is_punctuated";

// The title of the check determining if an accessibility label ends in
// punctuation when it shouldn't.
inline constexpr LocalizedStringID
    kLocalizedStringIDCheckTitleAccessibilityLabelIsPunctuated =
        "check_title_accessibility_label_is_punctuated";

// A short description of a check result describing an element ending in
// punctuation when it shouldn't.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultMessageBriefAccessibilityLabelIsPunctuated =
        "result_message_brief_accessibility_label_is_punctuated";

// An element has a color contrast ratio which is too low.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultMessageInsufficientTextContrast =
        "result_message_insufficient_text_contrast";

// The title of a check determining if a text element has insufficient color
// contrast ratio.
inline constexpr LocalizedStringID
    kLocalizedStringIDCheckTitleInsufficientTextContrast =
        "check_title_text_contrast";

// A short description of a check result describing an element has a color
// contrast ratio which is too low.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultBriefMessageInsufficientContrast =
        "result_message_brief_insufficient_text_contrast";

// An element has a touch target size which is too small in at least one
// dimension.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultMessageInsufficientTouchTargetSize =
        "result_message_insufficient_touch_target_size";

// The title of a check determining if an element is too small in at least one
// dimension.
inline constexpr LocalizedStringID
    kLocalizedStringIDCheckTitleInsufficientTouchTargetSize =
        "check_title_touch_target_size";

// A short description fo a check result describing an element that is too small
// in at least one dimension.
inline constexpr LocalizedStringID
    kLocalizedStringIDResultBriefMessageInsufficientTouchTargetSize =
        "result_message_brief_insufficient_touch_target_size";

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_LOCALIZED_STRING_IDS_H_
