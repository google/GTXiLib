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

#include <map>
#include <string>

#include "gtx_types.h"

namespace gtx {

// List of IDs for localized strings available to GTXiLib.
enum class LocalizedStringID {
  // String representing an empty string.
  kEmptyString,
};

// A collection of localized strings.
class LocalizedStringsManager {
 public:
  LocalizedStringsManager();

  // Returns localized string from the provided localized stringID.
  const std::string &LocalizedString(LocalizedStringID stringID);

 private:
  std::map<LocalizedStringID, std::string> localized_strings_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_LOCALIZED_STRINGS_H_
