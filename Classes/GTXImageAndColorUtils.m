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

#import "GTXImageRGBAData.h"

/**
 *  Accuracy of the contrast ratios provided by the APIs in this class.
 */
const CGFloat kGTXContrastRatioAccuracy = 0.05f;

@implementation GTXImageAndColorUtils

+ (CGFloat)luminanceWithRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green {
  // Based on https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
  CGFloat (^adjustedComponent)(CGFloat) = ^CGFloat(CGFloat component) {
    if (component < 0.03928f) {
      return component / 12.92f;
    } else {
      return (CGFloat)pow((component + 0.055f) / 1.055f, 2.4f);
    }
  };
  return (0.2126f * adjustedComponent(red) +
          0.0722f * adjustedComponent(blue) +
          0.7152f * adjustedComponent(green));
}

+ (CGFloat)luminanceWithColor:(UIColor *)color {
  CGFloat red, blue, green;
  [color getRed:&red green:&green blue:&blue alpha:NULL];
  return [self luminanceWithRed:red blue:blue green:green];
}

+ (CGFloat)contrastRatioWithLuminaceOfFirstColor:(CGFloat)color1Luminance
                       andLuminanceOfSecondColor:(CGFloat)color2Luminance {
  NSParameterAssert(color2Luminance >= 0);
  NSParameterAssert(color1Luminance >= 0);
  CGFloat brighterColorLuminance = MAX(color1Luminance, color2Luminance);
  CGFloat darkerColorLuminance = MIN(color1Luminance, color2Luminance);
  // Based on https://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef
  return (brighterColorLuminance + 0.05f) / (darkerColorLuminance + 0.05f);
}

+ (CGFloat)contrastRatioOfUILabel:(UILabel *)label {
  NSAssert(label.window, @"Label %@ must be part of view hierarchy to use this method, see API "
                         @"docs for more info.", label);
  // Create a block that can take snapshot of the given label.
  UIImage *(^takeSnapshot)(void) = ^{
    CGRect labelBounds = [label.window convertRect:label.bounds fromView:label];
    UIWindow *window = label.window;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
      UIGraphicsBeginImageContextWithOptions(labelBounds.size,
                                             NO, [UIScreen mainScreen].scale);
    } else {
      UIGraphicsBeginImageContext(labelBounds.size);
    }
    CGRect screenRect = CGRectZero;
    screenRect.origin = CGPointMake(-labelBounds.origin.x,
                                    -labelBounds.origin.y);
    screenRect.size = window.bounds.size;
    [window drawViewHierarchyInRect:screenRect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
  };

  // Take snapshot of the label as it exists.
  UIImage *before = takeSnapshot();

  // Update the text color and take another snapshot.
  UIColor *prevColor = label.textColor;
  label.textColor = [self gtx_shiftedColorWithColor:prevColor];
  UIImage *after = takeSnapshot();
  label.textColor = prevColor;

  return [self gtx_contrastRatioWithTextElementImage:before textElementColorShiftedImage:after];
}

#pragma mark - Utils

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
                    textElementColorShiftedImage:(UIImage *)colorShifted {
  // Luminace of image is computed using Reinhard’s method:
  // Luminace of image = Geometric Mean of luminance of individual pixels.
  CGFloat textLogAverage = 0;
  NSInteger textPixelCount = 0;
  CGFloat backgroundLogAverage = 0;
  NSInteger backgroundPixelCount = 0;
  GTXImageRGBAData *beforeData = [[GTXImageRGBAData alloc] initWithUIImage:original];
  GTXImageRGBAData *afterData = [[GTXImageRGBAData alloc] initWithUIImage:colorShifted];

  // Geometric mean of n numbers is the nth root of the product of the numbers however to avoid
  // issues with floating point accuracies we first compute the average of the logarithms and then
  // compute e to the power of the average. Also, since luminances are in the range of 0 to 1 the
  // logarithms will lie in the range negative infinity to 0 which will still cause inaccuracies
  // when we sum them, to avoid this we first offset all luminances by 1.0 and scale them by
  // e (~2.7182) causing their logarithms to fall in the range of 0 to 1 instead leading to better
  // accuracy of the geometric mean.
  const CGFloat luminanceOffset = 1.0f;
  const CGFloat luminanceScale = (CGFloat)M_E;
  for (NSUInteger column = 0; column < beforeData.width; column++) {
    for (NSUInteger row = 0; row < beforeData.height; row++) {
      unsigned char *beforeOffset =
          beforeData.rgba + column * beforeData.bytesPerPixel + row * beforeData.bytesPerRow;
      unsigned char *afterOffset =
          afterData.rgba + column * afterData.bytesPerPixel + row * afterData.bytesPerRow;
      CGFloat red = beforeOffset[0] / 255.0f;
      CGFloat green = beforeOffset[1] / 255.0f;
      CGFloat blue = beforeOffset[2] / 255.0f;
      CGFloat alpha = beforeOffset[3];

      if (alpha == 0) {
        // Skip transparent pixels.
        continue;
      }

      CGFloat logLuminance =
          (CGFloat)log(luminanceOffset +
                       luminanceScale * [self luminanceWithRed:red blue:blue green:green]);
      if (beforeOffset[0] != afterOffset[0]) {
        // This pixel has changed from before: it is part of the text.
        textLogAverage += logLuminance;
        textPixelCount += 1;
      } else {
        // This pixel has *not* changed from before: it is part of the text background.
        backgroundLogAverage += logLuminance;
        backgroundPixelCount += 1;
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

@end
