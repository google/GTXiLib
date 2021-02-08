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

#ifndef GTXILIB_OOPCLASSES_IMAGE_COLOR_UTILS_H_
#define GTXILIB_OOPCLASSES_IMAGE_COLOR_UTILS_H_

namespace gtx {
namespace image_color_utils {

// Returns the luminance value for the given color red, green and blue values.
// The color values must be between 0 and 1.
float Luminance(float red, float blue, float green);

// Returns the contrast ratio for the given color luminance values.
float ContrastRatio(float first_luminance, float second_luminance);

}  // namespace image_color_utils
}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_IMAGE_COLOR_UTILS_H_
