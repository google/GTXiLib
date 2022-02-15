//
// Copyright 2021 Google Inc.
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

#include "contrast_check.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/types/optional.h>
#import "GTXLocalizedStringsManagerUtils.h"
#include "GTXProtoUtils.h"
#import "NSString+GTXAdditions.h"
#include "element_trait.h"
#include "gtx_types.h"
#import "GTXUITestUtils.h"
#import "GTXObjCPPTestUtils.h"

/**
 * The size of one of the dimensions of test images used in contrast check tests.
 */
static const int kGTXTestImageSize = 3;

/**
 * The accessibility frame of UI elements such that they correspond to the correct region of the
 * screenshot.
 */
static const CGRect kGTXAccessibilityFrame = CGRectMake(0, 0, kGTXTestImageSize, kGTXTestImageSize);

/**
 * The frame of the virtual device screenshots are captured from.
 */
static const gtx::Rect kGTXTestDeviceBounds = {0, 0, kGTXTestImageSize, kGTXTestImageSize};

@interface GTXContrastCheckTests : XCTestCase {
  /**
   * The check under test.
   */
  std::unique_ptr<gtx::ContrastCheck> _check;
}
@end

@implementation GTXContrastCheckTests

- (void)setUp {
  [super setUp];
  _check = std::make_unique<gtx::ContrastCheck>();
}

- (void)testCategoryReturnsCorrectValue {
  XCTAssertEqual(_check->Category(), gtx::CheckCategory::kLowContrast);
}

- (void)testHighContrastImagePassesCheck {
  std::vector<gtx::Pixel> pixels = [self gtxtest_pixelsWithForegroundColor:[UIColor blackColor]
                                                           backgroundColor:[UIColor whiteColor]];
  gtx::Image image;
  image.pixels = pixels.data();
  image.width = kGTXTestImageSize;
  image.height = kGTXTestImageSize;
  gtx::Parameters parameters;
  parameters.set_screenshot(image);
  parameters.set_device_bounds(kGTXTestDeviceBounds);
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kStaticText));
  *element.mutable_ax_frame() = [GTXProtoUtils protoFromCGRect:kGTXAccessibilityFrame];

  absl::optional<CheckResultProto> result = _check->CheckElement(element, parameters);
  XCTAssertEqual(result, absl::nullopt);
}

- (void)testLowContrastImagePassesCheck {
  UIColor *almostBlack = [UIColor colorWithWhite:0.1 alpha:1.0];
  std::vector<gtx::Pixel> pixels = [self gtxtest_pixelsWithForegroundColor:[UIColor blackColor]
                                                           backgroundColor:almostBlack];
  gtx::Image image;
  image.pixels = pixels.data();
  image.width = kGTXTestImageSize;
  image.height = kGTXTestImageSize;
  gtx::Parameters parameters;
  parameters.set_screenshot(image);
  parameters.set_device_bounds(kGTXTestDeviceBounds);
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kStaticText));
  *element.mutable_ax_frame() = [GTXProtoUtils protoFromCGRect:kGTXAccessibilityFrame];

  absl::optional<CheckResultProto> result = _check->CheckElement(element, parameters);
  XCTAssertNotEqual(result, absl::nullopt);
  XCTAssertEqual(result->result_id(), gtx::ContrastCheck::RESULT_ID_INSUFFICIENT_CONTRAST_RATIO);
  std::vector<std::string> expectedKeys = {
      gtx::ContrastCheck::KEY_EXPECTED_CONTRAST_RATIO,
      gtx::ContrastCheck::KEY_ACTUAL_CONTRAST_RATIO,
      gtx::ContrastCheck::KEY_FOREGROUND_COLOR,
      gtx::ContrastCheck::KEY_BACKGROUND_COLOR,
  };
  XCTAssert([GTXObjCPPTestUtils metadata:result->metadata() contains:expectedKeys]);
}

