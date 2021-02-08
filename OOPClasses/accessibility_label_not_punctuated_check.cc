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

#include "string_utils.h"

namespace gtx {

bool AccessibilityLabelNotPunctuatedCheck::CheckElement(
    const UIElement &element, const Parameters &params,
    ErrorMessage *errorMessage) const {
  if (element.is_text_displaying_element()) {
    // This check is not applicable to text elements as accessibility labels can
    // hold static text that can be punctuated and formatted like a string.
    return true;
  }
  std::string accessibility_label = TrimWhitespace(element.ax_label());
  // This check is not applicable for container elements that combine individual
  // labels joined with commas.
  if (accessibility_label.find(',') != std::string::npos) {
    return true;
  }
  return !EndsWithInvalidPunctuation(accessibility_label);
}

bool AccessibilityLabelNotPunctuatedCheck::EndsWithInvalidPunctuation(
    const std::string &str) const {
  return !str.empty() && str.back() == '.';
}

}  // namespace gtx
