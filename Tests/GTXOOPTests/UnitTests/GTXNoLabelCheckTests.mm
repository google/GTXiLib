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

#include "no_label_check.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/types/optional.h>
#import "GTXLocalizedStringsManagerUtils.h"
#import "GTXObjCPPTestUtils.h"

@interface GTXNoLabelCheckTests : XCTestCase {
  /**
   * The check under test.
   */
  std::unique_ptr<gtx::NoLabelCheck> _check;

  /**
   * Dummy parameters to pass to CheckElement.
   */
  gtx::Parameters _parameters;
}

@end

@implementation GTXNoLabelCheckTests

- (void)setUp {
  [super setUp];
  _check = std::make_unique<gtx::NoLabelCheck>();
}

- (void)testCategoryReturnsCorrectValue {
  XCTAssertEqual(_check->Category(), gtx::CheckCategory::kAccessibilityLabel);
}

- (void)testElementWithoutLabelFailsCheck {
  UIElementProto element;

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertNotEqual(result, absl::nullopt);
  XCTAssertEqual(result->result_id(), gtx::NoLabelCheck::RESULT_ID_MISSING_ACCESSIBILITY_LABEL);
}

- (void)testElementWithLabelPassesCheck {
  UIElementProto element;
  element.set_ax_label("Ax Label");

  absl::optional<CheckResultProto> result = _check->CheckElement(element, _parameters);

  XCTAssertEqual(result, absl::nullopt);
}

- (void)testGetRichMessageFormatsMessageWithEmptyMetadata {
  gtx::NoLabelCheck check;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];
  gtx::MetadataMap metadata;
  int resultId = gtx::NoLabelCheck::RESULT_ID_MISSING_ACCESSIBILITY_LABEL;

  std::string message =
      check.GetRichMessage(gtx::kLocaleEnglish, resultId, metadata, *stringsManager);

  [GTXObjCPPTestUtils
      assertString:message
      equalsString:"This element may not have an accessibility label readable by "
                   "VoiceOver. All accessibility elements should have accessibility "
                   "labels."];
}

- (void)testGetPlainMessageFormatsMessageWithEmptyMetadata {
  gtx::NoLabelCheck check;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];
  gtx::MetadataMap metadata;
  int resultId = gtx::NoLabelCheck::RESULT_ID_MISSING_ACCESSIBILITY_LABEL;

  std::string message =
      check.GetPlainMessage(gtx::kLocaleEnglish, resultId, metadata, *stringsManager);

  [GTXObjCPPTestUtils
      assertString:message
      equalsString:"This element may not have an accessibility label readable by "
                   "VoiceOver. All accessibility elements should have accessibility "
                   "labels."];
}

// TODO: Add tests for non accessibility elements when an accurate way to determine
// isAccessibilityElement is found.

@end
