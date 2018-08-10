//
// Copyright 2018 Google Inc.
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

extern const CGFloat kGTXContrastRatioAccuracy;

/**
 *  Collection of accessibility related utils that use colors and/or images.
 */
@interface GTXImageAndColorUtils : NSObject

/**
 *  Computes luminance for the color composed of the given RGB values.
 *
 *  @param red   Red component value.
 *  @param blue  Blue component value.
 *  @param green Green component value.
 *
 *  @return luminance value for the color consisting of the given RGB values.
 */
+ (CGFloat)luminanceWithRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green;

/**
 *  @return luminance value for the given color.
 */
+ (CGFloat)luminanceWithColor:(UIColor *)color;

/**
 *  Computes the contrast ratio from the given luminance values.
 *
 *  @param color1Luminance Luminance value for the first color.
 *  @param color2Luminance Luminance value for the second color.
 *
 *  @return Contrast ratio for the given two luminance values.
 */
+ (CGFloat)contrastRatioWithLuminaceOfFirstColor:(CGFloat)color1Luminance
                       andLuminanceOfSecondColor:(CGFloat)color2Luminance;

/**
 *  Computes contrast ratio of the given label to its background. This method analyses the label's
 *  text color in the context of its view hierarchy in order to compute the contrast ratio, because
 *  of which the label must already be in a window before this method can be used.
 *
 *  @param label The label whose contrast ratio is to be computed.
 *
 *  @return The contrast ratio (proportional to 1.0) of the label.
 */
+ (CGFloat)contrastRatioOfUILabel:(UILabel *)label;

@end
