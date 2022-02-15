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

#include "error_message.h"

#include <map>
#include <string>

#include "localized_strings_manager.h"

namespace gtx {

typedef std::pair<LocalizedStringID, std::string> ErrorMessageDetailPair;

ErrorMessage::ErrorMessage() {}

void ErrorMessage::AddDetail(LocalizedStringID detail_id,
                             const std::string &detail_value) {
  details_.insert(ErrorMessageDetailPair(detail_id, detail_value));
}

}  // namespace gtx
