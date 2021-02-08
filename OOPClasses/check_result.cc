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

#include "check_result.h"

#include <string>

namespace gtx {

CheckResult::CheckResult(const ErrorMessage &error_message,
                         const ElementRef element_ref,
                         const std::string &check_name)
    : error_message_(error_message),
      element_ref_(element_ref),
      check_name_(check_name) {}

}  // namespace gtx
