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

#ifndef GTXILIB_OOPCLASSES_PROTOS_ELEMENT_TRAIT_H_
#define GTXILIB_OOPCLASSES_PROTOS_ELEMENT_TRAIT_H_

#include <cstdint>

namespace gtx {
// An enum representing a traits (cpp equivalent for UIAccessibilityTraits).
enum class ElementTrait : uint64_t {
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

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_PROTOS_ELEMENT_TRAIT_H_
