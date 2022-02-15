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

#import <UIKit/UIKit.h>

#import "UIColor+GTXOOPAdditions.h"

/**
 *  The minimum size required to make UIElements accessible.
 */
static const CGFloat kGTXMaxColorByteValue = 255.0;

@implementation UIColor (GTXOOPAdditions)

- (std::unique_ptr<gtx::Color>)gtx_color {
  auto color = std::make_unique<gtx::Color>();
  CGFloat red, blue, green, alpha;
  [self getRed:&red green:&green blue:&blue alpha:&alpha];
  color->red = kGTXMaxColorByteValue * red;
  color->green = kGTXMaxColorByteValue * green;
  color->blue = kGTXMaxColorByteValue * blue;
  color->alpha = kGTXMaxColorByteValue * alpha;
  return color;
}

+ (UIColor *)gtx_colorFromGTXColor:(const gtx::Color &)gtxColor {
  return [UIColor colorWithRed:gtxColor.red / kGTXMaxColorByteValue
                         green:gtxColor.green / kGTXMaxColorByteValue
                          blue:gtxColor.blue / kGTXMaxColorByteValue
                         alpha:gtxColor.alpha / kGTXMaxColorByteValue];
}

@end
