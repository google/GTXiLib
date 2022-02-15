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

#ifndef GTXILIB_OOPCLASSES_PROTOS_PROTO_UTILS_H_
#define GTXILIB_OOPCLASSES_PROTOS_PROTO_UTILS_H_

#include "typedefs.h"

// Utils to determine semantics of UIElementProtos without needing to know about
// their internal state.
namespace gtx {

// Determines if the given element represents a static text element.
bool IsStaticTextElement(const UIElementProto &element);

// Determines if the given element represents a button element.
bool IsButtonElement(const UIElementProto &element);

// Determines if the given element represents an element which displays text.
bool IsTextDisplayingElement(const UIElementProto &element);

}  // namespace gtx

#endif
