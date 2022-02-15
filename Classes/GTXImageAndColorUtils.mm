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

#import "GTXImageAndColorUtils.h"

#import "GTXAssertions.h"
#import "GTXImageRGBAData.h"
#include "image_color_utils.h"

/**
 *  Accuracy of the contrast ratios provided by the APIs in this class.
 */
const CGFloat kGTXContrastRatioAccuracy = 0.05f;

@implementation GTXImageAndColorUtils

+ (CGFloat)luminanceWithRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green {
  return gtx::image_color_utils::Luminance(red, blue, green);
}

+ (CGFloat)luminanceWithColor:(UIColor *)color {
  CGFloat red, blue, green;
  [color getRed:&red green:&green blue:&blue alpha:NULL];
  return [self luminanceWithRed:red blue:blue green:green];
}

+ (CGFloat)contrastRatioWithLuminaceOfFirstColor:(CGFloat)color1Luminance
                       andLuminanceOfSecondColor:(CGFloat)color2Luminance {
  return gtx::image_color_utils::ContrastRatio(color1Luminance, color2Luminance);
}

+ (CGFloat)contrastRatioOfUILabel:(UILabel *)label
                  outAvgTextColor:(UIColor **)outAvgTextColor
            outAvgBackgroundColor:(UIColor **)outAvgBackgroundColor {
  NSAssert(label.window,
           @"Label %@ must be part of view hierarchy to use this method, see API"
           @" docs for more info.",
           label);

  // Take snapshot of the label as it exists.
  UIImage *before = [self gtx_takeSnapshot:label];

  // Update the text color and take another snapshot.
  UIColor *prevColor = label.textColor;
  label.textColor = [self gtx_shiftedColorWithColor:prevColor];
  UIImage *after = [self gtx_takeSnapshot:label];
  label.textColor = prevColor;

  return [self gtx_contrastRatioWithTextElementImage:before
                        textElementColorShiftedImage:after
                                     outAvgTextColor:outAvgTextColor
                               outAvgBackgroundColor:outAvgBackgroundColor];
}

+ (CGFloat)contrastRatioOfUITextView:(UITextView *)view
                     outAvgTextColor:(UIColor **)outAvgTextColor
               outAvgBackgroundColor:(UIColor **)outAvgBackgroundColor {
  NSAssert(view.window,
           @"View %@ must be part of view hierarchy to use this method, see API"
           @" docs for more info.",
           view);

  // Take snapshot of the text view as it exists.
  UIImage *before = [self gtx_takeSnapshot:view];

  // Update the text color and take another snapshot.
  UIColor *prevColor = view.textColor;
  view.textColor = [self gtx_shiftedColorWithColor:prevColor];
  UIImage *after = [self gtx_takeSnapshot:view];
  view.textColor = prevColor;

  return [self gtx_contrastRatioWithTextElementImage:before
                        textElementColorShiftedImage:after
                                     outAvgTextColor:outAvgTextColor
                               outAvgBackgroundColor:outAvgBackgroundColor];
}

+ (void)renderViewHierarchy:(UIView *)view inContext:(CGContextRef)context {
  CGFloat xOffset = CGRectGetMinX(view.frame) - CGRectGetMinX(view.bounds);
  CGFloat yOffset = CGRectGetMinY(view.frame) - CGRectGetMinY(view.bounds);
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, xOffset, yOffset);
  [view.layer renderInContext:context];
  for (UIView *subview in view.subviews) {
    [GTXImageAndColorUtils renderViewHierarchy:subview inContext:context];
  }
  CGContextRestoreGState(context);
}

+ (UIImage *)imageFromUIView:(UIView *)view {
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return finalImage;
}

+ (UIImage *)imageByCompositingViews:(NSArray<UIView *> *)views {
  GTX_ASSERT(views.count > 0, @"views cannot be empty.");
  CGSize size = [[self class] gtx_maximumSizeInViews:views];
  UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
  for (UIView *view in views) {
    // Pass NO to prevent VoiceOver from resetting focus.
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
  }
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

#pragma mark - Utils

+ (UIImage *)gtx_takeSnapshot:(UIView *)element {
  CGRect labelBounds = [element.window convertRect:element.bounds fromView:element];
  UIWindow *window = element.window;
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    UIGraphicsBeginImageContextWithOptions(labelBounds.size, NO, [UIScreen mainScreen].scale);
  } else {
    UIGraphicsBeginImageContext(labelBounds.size);
  }
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, -labelBounds.origin.x, -labelBounds.origin.y);
  [GTXImageAndColorUtils renderViewHierarchy:window inContext:context];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

/**
 *  Computes the contrast ratio for the text in the given image. This method also requires image of
 *  the text element with the text color changed, by comparing both the image pixels its possible to
 *  determine which pixels belong to text (will change between images) and which ones belong to the
 *  background (unchanged between images). The pixel values are used to determine contrast
 *  ratio of the text on the given background.
 *
 *  @param original     The original image of the text element.
 *  @param colorShifted Image of the text element with color of the text shifted (changed).
 *
 *  @return The contrast ratio (proportional to 1.0) of the label.
 */
