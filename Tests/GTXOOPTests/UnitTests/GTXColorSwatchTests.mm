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
#import <XCTest/XCTest.h>

#import "GTXImageRGBAData+GTXOOPAdditions.h"
#import "UIColor+GTXOOPAdditions.h"
#include "contrast_swatch.h"
#include "GTXUITestUtils.h"

@interface GTXContrastSwatchTests : XCTestCase
@end

@implementation GTXContrastSwatchTests

- (void)testContrastSwatchWithOneColorImage {
  // This test relies on type casting of rgba values to gtx::Pixel instances.
  XCTAssertEqual(sizeof(gtx::Pixel), sizeof(unsigned char) * kBytesPerPixel);
  UIColor *fillColor = [UIColor whiteColor];
  const int width = 2, height = 2;
  std::unique_ptr<unsigned char> pixels(new unsigned char[width * height * kBytesPerPixel]);
  [GTXUITestUtils fillRect:CGRectMake(0, 0, width, height)
                 withColor:fillColor
                  inBuffer:pixels.get()
                    ofSize:CGSizeMake(width, height)];
  gtx::Image image = gtx::Image((gtx::Pixel *)pixels.get(), width, height);
  gtx::Rect rect(0, 0, width, height);
  gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(image, rect);

  std::unique_ptr<gtx::Color> expected_color = [fillColor gtx_color];
  XCTAssertTrue(*expected_color == swatch.background());
  XCTAssertTrue(*expected_color == swatch.foreground());
}

- (void)testContrastSwatchWithOneColorUIImage {
  UIColor *fillColor = [UIColor whiteColor];
  CGRect testImageBounds = CGRectMake(0, 0, 10, 10);
  UIGraphicsBeginImageContextWithOptions(testImageBounds.size, YES, 1.0);
  [fillColor setFill];
  [[UIBezierPath bezierPathWithRect:testImageBounds] fill];
  UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  std::unique_ptr<gtx::Image> image =
      [[[GTXImageRGBAData alloc] initWithUIImage:testImage] gtxImage];
  gtx::Rect rect(0, 0, testImageBounds.size.width, testImageBounds.size.height);
  gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(*image, rect);

  std::unique_ptr<gtx::Color> expected_color = [fillColor gtx_color];
  XCTAssertTrue(*expected_color == swatch.background());
  // Foreground color may not match expected_color possibly due to artifacts due to conversion
  // from UIImage objects.
}

- (void)testContrastSwatchWithTwoProminentColors {
  // This test relies on type casting of rgba values to gtx::Pixel instances.
  XCTAssertEqual(sizeof(gtx::Pixel), sizeof(unsigned char) * kBytesPerPixel);

  UIColor *backgroundColor = [UIColor whiteColor];
  UIColor *innerColor = [UIColor yellowColor];

  const NSInteger width = 20;
  const NSInteger height = 20;
  std::unique_ptr<unsigned char> pixels(new unsigned char[width * height * kBytesPerPixel]);
  CGRect testImageBounds = CGRectMake(0, 0, width, height);
  CGRect innerBounds = CGRectInset(testImageBounds, 2, 2);
  CGRect innerColorBounds = CGRectInset(innerBounds, 4, 4);
  [GTXUITestUtils fillRect:testImageBounds
                 withColor:backgroundColor
                  inBuffer:pixels.get()
                    ofSize:testImageBounds.size];
  [GTXUITestUtils fillRect:innerColorBounds
                 withColor:innerColor
                  inBuffer:pixels.get()
                    ofSize:testImageBounds.size];

  gtx::Image image = gtx::Image((gtx::Pixel *)pixels.get(), width, height);
  gtx::Rect rect(innerBounds.origin.x, innerBounds.origin.y,
                 innerBounds.size.width, innerBounds.size.height);
  gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(image, rect);

  std::unique_ptr<gtx::Color> expected_background = [backgroundColor gtx_color];
  XCTAssertTrue(*expected_background == swatch.background());
  std::unique_ptr<gtx::Color> expected_foreground = [innerColor gtx_color];
  XCTAssertTrue(*expected_foreground == swatch.foreground());
}

