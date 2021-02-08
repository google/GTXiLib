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
#import <XCTest/XCTest.h>

#import "GTXImageAndColorUtils.h"
#import "UIColor+GTXAdditions.h"

static const CGFloat kTestColorAccuracy = 0.01f;  // Expect colors to be accurate to 1%

@interface GTXImageAndColorUtils (ExposedForTesting)
+ (UIColor *)gtx_shiftedColorWithColor:(UIColor *)color;
+ (CGFloat)gtx_contrastRatioWithTextElementImage:(UIImage *)original
                    textElementColorShiftedImage:(UIImage *)colorShifted
                                 outAvgTextColor:(UIColor **)outAvgTextColor
                           outAvgBackgroundColor:(UIColor **)outAvgBackgroundColor;
@end

@interface GTXImageAndColorUtilsTests : XCTestCase
@end

@implementation GTXImageAndColorUtilsTests

- (void)testLuminanceAlgorithmWorks {
  const CGFloat kAccuracy = 0.01f;
  // Values computed using http://springmeier.org/www/contrastcalculator/index.php
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:[UIColor redColor]],
                             0.21f, kAccuracy);
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:[UIColor blueColor]],
                             0.07f, kAccuracy);
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:[UIColor greenColor]],
                             0.72f, kAccuracy);
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:[UIColor whiteColor]],
                             1.0f, kAccuracy);
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:[UIColor blackColor]],
                             0, kAccuracy);
  XCTAssertEqualWithAccuracy(
      [GTXImageAndColorUtils luminanceWithColor:[UIColor colorWithWhite:0.5f alpha:1.0f]],
      0.22f, kAccuracy);

  // We are using colorWithRed:green:blue:alpha: instead of UIColor::orangeColor to ensure known
  // and testable values for red, green and blue.
  UIColor *orange = [UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f];
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:orange], 0.37f, kAccuracy);

  // We are using colorWithRed:green:blue:alpha: instead of UIColor::purpleColor to ensure known
  // and testable values for red, green and blue.
  UIColor *purple = [UIColor colorWithRed:0.5f green:0.25f blue:0.5f alpha:1.0f];
  XCTAssertEqualWithAccuracy([GTXImageAndColorUtils luminanceWithColor:purple], 0.1f, kAccuracy);
}

- (void)testShiftedColorsAreDifferent {
  [self gtxtest_assertColor:[UIColor blackColor]
       isDifferentFromColor:[GTXImageAndColorUtils gtx_shiftedColorWithColor:[UIColor blackColor]]];
  [self gtxtest_assertColor:[UIColor whiteColor]
       isDifferentFromColor:[GTXImageAndColorUtils gtx_shiftedColorWithColor:[UIColor whiteColor]]];
  UIColor *grey = [UIColor colorWithWhite:0.5f alpha:1.0f];
  [self gtxtest_assertColor:grey
       isDifferentFromColor:[GTXImageAndColorUtils gtx_shiftedColorWithColor:grey]];
}

- (void)testContrastRatioIsComputedAccuratelyForLargeImages {
  // Create a large grey image with light grey rect inside it.
  CGSize imageSize = CGSizeMake(1000, 1000);
  CGRect rect = CGRectMake(200, 200, 500, 500);
  UIColor *testDarkGrey = [UIColor colorWithWhite:0.4 alpha:1.0];
  UIColor *testLightGrey = [UIColor colorWithWhite:0.5 alpha:1.0];
  [self gtx_assertContrastRatioIsSufficientlyAccurateInImageOfSize:imageSize
                                                             color:testLightGrey
                                                          withRect:rect
                                                           ofColor:testDarkGrey];
}

- (void)testContrastRatioIsComputedAccuratelyForSmallImages {
  // Create a small red image with purple rect inside it.
  CGSize imageSize = CGSizeMake(40, 40);
  CGRect rect = CGRectMake(0, 0, 10, 10);
  [self gtx_assertContrastRatioIsSufficientlyAccurateInImageOfSize:imageSize
                                                             color:[UIColor redColor]
                                                          withRect:rect
                                                           ofColor:[UIColor purpleColor]];
}

- (void)testColorDescriptionWorksAsExpected {
  XCTAssertTrue([[[UIColor redColor] gtx_description] containsString:@" #FF0000 "]);
  XCTAssertTrue([[[UIColor greenColor] gtx_description] containsString:@" #00FF00 "]);
  XCTAssertTrue([[[UIColor blueColor] gtx_description] containsString:@" #0000FF "]);
  XCTAssertTrue([[[UIColor blackColor] gtx_description] containsString:@" #000000 "]);
  XCTAssertTrue([[[UIColor whiteColor] gtx_description] containsString:@" #FFFFFF "]);
}

#pragma mark - Private