+ (CGFloat)gtx_contrastRatioWithTextElementImage:(UIImage *)original
                    textElementColorShiftedImage:(UIImage *)colorShifted
                                 outAvgTextColor:(UIColor **)outAvgTextColor
                           outAvgBackgroundColor:(UIColor **)outAvgBackgroundColor {
  // Luminance of image is computed using Reinhard’s method:
  // Luminance of image = Geometric Mean of luminance of individual pixels.
  CGFloat textLogAverage = 0;
  NSInteger textPixelCount = 0;
  CGFloat backgroundLogAverage = 0;
  NSInteger backgroundPixelCount = 0;
  const NSInteger bytesPerPixel = 4;
  GTXImageRGBAData *beforeData = [[GTXImageRGBAData alloc] initWithUIImage:original];
  GTXImageRGBAData *afterData = [[GTXImageRGBAData alloc] initWithUIImage:colorShifted];
  struct {
    CGFloat totalRed, totalBlue, totalGreen;
    NSInteger count;
  } textColor = {}, backgroundColor = {};

  // Geometric mean of n numbers is the nth root of the product of the numbers however to avoid
  // issues with floating point accuracies we first compute the average of the logarithms and then
  // compute e to the power of the average. Also, since luminances are in the range of 0 to 1 the
  // logarithms will lie in the range negative infinity to 0 which will still cause inaccuracies
  // when we sum them, to avoid this we first offset all luminances by 1.0 and scale them by
  // e - 1 (~1.7182) causing their logarithms to fall in the range of 0 to 1 instead leading to
  // better accuracy of the geometric mean.
  const CGFloat luminanceOffset = 1.0f;
  const CGFloat luminanceScale = (CGFloat)M_E - luminanceOffset;
  for (NSUInteger column = 0; column < beforeData.width; column++) {
    for (NSUInteger row = 0; row < beforeData.height; row++) {
      unsigned char *beforeOffset =
          beforeData.rgba + column * bytesPerPixel + row * beforeData.bytesPerRow;
      unsigned char *afterOffset =
          afterData.rgba + column * bytesPerPixel + row * afterData.bytesPerRow;
      CGFloat red = beforeOffset[0] / 255.0f;
      CGFloat green = beforeOffset[1] / 255.0f;
      CGFloat blue = beforeOffset[2] / 255.0f;
      CGFloat alpha = beforeOffset[3];

      if (alpha == 0) {
        // Skip transparent pixels.
        continue;
      }

      CGFloat logLuminance =
          (CGFloat)log(luminanceOffset + luminanceScale * [self luminanceWithRed:red
                                                                            blue:blue
                                                                           green:green]);
      if (beforeOffset[0] != afterOffset[0]) {
        // This pixel has changed from before: it is part of the text.
        textLogAverage += logLuminance;
        textPixelCount += 1;
        textColor.totalRed += red;
        textColor.totalGreen += green;
        textColor.totalBlue += blue;
        textColor.count += 1;
      } else {
        // This pixel has *not* changed from before: it is part of the text background.
        backgroundLogAverage += logLuminance;
        backgroundPixelCount += 1;
        backgroundColor.totalRed += red;
        backgroundColor.totalGreen += green;
        backgroundColor.totalBlue += blue;
        backgroundColor.count += 1;
      }
    }
  }

  // Compute the geometric mean and scale the result back.
  CGFloat textLuminance = 1.0f;
  if (textPixelCount != 0) {
    textLuminance =
        (CGFloat)(exp(textLogAverage / textPixelCount) - luminanceOffset) / luminanceScale;
  }
  CGFloat backgroundLuminance = 1.0;
  if (backgroundPixelCount != 0) {
    backgroundLuminance =
        (CGFloat)(exp(backgroundLogAverage / backgroundPixelCount) - luminanceOffset) /
        luminanceScale;
  }
  if (outAvgTextColor) {
    *outAvgTextColor = [UIColor colorWithRed:textColor.totalRed / (CGFloat)textColor.count
                                       green:textColor.totalGreen / (CGFloat)textColor.count
                                        blue:textColor.totalBlue / (CGFloat)textColor.count
                                       alpha:1];
  }
  if (outAvgBackgroundColor) {
    *outAvgBackgroundColor =
        [UIColor colorWithRed:backgroundColor.totalRed / (CGFloat)backgroundColor.count
                        green:backgroundColor.totalGreen / (CGFloat)backgroundColor.count
                         blue:backgroundColor.totalBlue / (CGFloat)backgroundColor.count
                        alpha:1];
  }
  return [self contrastRatioWithLuminaceOfFirstColor:textLuminance
                           andLuminanceOfSecondColor:backgroundLuminance];
}

/**
 *  @return The color obtained by shifting (and rotating around 1.0 if needed) the RGBA values by
 *          0.5.
 */
+ (UIColor *)gtx_shiftedColorWithColor:(UIColor *)color {
  CGFloat red, blue, green, alpha;
  [color getRed:&red green:&green blue:&blue alpha:&alpha];
  // Rotate red blue and green around 1.0.
  red += 1.0f;
  blue += 1.0f;
  green += 1.0f;
  red = red > 1.0f ? 1.0f - red : red;
  blue = blue > 1.0f ? 1.0f - blue : blue;
  green = green > 1.0f ? 1.0f - green : green;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/**
 * Calculates the maximum size enclosing all bounds in @c views.
 *
 * @param views The views to calculate the maximum size of. Fails with an assertion if @c views is
 *  empty.
 * @return A size enclosing all bounds in @c views. May not be the bounds of the largest view. For
 *  example, one view may have a larger width and another has a larger height.
 */
+ (CGSize)gtx_maximumSizeInViews:(NSArray<UIView *> *)views {
  GTX_ASSERT(views.count > 0, @"views cannot be empty.");
  CGFloat width = views[0].bounds.size.width;
  CGFloat height = views[0].bounds.size.height;
  for (UIView *view in views) {
    if (view.bounds.size.width > width) {
      width = view.bounds.size.width;
    }
    if (view.bounds.size.height > height) {
      height = view.bounds.size.height;
    }
  }
  return CGSizeMake(width, height);
}

@end
