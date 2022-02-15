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

#include "parameters.h"

#include "gtx_types.h"

namespace gtx {

Rect Parameters::ConvertRectToScreenshotSpace(
    const Rect &device_space_rect) const {
  float x_scale =
      static_cast<float>(screenshot_.width / device_bounds_.size.width);
  float y_scale =
      static_cast<float>(screenshot_.height / device_bounds_.size.height);
  Rect converted_rect = device_space_rect.ScaledRect(x_scale, y_scale);
  return converted_rect;
}

}  // namespace gtx
