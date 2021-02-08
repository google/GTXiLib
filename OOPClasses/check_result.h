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

#ifndef GTXILIB_OOPCLASSES_CHECK_RESULT_H_
#define GTXILIB_OOPCLASSES_CHECK_RESULT_H_

#include <string>

#include "error_message.h"
#include "gtx_types.h"

namespace gtx {

// Encapsulates data associated with result of performing a check.
class CheckResult {
 public:
  CheckResult(const ErrorMessage &error_message, const ElementRef element_ref,
              const std::string &check_name);

  const ErrorMessage &error_message() const { return error_message_; }

  const ElementRef element_ref() const { return element_ref_; }

  const std::string &check_name() const { return check_name_; }

 private:
  ErrorMessage error_message_;
  ElementRef element_ref_;
  std::string check_name_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_CHECK_RESULT_H_
