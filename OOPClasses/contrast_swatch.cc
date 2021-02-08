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

#include "contrast_swatch.h"

#include <unordered_map>

namespace gtx {

ContrastSwatch::ContrastSwatch(const Color &foreground,
                               const Color &background) {
  foreground_ = foreground;
  background_ = background;
}

ContrastSwatch ContrastSwatch::Extract(const Image &image,
                                       const Rect &sub_image_bounds) {
  // Extract a histogram of the colors in the given image (in the given bounds).
  // To determine the most dominant colors.
  std::unordered_map<int32_t, int> color_histogram;
  const int max_index = image.width * image.height;
  for (int x = 0; x < sub_image_bounds.size.width; x++) {
    for (int y = 0; y < sub_image_bounds.size.height; y++) {
      int index = (x + sub_image_bounds.origin.x) +
                  (y + sub_image_bounds.origin.y) * image.width;
      if (index >= 0 && index < max_index) {
        int32_t packed_color = image.pixels[index].PackedColor();
        color_histogram[packed_color] += 1;
      }
    }
  }

  // The most dominant color is considered the background color. Note that the
  // key 0 may not exist in the histogram, however for colors that dont exist
  // the count will be zero causing tap_key to be replaced by an actual color in
  // the histogram with count > zero.
  int top_key = 0;
  int penultimate_key = 0;
  // Save the count of entires in histogram *before* processing it since
  // accessing keys that dont exist may lead to creating the enties with count
  // 0.
  int64_t count = (int64_t)color_histogram.size();
  for (auto const& [key, value] : color_histogram) {
    if (value > color_histogram[top_key]) {
      penultimate_key = top_key;
      top_key = key;
    } else if (value > color_histogram[penultimate_key]) {
      penultimate_key = key;
    }
  }

  Color background = Color::UnpackedColor(top_key);
  Color foreground;
  if (count < 2) {
    // When image has a single color, background and foreground colors are
    // assumed to be the same.
    foreground = background;
  } else {
    foreground = Color::UnpackedColor(penultimate_key);
  }
  return ContrastSwatch(foreground, background);
}

}  // namespace gtx
