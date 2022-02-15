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

#ifndef GTXILIB_OOPCLASSES_ELEMENT_TYPE_H_
#define GTXILIB_OOPCLASSES_ELEMENT_TYPE_H_

#include "enums.pb.h"
#include "gtx.pb.h"

namespace gtx {

// Represents an XCUIElementType retrieved from an
// XCUIElementAttributes-implementing object.
typedef gtxilib::oopclasses::protos::ElementType
    ElementType;

}  // namespace gtx
#endif  // GTXILIB_OOPCLASSES_ELEMENT_TYPE_H_
