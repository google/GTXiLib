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

#include "localized_strings_manager.h"

#include <memory>
#include <string>

#include <abseil/absl/container/flat_hash_map.h>
#include <abseil/absl/strings/str_replace.h>
#include <abseil/absl/types/optional.h>
#include "localized_string_ids.h"
#include "xml_utils.h"
#include "tinyxml2.h"

namespace gtx {

namespace {

// Loads the strings in `strings_file_name`. The file must be in XML format.
// Returns an empty map if strings could not be loaded.
absl::optional<LocalizedStringMap> LoadStringsInXMLFile(
    const std::string &strings_file_name) {
  absl::flat_hash_map<std::string, std::string> strings;
  // Use a std::string instead of absl::string_view because it needs to be
  // converted to a C-string. Using an absl::string_view would require
  // constructing an std::string anyways.
  tinyxml2::XMLDocument strings_file;
  tinyxml2::XMLError err = strings_file.LoadFile(strings_file_name.c_str());
  if (err != tinyxml2::XMLError::XML_SUCCESS) {
    return absl::nullopt;
  }
  tinyxml2::XMLElement *current_tag =
      strings_file.RootElement()->FirstChildElement("string");
  while (current_tag != nullptr) {
    // The XML Document owns the returned string. Do not delete it.
    const char *name = current_tag->Attribute("name");
    std::string text;
    RecursivelyAppendTextFromXMLNode(text, current_tag);
    strings.insert(std::make_pair(name, text));
    current_tag = current_tag->NextSiblingElement();
  }
  return strings;
}

}  // namespace

LocalizedStringsManager::LocalizedStringsManager(
    absl::flat_hash_map<Locale, LocalizedStringMap> strings_by_locale)
    : localized_strings_(strings_by_locale) {}

std::unique_ptr<LocalizedStringsManager>
LocalizedStringsManager::LocalizedStringsManagerWithDefaultLocalesInDirectory(
    absl::string_view directory) {
  std::vector<Locale> locales(kDefaultLocales.begin(), kDefaultLocales.end());
  return LocalizedStringsManagerWithLocalesInDirectory(locales, directory);
}

std::unique_ptr<LocalizedStringsManager>
LocalizedStringsManager::LocalizedStringsManagerWithLocalesInDirectory(
    const std::vector<Locale> locales, absl::string_view directory) {
  std::string empty_key(kLocalizedStringIDEmptyString);
  absl::flat_hash_map<Locale, LocalizedStringMap> strings_by_locale;
  for (const Locale &locale : locales) {
    std::string strings_file =
        absl::StrCat(directory, "/Strings-", locale, "/strings.xml");
    absl::optional<LocalizedStringMap> strings =
        LoadStringsInXMLFile(strings_file);
    if (!strings.has_value()) {
      continue;
    }
    strings->insert(std::make_pair(empty_key, ""));
    strings_by_locale.insert({locale, *strings});
  }
  return std::make_unique<LocalizedStringsManager>(strings_by_locale);
}

const LocalizedStringMap &LocalizedStringsManager::LocalizedStringsForLocale(
    Locale locale) const {
  auto localized_strings_iter = localized_strings_.find(locale);
  if (localized_strings_iter != localized_strings_.end()) {
    return localized_strings_iter->second;
  }
  // English is guaranteed to exist.
  return localized_strings_.at(kLocaleEnglish);
}

std::string LocalizedStringsManager::LocalizedString(
    Locale locale, LocalizedStringID stringID) const {
  auto localized_strings = LocalizedStringsForLocale(locale);
  auto string_iter = localized_strings.find(stringID);
  if (string_iter != localized_strings.end()) {
    return EscapeString(string_iter->second);
  } else {
    // kEmptyString is guaranteed to be set.
    return localized_strings.at(kLocalizedStringIDEmptyString);
  }
}

std::string LocalizedStringsManager::EscapeString(
    absl::string_view string) const {
  // User visible strings should not contain escape characters. Translated
  // strings automatically escape single quotes and there is no way around this.
  // Unescape them at runtime so the user visible string does not contain a
  // backslash. Single quotes are currently the only character that need to be
  // escaped. Double quotes and literal backslashes do not appear.
  return absl::StrReplaceAll(std::string(string), {{"\\'", "'"}});
}

}  // namespace gtx
