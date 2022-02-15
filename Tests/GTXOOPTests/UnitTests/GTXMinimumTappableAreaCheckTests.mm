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

#include "minimum_tappable_area_check.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/types/optional.h>
#import "GTXLocalizedStringsManagerUtils.h"
#include "GTXProtoUtils.h"
#include "element_trait.h"
#import "GTXObjCPPTestUtils.h"

/**
 * A dimension which is large enough to pass the touch target size check.
 */
static const CGFloat kGTXSufficientSize = 64.0;

/**
 * A dimension which is too small to pass the touch target size check.
 */
static const CGFloat kGTXInsufficientSize = 16.0;

/**
 * A dimension which is exactly large enough to pass the touch target size check.
 */
static const CGFloat kGTXExactlySufficientSize = 44.0;

@interface GTXMinimumTappableAreaCheckTests : XCTestCase {
  /**
   * The check under test.
   */
  std::unique_ptr<gtx::MinimumTappableAreaCheck> _check;

  /**
   * Dummy parameters to pass to CheckElement.
   */
  gtx::Parameters _parameters;
}
@end

@implementation GTXMinimumTappableAreaCheckTests

- (void)setUp {
  [super setUp];
  _check = std::make_unique<gtx::MinimumTappableAreaCheck>();
}

- (void)testCategoryReturnsCorrectValue {
  XCTAssertEqual(_check->Category(), gtx::CheckCategory::kTouchTargetSize);
}

- (void)testElementWithSufficientWidthAndHeightPassesCheck {
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kButton));
  *element.mutable_ax_frame() =
      [GTXProtoUtils protoFromCGRect:CGRectMake(0, 0, kGTXSufficientSize, kGTXSufficientSize)];

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertEqual(result, absl::nullopt);
}

- (void)testElementWithSufficientWidthAndInsufficientHeightFailsCheck {
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kButton));
  *element.mutable_ax_frame() =
      [GTXProtoUtils protoFromCGRect:CGRectMake(0, 0, kGTXSufficientSize, kGTXInsufficientSize)];
  gtx::ErrorMessage error_message;

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertNotEqual(result, absl::nullopt);
  XCTAssertEqual(result->result_id(),
                 gtx::MinimumTappableAreaCheck::RESULT_ID_INSUFFICIENT_TOUCH_TARGET_SIZE);
  [self gtxtest_assertMetadataContainsExpectedKeys:result->metadata()];
}

- (void)testElementWithInsufficientWidthAndSufficientHeightFailsCheck {
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kButton));
  *element.mutable_ax_frame() =
      [GTXProtoUtils protoFromCGRect:CGRectMake(0, 0, kGTXInsufficientSize, kGTXSufficientSize)];
  gtx::ErrorMessage error_message;

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertNotEqual(result, absl::nullopt);
  XCTAssertEqual(result->result_id(),
                 gtx::MinimumTappableAreaCheck::RESULT_ID_INSUFFICIENT_TOUCH_TARGET_SIZE);
  [self gtxtest_assertMetadataContainsExpectedKeys:result->metadata()];
}

- (void)testElementWithInsufficientWidthAndHeightFailsCheck {
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kButton));
  *element.mutable_ax_frame() =
      [GTXProtoUtils protoFromCGRect:CGRectMake(0, 0, kGTXInsufficientSize, kGTXInsufficientSize)];
  gtx::ErrorMessage error_message;

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertNotEqual(result, absl::nullopt);
  XCTAssertEqual(result->result_id(),
                 gtx::MinimumTappableAreaCheck::RESULT_ID_INSUFFICIENT_TOUCH_TARGET_SIZE);
  [self gtxtest_assertMetadataContainsExpectedKeys:result->metadata()];
}

- (void)testElementWithExactlySufficientWidthAndHeightPassesCheck {
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kButton));
  *element.mutable_ax_frame() = [GTXProtoUtils
      protoFromCGRect:CGRectMake(0, 0, kGTXExactlySufficientSize, kGTXExactlySufficientSize)];
  gtx::ErrorMessage error_message;

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertEqual(result, absl::nullopt);
}

- (void)testGetRichMessageFormatsMessageWithMetadata {
  gtx::MetadataMap metadata;
  metadata.SetFloat(gtx::MinimumTappableAreaCheck::KEY_EXPECTED_SIZE, kGTXExactlySufficientSize);
  metadata.SetFloat(gtx::MinimumTappableAreaCheck::KEY_ACTUAL_WIDTH, kGTXInsufficientSize);
  metadata.SetFloat(gtx::MinimumTappableAreaCheck::KEY_ACTUAL_HEIGHT, kGTXExactlySufficientSize);
  int result_id = gtx::MinimumTappableAreaCheck::RESULT_ID_INSUFFICIENT_TOUCH_TARGET_SIZE;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string message =
      _check->GetRichMessage(gtx::kLocaleEnglish, result_id, metadata, *stringsManager);

  // Assert that the message was constructed successfully without crashing.
  std::string expected =
      "This element's size is <tt>16</tt> by <tt>44</tt> points. Consider "
      "making this touch target <tt>44</tt> points wide and <tt>44</tt> points high or larger.";
  XCTAssertEqual(message, expected);
}

- (void)testGetPlainMessageFormatsMessageWithMetadata {
  gtx::MetadataMap metadata;
  metadata.SetFloat(gtx::MinimumTappableAreaCheck::KEY_EXPECTED_SIZE, kGTXExactlySufficientSize);
  metadata.SetFloat(gtx::MinimumTappableAreaCheck::KEY_ACTUAL_WIDTH, kGTXInsufficientSize);
  metadata.SetFloat(gtx::MinimumTappableAreaCheck::KEY_ACTUAL_HEIGHT, kGTXExactlySufficientSize);
  int result_id = gtx::MinimumTappableAreaCheck::RESULT_ID_INSUFFICIENT_TOUCH_TARGET_SIZE;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string message =
      _check->GetPlainMessage(gtx::kLocaleEnglish, result_id, metadata, *stringsManager);

  // Assert that the message was constructed successfully without tags.
  std::string expected = "This element's size is 16 by 44 points. Consider making this touch "
                         "target 44 points wide and 44 points high or larger.";
  XCTAssertEqual(message, expected);
}

#pragma mark - Private Methods

/**
 * Asserts that the map contained by @c metadata contains the expected keys populated by
 * @c MinimumTappableAreaCheck. Fails the test if false.
 */
- (void)gtxtest_assertMetadataContainsExpectedKeys:(const MetadataProto &)metadata {
  std::vector<std::string> expectedKeys({gtx::MinimumTappableAreaCheck::KEY_EXPECTED_SIZE,
                                         gtx::MinimumTappableAreaCheck::KEY_ACTUAL_WIDTH,
                                         gtx::MinimumTappableAreaCheck::KEY_ACTUAL_HEIGHT});
  XCTAssert([GTXObjCPPTestUtils metadata:metadata contains:expectedKeys]);
}

@end
