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

#import "NSObject+GTXAdditions.h"

@implementation NSObject (GTXAdditions)

- (std::unique_ptr<gtx::UIElement>)gtx_UIElement {
  auto ui_element = std::make_unique<gtx::UIElement>();
  ui_element->set_is_ax_element([self gtx_isAxElement]);
  ui_element->set_ax_label([self gtx_axLabel]);
  ui_element->set_ax_frame([self gtx_axFrame]);
  ui_element->set_ax_traits([self gtx_axTraits]);
  return ui_element;
}

/**
 *  @returns [self isAccessibilityElement] if implemented, @c false otherwise.
 */
- (bool)gtx_isAxElement {
  return ([self respondsToSelector:@selector(isAccessibilityElement)]
              ? [self isAccessibilityElement]
              : false);
}

/**
 *  @returns [self accessibilityLabel] if implemented, empty std::string otherwise.
 */
- (std::string)gtx_axLabel {
  const char *labelCString =
      ([self respondsToSelector:@selector(accessibilityLabel)]
           ? [[self accessibilityLabel] cStringUsingEncoding:NSASCIIStringEncoding]
           : NULL);
  if (!labelCString) {
    return std::string();
  }
  return std::string(labelCString);
}

/**
 *  @returns [self accessibilityFrame] if implemented, CGRectZero otherwise.
 */
- (gtx::RectData)gtx_axFrame {
  CGRect rect = ([self respondsToSelector:@selector(accessibilityFrame)] ?
                 [self accessibilityFrame] : CGRectZero);
  gtx::RectData frame;
  frame.mutable_size()->set_width(rect.size.width);
  frame.mutable_size()->set_height(rect.size.height);
  frame.mutable_origin()->set_x(rect.origin.x);
  frame.mutable_origin()->set_y(rect.origin.y);
  return frame;
}

/**
 *  @returns @c gtx::ElementTrait for the given trait of type @c UIAccessibilityTraits.
 */
+ (gtx::ElementTrait)gtx_gtxTraitFromUIAccessibilityTrait:(UIAccessibilityTraits)trait {
  // Use if-else to check for trait values since UIAccessibilityTrait* are not considered "constant
  // expressions".
  if (trait == UIAccessibilityTraitNone) {
    return gtx::ElementTrait::kNone;
  } else if (trait == UIAccessibilityTraitButton) {
    return gtx::ElementTrait::kButton;
  } else if (trait == UIAccessibilityTraitLink) {
    return gtx::ElementTrait::kLink;
  } else if (trait == UIAccessibilityTraitSearchField) {
    return gtx::ElementTrait::kSearchField;
  } else if (trait == UIAccessibilityTraitImage) {
    return gtx::ElementTrait::kImage;
  } else if (trait == UIAccessibilityTraitSelected) {
    return gtx::ElementTrait::kSelected;
  } else if (trait == UIAccessibilityTraitPlaysSound) {
    return gtx::ElementTrait::kPlaysSound;
  } else if (trait == UIAccessibilityTraitKeyboardKey) {
    return gtx::ElementTrait::kKeyboardKey;
  } else if (trait == UIAccessibilityTraitStaticText) {
    return gtx::ElementTrait::kStaticText;
  } else if (trait == UIAccessibilityTraitSummaryElement) {
    return gtx::ElementTrait::kSummaryElement;
  } else if (trait == UIAccessibilityTraitNotEnabled) {
    return gtx::ElementTrait::kNotEnabled;
  } else if (trait == UIAccessibilityTraitUpdatesFrequently) {
    return gtx::ElementTrait::kUpdatesFrequently;
  } else if (trait == UIAccessibilityTraitStartsMediaSession) {
    return gtx::ElementTrait::kStartsMediaSession;
  } else if (trait == UIAccessibilityTraitAdjustable) {
    return gtx::ElementTrait::kAdjustable;
  } else if (trait == UIAccessibilityTraitAllowsDirectInteraction) {
    return gtx::ElementTrait::kAllowsDirectInteraction;
  } else if (trait == UIAccessibilityTraitCausesPageTurn) {
    return gtx::ElementTrait::kCausesPageTurn;
  } else if (trait == UIAccessibilityTraitHeader) {
    return gtx::ElementTrait::kHeader;
  } else {
    NSAssert(NO, @"Unhandled trait %ld", (long)trait);
  }
  return gtx::ElementTrait::kNone;
}

/**
 *  @returns [self accessibilityTraits] (converted to gtx::ElementTrait) if implemented,
 *  kNone otherwise.
 */
- (gtx::ElementTrait)gtx_axTraits {
  UIAccessibilityTraits traits = ([self respondsToSelector:@selector(accessibilityTraits)] ?
                                  [self accessibilityTraits] : 0);
  NSArray<NSNumber *> *allApplicableTraits = @[
    @(UIAccessibilityTraitButton),
    @(UIAccessibilityTraitLink),
    @(UIAccessibilityTraitSearchField),
    @(UIAccessibilityTraitImage),
    @(UIAccessibilityTraitSelected),
    @(UIAccessibilityTraitPlaysSound),
    @(UIAccessibilityTraitKeyboardKey),
    @(UIAccessibilityTraitStaticText),
    @(UIAccessibilityTraitSummaryElement),
    @(UIAccessibilityTraitNotEnabled),
    @(UIAccessibilityTraitUpdatesFrequently),
    @(UIAccessibilityTraitStartsMediaSession),
    @(UIAccessibilityTraitAdjustable),
    @(UIAccessibilityTraitAllowsDirectInteraction),
    @(UIAccessibilityTraitCausesPageTurn),
    @(UIAccessibilityTraitHeader),
  ];
  gtx::ElementTrait gtxTraits = gtx::ElementTrait::kNone;
  for (NSNumber *trait in allApplicableTraits) {
    UIAccessibilityTraits uikitTrait = [trait integerValue];
    if (uikitTrait & traits) {
      gtxTraits = gtxTraits | [NSObject gtx_gtxTraitFromUIAccessibilityTrait:uikitTrait];
    }
  }
  return gtxTraits;
}

@end
