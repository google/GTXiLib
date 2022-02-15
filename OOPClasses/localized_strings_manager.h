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

#ifndef GTXILIB_OOPCLASSES_LOCALIZED_STRINGS_H_
#define GTXILIB_OOPCLASSES_LOCALIZED_STRINGS_H_

#include <memory>
#include <string>

#include <abseil/absl/container/flat_hash_map.h>
#include "gtx_types.h"
#include "locales.h"
#include "localized_string_ids.h"

namespace gtx {

// Default locales loaded when no locales are explicitly specified.
const std::array<Locale, 12> kDefaultLocales = {
    kLocaleChineseChina,
    kLocaleChineseTaiwan,
    kLocaleEnglish,
    kLocaleEnglishGreatBritain,
    kLocaleEnglishUnitedStates,
    kLocaleFrench,
    kLocaleGerman,
    kLocaleItalian,
    kLocaleJapanese,
    kLocaleKorean,
    kLocalePortugueseBrazil,
    kLocaleSpanish,
};

// A map from the name of a localized string to the localized string.
using LocalizedStringMap = absl::flat_hash_map<std::string, std::string>;

// A collection of localized strings.
class LocalizedStringsManager {
 public:
  explicit LocalizedStringsManager(
      absl::flat_hash_map<Locale, LocalizedStringMap> strings_by_locale);

  LocalizedStringsManager(const LocalizedStringsManager &that) = default;
  LocalizedStringsManager(LocalizedStringsManager &&that) = default;
  LocalizedStringsManager &operator=(const LocalizedStringsManager &that) =
      default;
  LocalizedStringsManager &operator=(LocalizedStringsManager &&that) = default;

  // Constructs a `LocalizedStringsManager` with the default locales by loading
  // files in directories in `directory`. Each file must be named "strings.xml"
  // in a directory named "Strings-$LOCALE".
  static std::unique_ptr<LocalizedStringsManager>
  LocalizedStringsManagerWithDefaultLocalesInDirectory(
      absl::string_view directory);

  // Constructs a `LocalizedStringsManager` with the given locales by loading
  // files in directories in `directory`. Each file must be named "strings.xml"
  // in a directory named "Strings-$LOCALE".
  static std::unique_ptr<LocalizedStringsManager>
  LocalizedStringsManagerWithLocalesInDirectory(
      const std::vector<Locale> locales, absl::string_view directory);

  // Returns localized string for the given locale from the provided localized
  // stringID.
  std::string LocalizedString(Locale locale, LocalizedStringID stringID) const;

 private:
  // Remove escape sequences from strings so they are human readable.
  std::string EscapeString(absl::string_view string) const;

  // Returns the localized strings map for the given locale. Defaults to English
  // if the map cannot be loaded.
  const LocalizedStringMap &LocalizedStringsForLocale(Locale locale) const;

  absl::flat_hash_map<Locale, LocalizedStringMap> localized_strings_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_LOCALIZED_STRINGS_H_
