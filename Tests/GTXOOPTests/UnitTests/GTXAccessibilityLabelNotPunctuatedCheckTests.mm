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

#include "accessibility_label_not_punctuated_check.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/types/optional.h>
#import "GTXLocalizedStringsManagerUtils.h"
#import "NSString+GTXAdditions.h"
#include "element_trait.h"
#import "GTXObjCPPTestUtils.h"

@interface GTXAccessibilityLabelNotPunctuatedCheckTests : XCTestCase {
  /**
   * The check under test.
   */
  std::unique_ptr<gtx::AccessibilityLabelNotPunctuatedCheck> _check;

  /**
   * Dummy parameters to pass to CheckElement.
   */
  gtx::Parameters _parameters;
}
@end

@implementation GTXAccessibilityLabelNotPunctuatedCheckTests

- (void)setUp {
  [super setUp];
  _check = std::make_unique<gtx::AccessibilityLabelNotPunctuatedCheck>();
}

- (void)testCategoryReturnsCorrectValue {
  XCTAssertEqual(_check->Category(), gtx::CheckCategory::kAccessibilityLabel);
}

- (void)testNonPunctuatedAccessibilityLabelPasses {
  UIElementProto element;
  element.set_ax_label("accessibility label without punctuation");

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertEqual(result, absl::nullopt);
}

- (void)testPunctuatedAccessibilityLabelFails {
  UIElementProto element;
  element.set_ax_label("accessibility label with punctuation.");

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertNotEqual(result, absl::nullopt);
  XCTAssertEqual(
      result->result_id(),
      gtx::AccessibilityLabelNotPunctuatedCheck::RESULT_ID_ENDS_WITH_INVALID_PUNCTUATION);
  [self gtxtest_assertMetadataContainsExpectedKeys:result->metadata()];
}

- (void)testPunctuatedStaticTextAccessibilityLabelPasses {
  UIElementProto element;
  element.set_ax_traits(static_cast<uint64_t>(gtx::ElementTrait::kStaticText));
  element.set_ax_label("accessibility label with punctuation.");
  gtx::ErrorMessage error_message;

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertEqual(result, absl::nullopt);
}

- (void)testGetRichMessageFormatsMessageWithMetadata {
  gtx::MetadataMap metadata;
  metadata.SetString(gtx::AccessibilityLabelNotPunctuatedCheck::KEY_ACCESSIBILITY_LABEL,
                     "accessibility label with punctuation.");
  int result_id =
      gtx::AccessibilityLabelNotPunctuatedCheck::RESULT_ID_ENDS_WITH_INVALID_PUNCTUATION;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string message =
      _check->GetRichMessage(gtx::kLocaleEnglish, result_id, metadata, *stringsManager);

  // Assert that the message was constructed successfully without crashing.
  std::string expected =
      "This element may have an accessibility label that ends in punctuation but doesn't have a "
      "text trait. If this element visually displays text, consider adding the "
      "<tt>UIAccessibilityStaticTrait</tt>, similar to <tt>UITextView</tt> or <tt>UILabel</tt>. If "
      "the element does not display text, consider removing the punctuation. Label found: "
      "<tt>accessibility label with punctuation.</tt>";
  XCTAssertEqual(message, expected);
}

- (void)testGetPlainMessageFormatsMessageWithMetadata {
  gtx::MetadataMap metadata;
  metadata.SetString(gtx::AccessibilityLabelNotPunctuatedCheck::KEY_ACCESSIBILITY_LABEL,
                     "accessibility label with punctuation.");
  int result_id =
      gtx::AccessibilityLabelNotPunctuatedCheck::RESULT_ID_ENDS_WITH_INVALID_PUNCTUATION;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string message =
      _check->GetPlainMessage(gtx::kLocaleEnglish, result_id, metadata, *stringsManager);

  // Assert that the message was constructed without tags.
  std::string expected =
      "This element may have an accessibility label that ends in punctuation but doesn't have a "
      "text trait. If this element visually displays text, consider adding the "
      "UIAccessibilityStaticTrait, similar to UITextView or UILabel. If "
      "the element does not display text, consider removing the punctuation. Label found: "
      "accessibility label with punctuation.";
  XCTAssertEqual(message, expected);
}

#pragma mark - Private Methods

/**
 * Asserts that the map contained by @c metadata contains the expected keys populated by
 * @c AccessibilityLabelNotPunctuatedCheck. Fails the test if false.
 */
- (void)gtxtest_assertMetadataContainsExpectedKeys:(const MetadataProto &)metadata {
  std::vector<std::string> expectedKeys(
      {gtx::AccessibilityLabelNotPunctuatedCheck::KEY_ACCESSIBILITY_LABEL});
  XCTAssert([GTXObjCPPTestUtils metadata:metadata contains:expectedKeys]);
}

@end
