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

#include "check.h"

#import <XCTest/XCTest.h>

#include <abseil/absl/strings/str_cat.h>
#import "GTXLocalizedStringsManagerUtils.h"
#include "metadata_map.h"
#include "localized_strings_manager.h"
#include "gtxtest_always_failing_check.h"
#import "GTXObjCPPTestUtils.h"

@interface GTXCheckTests : XCTestCase
@end

@implementation GTXCheckTests

- (void)testGetMessageWithNoMessageProvidersReturnsDefaultMessage {
  gtxtest::GTXTestAlwaysFailingCheck check =
      gtxtest::GTXTestAlwaysFailingCheck("check_with_empty_message");
  gtx::MetadataMap metadata;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  std::string richMessage = check.GetRichMessage(
      gtx::kLocaleEnglish, gtxtest::GTXTestAlwaysFailingCheck::RESULT_ID_FAILURE, metadata,
      *stringsManager);
  [GTXObjCPPTestUtils assertString:richMessage equalsString:""];
}

- (void)testGetMessageWithOneProviderReturnsUpdatedMessage {
  gtxtest::GTXTestAlwaysFailingCheck check =
      gtxtest::GTXTestAlwaysFailingCheck("check_with_empty_message");
  gtx::MetadataMap metadata;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  gtx::MessageProvider replacingMessageProvider =
      [](std::string oldMessage, gtx::Locale locale, int resultId, const gtx::MetadataMap &metadata,
         const gtx::LocalizedStringsManager &stringsManager) { return "replaced message"; };

  check.RegisterMessageProvider(replacingMessageProvider);

  std::string richMessage = check.GetRichMessage(
      gtx::kLocaleEnglish, gtxtest::GTXTestAlwaysFailingCheck::RESULT_ID_FAILURE, metadata,
      *stringsManager);
  [GTXObjCPPTestUtils assertString:richMessage equalsString:"replaced message"];
}

- (void)testGetMessageWithOneProviderReturnsAppendedMessage {
  gtxtest::GTXTestAlwaysFailingCheck check =
      gtxtest::GTXTestAlwaysFailingCheck("check_with_empty_message");
  gtx::MetadataMap metadata;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  gtx::MessageProvider appendingMessageProvider =
      [](std::string oldMessage, gtx::Locale locale, int resultId, const gtx::MetadataMap &metadata,
         const gtx::LocalizedStringsManager &stringsManager) {
        return absl::StrCat(oldMessage, " appended message");
      };

  check.RegisterMessageProvider(appendingMessageProvider);

  std::string richMessage = check.GetRichMessage(
      gtx::kLocaleEnglish, gtxtest::GTXTestAlwaysFailingCheck::RESULT_ID_FAILURE, metadata,
      *stringsManager);
  [GTXObjCPPTestUtils assertString:richMessage equalsString:" appended message"];
}

- (void)testGetMessageWithReplacingThenAppendingProvidersReturnsBothMessages {
  gtxtest::GTXTestAlwaysFailingCheck check =
      gtxtest::GTXTestAlwaysFailingCheck("check_with_empty_message");
  gtx::MetadataMap metadata;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  gtx::MessageProvider replacingMessageProvider =
      [](std::string oldMessage, gtx::Locale locale, int resultId, const gtx::MetadataMap &metadata,
         const gtx::LocalizedStringsManager &stringsManager) { return "replaced message"; };
  gtx::MessageProvider appendingMessageProvider =
      [](std::string oldMessage, gtx::Locale locale, int resultId, const gtx::MetadataMap &metadata,
         const gtx::LocalizedStringsManager &stringsManager) {
        return absl::StrCat(oldMessage, " appended message");
      };

  check.RegisterMessageProvider(replacingMessageProvider);
  check.RegisterMessageProvider(appendingMessageProvider);

  std::string richMessage = check.GetRichMessage(
      gtx::kLocaleEnglish, gtxtest::GTXTestAlwaysFailingCheck::RESULT_ID_FAILURE, metadata,
      *stringsManager);
  [GTXObjCPPTestUtils assertString:richMessage equalsString:"replaced message appended message"];
}

- (void)testGetMessageWithAppendingThenReplacingProvidersReturnsReplacingMessage {
  gtxtest::GTXTestAlwaysFailingCheck check =
      gtxtest::GTXTestAlwaysFailingCheck("check_with_empty_message");
  gtx::MetadataMap metadata;
  std::unique_ptr<gtx::LocalizedStringsManager> stringsManager =
      [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];

  gtx::MessageProvider replacingMessageProvider =
      [](std::string oldMessage, gtx::Locale locale, int resultId, const gtx::MetadataMap &metadata,
         const gtx::LocalizedStringsManager &stringsManager) { return "replaced message"; };
  gtx::MessageProvider appendingMessageProvider =
      [](std::string oldMessage, gtx::Locale locale, int resultId, const gtx::MetadataMap &metadata,
         const gtx::LocalizedStringsManager &stringsManager) {
        return absl::StrCat(oldMessage, " appended message");
      };

  check.RegisterMessageProvider(appendingMessageProvider);
  check.RegisterMessageProvider(replacingMessageProvider);

  std::string richMessage = check.GetRichMessage(
      gtx::kLocaleEnglish, gtxtest::GTXTestAlwaysFailingCheck::RESULT_ID_FAILURE, metadata,
      *stringsManager);
  [GTXObjCPPTestUtils assertString:richMessage equalsString:"replaced message"];
}

@end
