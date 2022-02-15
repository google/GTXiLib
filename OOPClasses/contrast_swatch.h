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

#ifndef GTXILIB_OOPCLASSES_CONTRAST_SWATCH_H_
#define GTXILIB_OOPCLASSES_CONTRAST_SWATCH_H_

#include "contrast_check.h"
#include "gtx_types.h"

namespace gtx {

// Encapsulates contrast and color data associated with a section of the given
// image data.
class ContrastSwatch {
 public:
  ContrastSwatch(const Color &foreground, const Color &background);

  // Extracts prominent colors (foreground and background) from the given
  // sub-image.
  static ContrastSwatch Extract(const Image &image,
                                const Rect &sub_image_bounds);

  // The background color in the image. Will be black if no background color
  // could be identified.
  const Color &background() { return background_; }

  // The foreground color in the image. Will be black if no foreground color
  // could be identified.
  const Color &foreground() { return foreground_; }

 private:
  Color foreground_, background_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_CONTRAST_SWATCH_H_
