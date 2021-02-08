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

namespace gtx {

// The minimum size (width or height) for a given element to be easily
// accessible. Please read Material design guidelines for more on touch targets:
// https://material.io/design/layout/spacing-methods.html#touch-click-targets
static const float kMinSizeForAccessibleElements = 44.0;

bool MinimumTappableAreaCheck::CheckElement(const UIElement &element,
                                            const Parameters &params,
                                            ErrorMessage *errorMessage) const {
  if ((element.ax_traits() & ElementTrait::kButton) == ElementTrait::kNone) {
    return true;
  }
  if (element.ax_frame().size().width() < kMinSizeForAccessibleElements ||
      element.ax_frame().size().height() < kMinSizeForAccessibleElements) {
    return false;
  }
  return true;
}

}  // namespace gtx
