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

#include "check.h"

#include <iostream>
#include <string>
#include <utility>
#include <vector>

#include <abseil/absl/types/optional.h>
#include "metadata_map.h"
#include "result.pb.h"
#include "typedefs.h"
#include "localized_strings_manager.h"
#include "xml_utils.h"
#include "tinyxml2.h"

namespace gtx {

namespace {

// Removes all tags from `string`, returning the plaintext within the tags.
// Nested tags are also removed. Returns `absl::nullopt` if the tags in `string`
// could not be parsed.
absl::optional<std::string> RemoveFormatting(absl::string_view string) {
  tinyxml2::XMLDocument parsed_string;
  // Strings without tags are malformatted XML, which tinyxml2 returns an error
  // instead of parsing. Wrapping the string in dummy tags lets tinyxml2 parse
  // it correctly.
  std::string xml_string = absl::StrCat("<s>", string, "</s>");
  tinyxml2::XMLError err = parsed_string.Parse(xml_string.data());
  if (err != tinyxml2::XMLError::XML_SUCCESS) {
    return absl::nullopt;
  }
  tinyxml2::XMLElement *root_tag = parsed_string.RootElement();
  std::string text;
  RecursivelyAppendTextFromXMLNode(text, root_tag);
  return text;
}
}  // namespace

CheckResultProto Check::CheckResult(int result_id,
                                    const UIElementProto &element,
                                    const MetadataMap &metadata) const {
  CheckResultProto check_result;
  check_result.set_source_check_class(name());
  check_result.set_hierarchy_source_id(element.id());
  check_result.set_result_id(result_id);
  check_result.set_result_type(
      gtxilib::oopclasses::protos::RESULT_TYPE_ERROR);
  *check_result.mutable_metadata() = metadata.ToProto();
  return check_result;
}

std::string Check::GetRichMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string message =
      GetDefaultMessage(locale, result_id, metadata, string_manager);
  for (const MessageProvider &message_provider : message_providers_) {
    message = message_provider(std::move(message), locale, result_id, metadata,
                               string_manager);
  }
  return message;
}

// Returns a human readable description of a check result produced by this
// check with the given result_id and metadata in the given locale.
std::string Check::GetPlainMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string rich_message =
      GetRichMessage(locale, result_id, metadata, string_manager);
  absl::optional<std::string> plain_message = RemoveFormatting(rich_message);
  return plain_message.has_value() ? *plain_message : rich_message;
}

std::string Check::GetPlainShortMessage(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string rich_short_message =
      GetRichShortMessage(locale, result_id, metadata, string_manager);
  absl::optional<std::string> plain_short_message =
      RemoveFormatting(rich_short_message);
  return plain_short_message.has_value() ? *plain_short_message
                                         : rich_short_message;
}

// Returns the title of a check result produced by this check with the given
// result_id and metadata in the given locale.
std::string Check::GetPlainTitle(
    Locale locale, int result_id, const MetadataMap &metadata,
    const LocalizedStringsManager &string_manager) const {
  std::string rich_title =
      GetRichTitle(locale, result_id, metadata, string_manager);
  absl::optional<std::string> plain_title = RemoveFormatting(rich_title);
  return plain_title.has_value() ? *plain_title : rich_title;
}

void Check::RegisterMessageProvider(MessageProvider provider) {
  message_providers_.push_back(provider);
}

}  // namespace gtx
