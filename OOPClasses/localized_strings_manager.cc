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

#include <string>

namespace gtx {

typedef std::pair<LocalizedStringID, std::string> LocalizedStringPair;

LocalizedStringsManager::LocalizedStringsManager() : localized_strings_() {
  localized_strings_.insert(
      LocalizedStringPair(LocalizedStringID::kEmptyString, ""));
}

const std::string &LocalizedStringsManager::LocalizedString(
    LocalizedStringID stringID) {
  auto string_iter = localized_strings_.find(stringID);
  if (string_iter != localized_strings_.end()) {
    return string_iter->second;
  } else {
    return localized_strings_[LocalizedStringID::kEmptyString];
  }
}

}  // namespace gtx