- (void)testGetRichMessageFormatsMessageWithMetadata {
  gtx::MetadataMap metadata;
  metadata.SetFloat(gtx::ContrastCheck::KEY_EXPECTED_CONTRAST_RATIO, 7.0);
  metadata.SetFloat(gtx::ContrastCheck::KEY_ACTUAL_CONTRAST_RATIO, 2.0);
  metadata.SetString(gtx::ContrastCheck::KEY_FOREGROUND_COLOR, "(0.0, 0.0, 0.0, 0.0)");
  metadata.SetString(gtx::ContrastCheck::KEY_BACKGROUND_COLOR, "(0.1, 0.1, 0.1, 1.0)");
  int result_id = gtx::ContrastCheck::RESULT_ID_INSUFFICIENT_CONTRAST_RATIO;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string message =
      _check->GetRichMessage(gtx::kLocaleEnglish, result_id, metadata, *stringsManager);

  // Assert that the message was constructed successfully without crashing.
  std::string expected =
      "The element's text contrast ratio is 2. This ratio is based on a text "
      "color of <tt>(0.0, 0.0, 0.0, 0.0)</tt> and background color of <tt>(0.1, 0.1, 0.1, "
      "1.0)</tt>. Consider increasing this element's text contrast ratio to 7 or greater.";
  XCTAssertEqual(message, expected);
}

- (void)testGetPlainMessageFormatsMessageWithMetadata {
  gtx::MetadataMap metadata;
  metadata.SetFloat(gtx::ContrastCheck::KEY_EXPECTED_CONTRAST_RATIO, 7.0);
  metadata.SetFloat(gtx::ContrastCheck::KEY_ACTUAL_CONTRAST_RATIO, 2.0);
  metadata.SetString(gtx::ContrastCheck::KEY_FOREGROUND_COLOR, "(0.0, 0.0, 0.0, 0.0)");
  metadata.SetString(gtx::ContrastCheck::KEY_BACKGROUND_COLOR, "(0.1, 0.1, 0.1, 1.0)");
  int result_id = gtx::ContrastCheck::RESULT_ID_INSUFFICIENT_CONTRAST_RATIO;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string message =
      _check->GetPlainMessage(gtx::kLocaleEnglish, result_id, metadata, *stringsManager);

  // Assert that the message was constructed successfully without tags.
  std::string expected =
      "The element's text contrast ratio is 2. This ratio is based on a text "
      "color of (0.0, 0.0, 0.0, 0.0) and background color of (0.1, 0.1, 0.1, "
      "1.0). Consider increasing this element's text contrast ratio to 7 or greater.";
  XCTAssertEqual(message, expected);
}

#pragma mark - Private Methods

/**
 * Constructs a 2d array of pixels containing only foreground and background colors. More pixels are
 * @c backgroundColor than @c foregroundColor so it is unambiguous which is which.
 * @param foregroundColor The foreground color. Less pixels of this color exist.
 * @param backgroundColor The background color. More pixels of this color exist.
 * @return An array of pixels containing @c foregroundColor and @c backgroundColor.
 */
- (std::vector<gtx::Pixel>)gtxtest_pixelsWithForegroundColor:(UIColor *)foregroundColor
                                             backgroundColor:(UIColor *)backgroundColor {
  CGSize pixelSize = CGSizeMake(kGTXTestImageSize, kGTXTestImageSize);
  std::vector<gtx::Pixel> pixels(kGTXTestImageSize * kGTXTestImageSize);
  // A gtx::Color is just 4 bytes, one for each color component. It is safe to cast it to an array
  // of uint8_t.
  [GTXUITestUtils fillRect:CGRectMake(0, 0, kGTXTestImageSize, 1)
                 withColor:foregroundColor
                  inBuffer:(uint8_t *)(pixels.data())ofSize:pixelSize];
  [GTXUITestUtils fillRect:CGRectMake(0, 1, kGTXTestImageSize, kGTXTestImageSize - 1)
                 withColor:backgroundColor
                  inBuffer:(uint8_t *)(pixels.data())ofSize:pixelSize];
  return pixels;
}

@end
