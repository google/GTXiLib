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

#include <stdint.h>

#include <unordered_map>
#include <utility>

#include <abseil/absl/types/optional.h>
#include "gtx_types.h"

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

  // If only one color exists, it is considered both the foreground and the
  // background color.
  if (color_histogram.size() < 2) {
    Color color = Color::UnpackedColor(color_histogram.cbegin()->first);
    return ContrastSwatch(color, color);
  }
  absl::optional<int> top_key = absl::nullopt;
  absl::optional<int> penultimate_key = absl::nullopt;
  for (auto const &[key, value] : color_histogram) {
    if (!top_key || value > color_histogram[*top_key]) {
      penultimate_key = top_key;
      top_key = key;
    } else if (!penultimate_key || value > color_histogram[*penultimate_key]) {
      penultimate_key = key;
    }
  }

  // Histogram is guaranteed to have 2 colors, so both top_key and
  // penultimate_key will have been set.
  Color background = Color::UnpackedColor(*top_key);
  Color foreground = Color::UnpackedColor(*penultimate_key);
  return ContrastSwatch(foreground, background);
}

}  // namespace gtx
