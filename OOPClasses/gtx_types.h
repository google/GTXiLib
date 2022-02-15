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

#ifndef GTXILIB_OOPCLASSES_GTX_TYPES_H_
#define GTXILIB_OOPCLASSES_GTX_TYPES_H_

#include <math.h>
#include <stdint.h>

#include "gtx.pb.h"

#pragma mark - Types

namespace gtx {

typedef gtxilib::oopclasses::protos::Rect RectData;

// Forward declarations.
class ErrorMessage;
class UIElement;

// Color is defined using rgba components for parity with pixels in @c
// GTXImageRGBAData.
struct Color {
  unsigned char red, green, blue, alpha;

  // Equality implementation for Colors.
  bool operator==(const Color &other) const;

  // Packs the given color into a single int32_t value. Note that the color is
  // assumed to have alpha pre-multiplied, i.e. it is ignored.
  int32_t PackedColor() const;

  // Luminance of this color with alpha pre-multiplied, luminance is a measure
  // of brightness, it is 0 for black color and 1 for white color.
  float Luminance() const;

  // Unpacks the color from the given packed color.
  static Color UnpackedColor(int32_t packed_color);
};
typedef struct Color Pixel;

// Structure to hold 2D point data, modelled after CGPoint.
struct Point {
  float x, y;
  Point() : x(0), y(0){};
  Point(float x, float y) : x(x), y(y) {}
};

// Structure to hold 2D size data, modelled after CGSize.
struct Size {
  float width, height;
  Size() : width(0), height(0){};
  Size(float width, float height) : width(width), height(height) {}
};

// Structure to hold 2D rectangle data, modelled after CGRect.
struct Rect {
  Point origin;
  Size size;
  Rect(const RectData &rect);
  Rect() : origin(0, 0), size(0, 0) {}
  Rect(float x, float y, float width, float height)
      : origin(x, y), size(width, height) {}

  float GetMaxX() const { return origin.x + fabs(size.width); }
  float GetMaxY() const { return origin.y + fabs(size.height); }
  Rect ScaledRect(float x_scale, float y_scale) const;
};

// Image is defined as a 2D block of pixels/color values.
// TODO: Update this struct to use protobuf.
struct Image {
  // Dimensions of the image are in pixels.
  int width, height;
  Pixel *pixels;

  // Constructs a new empty image.
  Image() {}

  // Constructs a new image with the given pixels and dimensions, note that
  // pixel memory is not owned by this instance.
  Image(Pixel *pixels, int width, int height);
};

// A reference to Objective-C element (UIView/UIAccessibilityElement) to be used
// by checks that need to call into iOS environment when available.
typedef void *ElementRef;

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_GTX_TYPES_H_
