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

#include "proto_utils.h"

#include "enums.pb.h"
#include "gtx.pb.h"
#include "typedefs.h"
#include "element_trait.h"

using gtxilib::oopclasses::protos::
    ElementType_ElementTypeEnum_BUTTON;
using gtxilib::oopclasses::protos::
    ElementType_ElementTypeEnum_STATIC_TEXT;
using gtxilib::oopclasses::protos::
    ElementType_ElementTypeEnum_TEXT_FIELD;
using gtxilib::oopclasses::protos::
    ElementType_ElementTypeEnum_TEXT_VIEW;

namespace gtx {

namespace {
// Returns true if element has accessibility_traits and they contain the given
// trait, or if element has element_type and it is equal to the given element
// type. Returns false if neither are true.
bool HasTraitOrElementType(const UIElementProto &element,
                               ElementTrait trait,
                               ElementTypeProto element_type) {
  if (element.has_ax_traits()) {
    ElementTrait ax_traits = static_cast<ElementTrait>(element.ax_traits());
    if ((ax_traits & trait) != ElementTrait::kNone) {
      return true;
    }
  }
  if (element.has_element_type()) {
    ElementTypeProto ax_element_type = element.element_type();
    if (ax_element_type == element_type) {
      return true;
    }
  }
  return false;
}

}  // namespace

bool IsStaticTextElement(const UIElementProto &element) {
  return HasTraitOrElementType(element, gtx::ElementTrait::kStaticText,
                                   ElementType_ElementTypeEnum_STATIC_TEXT);
}

bool IsButtonElement(const UIElementProto &element) {
  return HasTraitOrElementType(element, gtx::ElementTrait::kButton,
                                   ElementType_ElementTypeEnum_BUTTON);
}

bool IsTextDisplayingElement(const UIElementProto &element) {
  if (element.has_ax_traits()) {
    ElementTrait ax_traits = static_cast<ElementTrait>(element.ax_traits());
    if ((ax_traits & ElementTrait::kStaticText) != ElementTrait::kNone ||
        (ax_traits & ElementTrait::kLink) != ElementTrait::kNone ||
        (ax_traits & ElementTrait::kSearchField) != ElementTrait::kNone ||
        (ax_traits & ElementTrait::kKeyboardKey) != ElementTrait::kNone) {
      return true;
    }
  }
  if (element.has_element_type()) {
    ElementTypeProto element_type = element.element_type();
    if (element_type == ElementType_ElementTypeEnum_STATIC_TEXT ||
        element_type == ElementType_ElementTypeEnum_TEXT_FIELD ||
        element_type == ElementType_ElementTypeEnum_TEXT_VIEW) {
      return true;
    }
  }
  // TODO: Account for elements representing accessibility elements
  // in a container which is a text field.
  return false;
}

}  // namespace gtx
