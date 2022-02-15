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

#include "string_utils.h"

#include <algorithm>
#include <cctype>
#include <iterator>
#include <string>

namespace gtx {

std::string TrimWhitespace(std::string str) {
  auto first_nonwhitespace_iter =
      std::find_if_not(str.begin(), str.end(), std::isspace);
  auto trimmed_leading = str.substr(first_nonwhitespace_iter - str.begin(),
                                    str.end() - first_nonwhitespace_iter);
  auto last_nonwhitespace_iter = std::find_if_not(
      trimmed_leading.rbegin(), trimmed_leading.rend(), std::isspace);
  return trimmed_leading.substr(
      0, trimmed_leading.rend() - last_nonwhitespace_iter);
}

}  // namespace gtx
