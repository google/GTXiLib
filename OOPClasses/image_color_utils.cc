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

#include "image_color_utils.h"

#include <assert.h>
#include <math.h>

#include <algorithm>

#include "gtx_types.h"

namespace gtx {

namespace {

// Returns color component in the appropriate range to calculate the luminance
// of an RGB color.
float AdjustColorComponentRangeForLuminance(float component) {
  // Based on
  // https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
  if (component < 0.03928f) {
    return component / 12.92f;
  } else {
    return static_cast<float>(pow((component + 0.055f) / 1.055f, 2.4f));
  }
}

}  // namespace

namespace image_color_utils {

float Luminance(float red, float blue, float green) {
  // Based on
  // https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
  return (0.2126f * AdjustColorComponentRangeForLuminance(red) +
          0.0722f * AdjustColorComponentRangeForLuminance(blue) +
          0.7152f * AdjustColorComponentRangeForLuminance(green));
}

float ContrastRatio(float first_luminance, float second_luminance) {
  assert(first_luminance >= 0);
  assert(second_luminance >= 0);
  float brighter_luminance = std::max(first_luminance, second_luminance);
  float darker_luminance = std::min(first_luminance, second_luminance);
  // Based on https://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef
  return (brighter_luminance + 0.05f) / (darker_luminance + 0.05f);
}

}  // namespace image_color_utils
}  // namespace gtx
