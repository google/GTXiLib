//
// Copyright 2021 Google Inc.
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

#include "xml_utils.h"

#include <abseil/absl/strings/str_cat.h>

namespace gtx {

void RecursivelyAppendTextFromXMLNode(std::string &text,
                                      tinyxml2::XMLNode *node) {
  tinyxml2::XMLNode *text_node = node->ToText();
  if (text_node != nullptr) {
    absl::StrAppend(&text, text_node->Value());
  }
  tinyxml2::XMLNode *child = node->FirstChild();
  while (child != nullptr) {
    RecursivelyAppendTextFromXMLNode(text, child);
    child = child->NextSibling();
  }
}

}  // namespace gtx
