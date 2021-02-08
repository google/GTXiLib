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

namespace gtx {

/**
 *  The minimum contrast ratio for given text to be considered accessible.
 */
static const float kMinContrastRatioForAccessibleText = 3.0;

bool ContrastCheck::CheckElement(const UIElement &element,
                                 const Parameters &params,
                                 ErrorMessage *errorMessage) const {
  if ((element.ax_traits() & ElementTrait::kStaticText) ==
      ElementTrait::kNone) {
    return true;
  }
  Rect frame(element.ax_frame());
  Rect screenshot_bounds = params.ConvertRectToScreenshotSpace(frame);
  ContrastSwatch swatch =
      ContrastSwatch::Extract(params.screenshot(), screenshot_bounds);
  float contrast_ratio = image_color_utils::ContrastRatio(
      swatch.foreground().Luminance(), swatch.background().Luminance());
  return contrast_ratio >= kMinContrastRatioForAccessibleText;
}

}  // namespace gtx