- (void)testContrastSwatchWithTwoProminentColorsInUIImage {
  UIColor *backgroundColor = [UIColor whiteColor];
  UIColor *foregroundColor = [UIColor yellowColor];

  CGRect testImageBounds = CGRectMake(0, 0, 10, 10);
  UIGraphicsBeginImageContextWithOptions(testImageBounds.size, YES, 1.0);
  [backgroundColor setFill];
  [[UIBezierPath bezierPathWithRect:testImageBounds] fill];
  [foregroundColor setFill];
  [[UIBezierPath bezierPathWithRect:CGRectMake(2, 2, 4, 4)] fill];
  UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  std::unique_ptr<gtx::Image> image =
      [[[GTXImageRGBAData alloc] initWithUIImage:testImage] gtxImage];
  gtx::Rect rect(0, 0, testImageBounds.size.width, testImageBounds.size.height);
  gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(*image, rect);

  std::unique_ptr<gtx::Color> expected_background = [backgroundColor gtx_color];
  XCTAssertTrue(*expected_background == swatch.background());
  std::unique_ptr<gtx::Color> expected_foreground = [foregroundColor gtx_color];
  XCTAssertTrue(*expected_foreground == swatch.foreground());
}

- (void)testContrastSwatchWithSmallerBounds {
  UIColor *backgroundColor = [UIColor whiteColor];
  UIColor *innerColor = [UIColor yellowColor];

  CGRect testImageBounds = CGRectMake(0, 0, 20, 20);
  CGRect innerBounds = CGRectInset(testImageBounds, 2, 2);
  CGRect innerColorBounds = CGRectInset(innerBounds, 2, 2);
  UIGraphicsBeginImageContextWithOptions(testImageBounds.size, YES, 1.0);
  [backgroundColor setFill];
  [[UIBezierPath bezierPathWithRect:testImageBounds] fill];
  [innerColor setFill];
  [[UIBezierPath bezierPathWithRect:innerColorBounds] fill];
  UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  std::unique_ptr<gtx::Image> image =
      [[[GTXImageRGBAData alloc] initWithUIImage:testImage] gtxImage];
  gtx::Rect rect(innerBounds.origin.x, innerBounds.origin.y,
                 innerBounds.size.width, innerBounds.size.height);
  gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(*image, rect);

  std::unique_ptr<gtx::Color> expected_color = [innerColor gtx_color];
  XCTAssertTrue(*expected_color == swatch.background());
  // Foreground color may not match expected_color possibly due to artifacts due to conversion
  // from UIImage objects.
}

- (void)testContrastSwatchWithImageContainingText {
  UIColor *backgroundColor = [UIColor whiteColor];
  UIColor *textColor = [UIColor blackColor];

  CGRect testImageBounds = CGRectMake(0, 0, 100, 100);
  UIGraphicsBeginImageContextWithOptions(testImageBounds.size, YES, 1.0);
  [backgroundColor setFill];
  [[UIBezierPath bezierPathWithRect:testImageBounds] fill];
  [@"Foo" drawAtPoint:CGPointMake(0, 0)
       withAttributes:@{NSForegroundColorAttributeName: textColor,
                        NSFontAttributeName: [UIFont systemFontOfSize:50]}];
  UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  std::unique_ptr<gtx::Image> image =
      [[[GTXImageRGBAData alloc] initWithUIImage:testImage] gtxImage];
  gtx::Rect rect(0, 0, testImageBounds.size.width, testImageBounds.size.height);
  gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(*image, rect);

  std::unique_ptr<gtx::Color> expected_background = [backgroundColor gtx_color];
  XCTAssertTrue(*expected_background == swatch.background());
  std::unique_ptr<gtx::Color> expected_foreground = [textColor gtx_color];
  XCTAssertTrue(*expected_foreground == swatch.foreground());
}

@end