/**
 *  Asserts that the contrast ratio of colors in an image is same that computed from colors
 *  directly.
 *
 *  @param size            Image size.
 *  @param backgroundColor Background color on the image.
 *  @param rect            Rectangle to be filled with @c rectColor.
 *  @param rectColor       Fill color for @c rect.
 */

- (void)gtx_assertContrastRatioIsSufficientlyAccurateInImageOfSize:(CGSize)size
                                                             color:(UIColor *)backgroundColor
                                                          withRect:(CGRect)rect
                                                           ofColor:(UIColor *)rectColor {
  // Create an image with the given colors.
  UIImage *imageWithRect = [self gtxtest_imageOfColor:backgroundColor
                                               inSize:size
                                      withRectOfColor:rectColor
                                                   atRect:rect];

  // Create the same image with rectColor replaced by its shifted color.
  UIColor *shiftedColor = [GTXImageAndColorUtils gtx_shiftedColorWithColor:rectColor];
  UIImage *imageWithShiftedColorRect = [self gtxtest_imageOfColor:backgroundColor
                                                           inSize:size
                                                  withRectOfColor:shiftedColor
                                                               atRect:rect];

  // Assert that contrast ratio of the image is almost the same as contrast ratio of individual
  // colors.
  CGFloat luminanceOfFirstColor = [GTXImageAndColorUtils luminanceWithColor:backgroundColor];
  CGFloat luminanceOfSecondColor = [GTXImageAndColorUtils luminanceWithColor:rectColor];
  CGFloat contrastRatioOfColors =
      [GTXImageAndColorUtils contrastRatioWithLuminaceOfFirstColor:luminanceOfFirstColor
                                         andLuminanceOfSecondColor:luminanceOfSecondColor];
  UIColor *actualTextColor, *actualBackgroundColor;
  CGFloat contrastRatioInImage =
      [GTXImageAndColorUtils gtx_contrastRatioWithTextElementImage:imageWithRect
                                      textElementColorShiftedImage:imageWithShiftedColorRect
                                                   outAvgTextColor:&actualTextColor
                                             outAvgBackgroundColor:&actualBackgroundColor];
  XCTAssertEqualWithAccuracy(contrastRatioInImage,
                             contrastRatioOfColors,
                             kGTXContrastRatioAccuracy);
  [self gtxtest_assertColor:actualTextColor isSameAsColor:rectColor];
  [self gtxtest_assertColor:actualBackgroundColor isSameAsColor:backgroundColor];
}

/**
 *  Create an image with the given color and draws a rect filled with the given fill color.
 *
 *  @param backgroundColor Background color on the image.
 *  @param imageSize       Image size.
 *  @param rectColor       Fill color for @c rect.
 *  @param rect            Rectangle to be filled with @c rectColor.
 *
 *  @return An UIImage with the given color.
 */

- (UIImage *)gtxtest_imageOfColor:(UIColor *)backgroundColor
                           inSize:(CGSize)imageSize
                  withRectOfColor:(UIColor *)rectColor
                           atRect:(CGRect)rect {
  UIGraphicsBeginImageContext(imageSize);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
  CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
  CGContextSetFillColorWithColor(context, rectColor.CGColor);
  CGContextFillRect(context, rect);
  UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return testImage;
}

- (void)gtxtest_assertColor:(UIColor *)first isDifferentFromColor:(UIColor *)second {
  CGFloat firstRed, firstGreen, firstBlue;
  CGFloat secondRed, secondGreen, secondBlue;
  [first getRed:&firstRed green:&firstGreen blue:&firstBlue alpha:NULL];
  [second getRed:&secondRed green:&secondGreen blue:&secondBlue alpha:NULL];
  XCTAssertNotEqualWithAccuracy(firstRed, secondRed, kTestColorAccuracy);
  XCTAssertNotEqualWithAccuracy(firstBlue, secondBlue, kTestColorAccuracy);
  XCTAssertNotEqualWithAccuracy(firstGreen, secondGreen, kTestColorAccuracy);
}

- (void)gtxtest_assertColor:(UIColor *)first isSameAsColor:(UIColor *)second {
  CGFloat firstRed, firstGreen, firstBlue;
  CGFloat secondRed, secondGreen, secondBlue;
  [first getRed:&firstRed green:&firstGreen blue:&firstBlue alpha:NULL];
  [second getRed:&secondRed green:&secondGreen blue:&secondBlue alpha:NULL];
  XCTAssertEqualWithAccuracy(firstRed, secondRed, kTestColorAccuracy);
  XCTAssertEqualWithAccuracy(firstBlue, secondBlue, kTestColorAccuracy);
  XCTAssertEqualWithAccuracy(firstGreen, secondGreen, kTestColorAccuracy);
}
@end
