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

#ifndef GTXILIB_OOPCLASSES_ERROR_MESSAGE_H_
#define GTXILIB_OOPCLASSES_ERROR_MESSAGE_H_

#include <map>
#include <string>

#include "localized_strings_manager.h"

namespace gtx {

// ErrorMessage ecapsulates data associated with the error produced by checking
// a single element against a single check. Data includes a localized error
// description and a set of key value pairs that describe details associated
// with the error.
class ErrorMessage {
 public:
  ErrorMessage();

  const LocalizedStringID description_id() const { return description_id_; }

  void set_description_id(LocalizedStringID description_id) {
    description_id_ = description_id;
  }

  const std::map<LocalizedStringID, std::string> &details() const {
    return details_;
  }

  // Adds the given detail_value under the given detail_id for this error
  // message.
  void AddDetail(LocalizedStringID detail_id, const std::string &detail_value);

 private:
  // Localized string ID of the description for this error.
  LocalizedStringID description_id_;
  // Collection of key value pairs containing more details of the error (for
  // example actual contrast ratio in a contrast check).
  std::map<LocalizedStringID, std::string> details_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_ERROR_MESSAGE_H_
