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
 *  @param label                 The label whose contrast ratio is to be computed.
 *  @param outAvgTextColor       An optional pointer to be set to the computed text color.
 *  @param outAvgBackgroundColor An optional pointer to be set to the computed background color.
 *
 *  @return The contrast ratio (proportional to 1.0) of the label.
 */
+ (CGFloat)contrastRatioOfUILabel:(UILabel *)label
                  outAvgTextColor:(UIColor **)outAvgTextColor
            outAvgBackgroundColor:(UIColor **)outAvgBackgroundColor;

/**
 *  Computes contrast ratio of the given text view to its background.
 *  This method analyses the text view's text color in the context of its view
    hierarchy in order to compute the contrast ratio, because
 *  of which the text view must already be in a window before this method can be used.
 *
 *  @param view                  The text view whose contrast ratio is to be computed.
 *  @param outAvgTextColor       An optional pointer to be set to the computed text color.
 *  @param outAvgBackgroundColor An optional pointer to be set to the computed background color.
 *
 *  @return The contrast ratio (proportional to 1.0) of the text view.
 */
+ (CGFloat)contrastRatioOfUITextView:(UITextView *)view
                     outAvgTextColor:(UIColor **)outAvgTextColor
               outAvgBackgroundColor:(UIColor **)outAvgBackgroundColor;

/**
 *  Renders the view hierarchy of @c view to @c context, appropriately translating subviews to
 *  render in the correct position. The view hierarchy must be rendered manually because
 *  @c drawViewHierarchy:afterScreenUpdates: with @c YES for @c afterScreenUpdates causes VoiceOver
 *  to reset focus to the first element of the view hierarchy. However, passing @c NO causes the
 *  screenshot to not use any recent changes, such as changing the text color to identify foreground
 *  color. Manually rendering the view hierarchy avoids both of these problems.
 *
 *  @param view The root of the view hierarchy to render.
 *  @param context The graphics context to which to render.
 */
+ (void)renderViewHierarchy:(UIView *)view inContext:(CGContextRef)context;

/**
 * @return an image of the given @c view.
 */
+ (UIImage *)imageFromUIView:(UIView *)view;

/**
 * Renders the views in @c views to a single image, with the first element in back and the last
 * element in front. The size of the image is equal to the greatest width and greatest height of the
 * bounds in @c views. May not be the bounds of the largest view. For example, one view may have a
 * larger width and another has a larger height.
 *
 * @param views The views to render. Fails with an assertion if @c views is empty.
 * @return An image of all the views in @c views.
 */
+ (UIImage *)imageByCompositingViews:(NSArray<UIView *> *)views;

@end
