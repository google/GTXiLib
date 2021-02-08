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

#include "ui_element.h"

namespace gtx {

void UIElement::set_is_ax_element(bool is_ax_element) {
  ax_data_.set_is_ax_element(is_ax_element);
}

bool UIElement::is_ax_element() const { return ax_data_.is_ax_element(); }

const std::string &UIElement::ax_label() const { return ax_data_.ax_label(); }

void UIElement::set_ax_label(const std::string &ax_label) {
  ax_data_.set_ax_label(ax_label);
}

void UIElement::set_ax_traits(gtx::ElementTrait ax_traits) {
  ax_data_.set_ax_traits((int64_t)ax_traits);
}

gtx::ElementTrait UIElement::ax_traits() const {
  return (gtx::ElementTrait)ax_data_.ax_traits();
}

const RectData &UIElement::ax_frame() const { return ax_data_.ax_frame(); }

void UIElement::set_ax_frame(const RectData &ax_frame) {
  ax_data_.mutable_ax_frame()->CopyFrom(ax_frame);
}

ElementType::ElementTypeEnum UIElement::element_type() const {
  return ax_data_.ax_element_type();
}

void UIElement::set_element_type(ElementType::ElementTypeEnum element_type) {
  ax_data_.set_ax_element_type(element_type);
}

bool UIElement::is_text_displaying_element() const {
  gtx::ElementTrait ax_traits = this->ax_traits();
  if ((ax_traits & ElementTrait::kStaticText) != ElementTrait::kNone ||
      (ax_traits & ElementTrait::kLink) != ElementTrait::kNone ||
      (ax_traits & ElementTrait::kSearchField) != ElementTrait::kNone ||
      (ax_traits & ElementTrait::kKeyboardKey) != ElementTrait::kNone) {
    return true;
  }
  ElementType::ElementTypeEnum element_type = this->element_type();
  if (element_type == ElementType::STATIC_TEXT ||
      element_type == ElementType::TEXT_FIELD ||
      element_type == ElementType::TEXT_VIEW) {
    return true;
  }
  // TODO: Account for elements representing accessibility elements
  // in a container which is a text field.
  return false;
}

}  // namespace gtx
