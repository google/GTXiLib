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

#ifndef GTXILIB_OOPCLASSES_UI_ELEMENT_H_
#define GTXILIB_OOPCLASSES_UI_ELEMENT_H_

#include <optional>
#include <string>

#include "Protos/gtx.pb.h"
#include "element_type.h"
#include "gtx_types.h"

namespace gtx {

typedef gtxilib::oopclasses::protos::UIElement
    UIElementData;
using gtxilib::oopclasses::protos::ElementType;

// An enum representing a traits (cpp equivalent for UIAccessibilityTraits).
enum class ElementTrait {
  // UIAccessibilityTraitNone equivalent.
  kNone = 0,
  // UIAccessibilityTraitButton equivalent.
  kButton = 1 << 0,
  // UIAccessibilityTraitLink equivalent.
  kLink = 1 << 1,
  // UIAccessibilityTraitSearchField equivalent.
  kSearchField = 1 << 2,
  // UIAccessibilityTraitImage equivalent.
  kImage = 1 << 3,
  // UIAccessibilityTraitSelected equivalent.
  kSelected = 1 << 4,
  // UIAccessibilityTraitPlaysSound equivalent.
  kPlaysSound = 1 << 5,
  // UIAccessibilityTraitKeyboardKey equivalent.
  kKeyboardKey = 1 << 6,
  // UIAccessibilityTraitStaticText equivalent.
  kStaticText = 1 << 7,
  // UIAccessibilityTraitSummaryElement equivalent.
  kSummaryElement = 1 << 8,
  // UIAccessibilityTraitNotEnabled equivalent.
  kNotEnabled = 1 << 9,
  // UIAccessibilityTraitUpdatesFrequently equivalent.
  kUpdatesFrequently = 1 << 10,
  // UIAccessibilityTraitStartsMediaSession equivalent.
  kStartsMediaSession = 1 << 11,
  // UIAccessibilityTraitAdjustable equivalent.
  kAdjustable = 1 << 12,
  // UIAccessibilityTraitAllowsDirectInteraction equivalent.
  kAllowsDirectInteraction = 1 << 13,
  // UIAccessibilityTraitCausesPageTurn equivalent.
  kCausesPageTurn = 1 << 14,
  // UIAccessibilityTraitHeader equivalent.
  kHeader = 1 << 15,
};

// Bitwise 'or' operators for ElementTrait enum.
constexpr ElementTrait operator|(ElementTrait a, ElementTrait b) {
  return static_cast<ElementTrait>(static_cast<int>(a) | static_cast<int>(b));
}

// Bitwise 'and' operators for ElementTrait enum.
constexpr ElementTrait operator&(ElementTrait a, ElementTrait b) {
  return static_cast<ElementTrait>(static_cast<int>(a) & static_cast<int>(b));
}

// UIElement encapsulates all the information associated wth a single element on
// the screen that is needed for checks to run. Note that this means that
// UIElement can inclue info from any of: UIView, UIAccessibilityElement,
// XCUIElement etc.
class UIElement {
 public:
  UIElement() {}

  void set_is_ax_element(bool is_ax_element);
  bool is_ax_element() const;

  const std::string &ax_label() const;
  void set_ax_label(const std::string &ax_label);

  void set_ax_traits(ElementTrait ax_traits);
  ElementTrait ax_traits() const;

  const RectData &ax_frame() const;
  void set_ax_frame(const RectData &ax_frame);
  // TODO: Add all the properties needed for all of the default
  // accessibility checks to run.

  ElementType::ElementTypeEnum element_type() const;
  void set_element_type(ElementType::ElementTypeEnum element_type);

  // Returns true if the element displays visible text, false otherwise.
  bool is_text_displaying_element() const;

 private:
  UIElementData ax_data_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_UI_ELEMENT_H_
