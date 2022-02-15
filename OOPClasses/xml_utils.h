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

#ifndef GTXILIB_OOPCLASSES_XML_UTILS_H_
#define GTXILIB_OOPCLASSES_XML_UTILS_H_

#include <string>

#include "tinyxml2.h"

// Convenience methods for interacting with XML documents.
namespace gtx {

// Crawls `root_node`'s children, appending the text of each text node in a pre
// order traversal. Non text nodes are skipped. `text` is the string to append
// to. `root_node` is the node to crawl the text of.
void RecursivelyAppendTextFromXMLNode(std::string &text,
                                      tinyxml2::XMLNode *root_node);

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_XML_UTILS_H_
