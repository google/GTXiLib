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

#include "gtx_types.h"

#include <stdint.h>

#include "gtx.pb.h"
#include "image_color_utils.h"

bool gtx::Color::operator==(const gtx::Color& other) const {
  return (red == other.red && green == other.green && blue == other.blue &&
          alpha == other.alpha);
}

int32_t gtx::Color::PackedColor() const {
  int32_t red = this->red;
  int32_t green = this->green;
  int32_t blue = this->blue;
  return (red << 16) | (green << 8) | (blue);
}

float gtx::Color::Luminance() const {
  return gtx::image_color_utils::Luminance(red / 255.0, blue / 255.0,
                                           green / 255.0);
}

gtx::Color gtx::Color::UnpackedColor(int32_t packed_color) {
  Color unpacked_color;
  unpacked_color.red =
      static_cast<unsigned char>((packed_color & 0x00FF0000) >> 16);
  unpacked_color.green =
      static_cast<unsigned char>((packed_color & 0x0000FF00) >> 8);
  unpacked_color.blue = static_cast<unsigned char>(packed_color & 0x000000FF);
  unpacked_color.alpha = 255;
  return unpacked_color;
}

gtx::Rect::Rect(
    const gtxilib::oopclasses::protos::Rect &rect) {
  origin.x = rect.origin().x();
  origin.y = rect.origin().y();
  size.width = rect.size().width();
  size.height = rect.size().height();
}

gtx::Rect gtx::Rect::ScaledRect(float x_scale, float y_scale) const {
  return Rect(this->origin.x * x_scale, this->origin.y * y_scale,
              this->size.width * x_scale, this->size.height * y_scale);
}

gtx::Image::Image(gtx::Pixel *pixels, int width, int height)
    : width(width), height(height), pixels(pixels) {}
