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

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "GTXLogProperty.h"
#import "GTXProtoUtils.h"
#import "NSString+GTXAdditions.h"
#include "element_trait.h"

@implementation NSObject (GTXAdditions)

- (UIElementProto)gtx_toProto {
  UIElementProto proto;

  // Accessibility properties
  proto.set_is_ax_element(self.isAccessibilityElement);
  if (self.accessibilityLabel != nil) {
    proto.set_ax_label([self.accessibilityLabel gtx_stdString]);
  }
  if (self.accessibilityHint != nil) {
    proto.set_ax_hint([self.accessibilityHint gtx_stdString]);
  }
  proto.set_ax_traits(self.accessibilityTraits);
  *proto.mutable_ax_frame() = [GTXProtoUtils protoFromCGRect:self.accessibilityFrame];
  if ([self respondsToSelector:@selector(accessibilityIdentifier)]) {
    NSString *axIdentifier = [(id)self accessibilityIdentifier];
    if (axIdentifier != nil) {
      proto.set_ax_identifier([axIdentifier gtx_stdString]);
    }
  }
  NSArray<NSString *> *classNamesHierarchy = [self gtx_classNamesHierarchy];
  for (NSString *className in classNamesHierarchy) {
    proto.add_class_names_hierarchy([className gtx_stdString]);
  }

  // UIView properties

  if ([self respondsToSelector:@selector(backgroundColor)]) {
    UIColor *backgroundColor = [(UIView *)self backgroundColor];
    if (backgroundColor != nil) {
      *proto.mutable_background_color() = [GTXProtoUtils protoFromUIColor:backgroundColor];
    }
  }
  if ([self respondsToSelector:@selector(isHidden)]) {
    proto.set_hidden([(id)self isHidden]);
  }
  if ([self respondsToSelector:@selector(alpha)]) {
    proto.set_alpha([(id)self alpha]);
  }
  if ([self respondsToSelector:@selector(isOpaque)]) {
    proto.set_opaque([(id)self isOpaque]);
  }
  if ([self respondsToSelector:@selector(tintColor)]) {
    UIColor *tintColor = [(id)self tintColor];
    if (tintColor != nil) {
      *proto.mutable_tint_color() = [GTXProtoUtils protoFromUIColor:tintColor];
    }
  }
  if ([self respondsToSelector:@selector(clipsToBounds)]) {
    proto.set_clips_to_bounds([(id)self clipsToBounds]);
  }
  if ([self respondsToSelector:@selector(isUserInteractionEnabled)]) {
    proto.set_user_interaction_enabled([(id)self isUserInteractionEnabled]);
  }
  if ([self respondsToSelector:@selector(isMultipleTouchEnabled)]) {
    proto.set_multiple_touch_enabled([(id)self isMultipleTouchEnabled]);
  }
  if ([self respondsToSelector:@selector(isExclusiveTouch)]) {
    proto.set_exclusive_touch([(id)self isExclusiveTouch]);
  }
  if ([self respondsToSelector:@selector(frame)]) {
    *proto.mutable_frame() = [GTXProtoUtils protoFromCGRect:[(id)self frame]];
  }
  if ([self respondsToSelector:@selector(bounds)]) {
    *proto.mutable_bounds() = [GTXProtoUtils protoFromCGRect:[(id)self bounds]];
  }

  // UIControl

  if ([self respondsToSelector:@selector(state)]) {
    proto.set_control_state([(UIControl *)self state]);
  }
  if ([self respondsToSelector:@selector(isEnabled)]) {
    proto.set_enabled([(UIControl *)self isEnabled]);
  }
  if ([self respondsToSelector:@selector(isSelected)]) {
    proto.set_selected([(UIControl *)self isSelected]);
  }
  if ([self respondsToSelector:@selector(isHighlighted)]) {
    proto.set_highlighted([(UIControl *)self isHighlighted]);
  }
  if ([self respondsToSelector:@selector(title)]) {
    proto.set_title([[(id)self title] gtx_stdString]);
  }
  if ([self respondsToSelector:@selector(text)]) {
    proto.set_text([[(UITextField *)self text] gtx_stdString]);
  }
  if ([self respondsToSelector:@selector(isOn)]) {
    proto.set_on([(UISwitch *)self isOn]);
  }
  if ([self isKindOfClass:[UISlider class]] || [self isKindOfClass:[UIStepper class]]) {
    // Both UISlider and UIStepper declare value.
    proto.set_value([(UISlider *)self value]);
  }
  return proto;
}

#pragma mark - Private

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
  UIAccessibilityTraits traits =
      ([self respondsToSelector:@selector(accessibilityTraits)] ? [self accessibilityTraits] : 0);
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

/**
 * @returns An array of string representations of this element's class and all classes
 *  its class descends from.
 */
- (NSArray<NSString *> *)gtx_classNamesHierarchy {
  NSMutableArray<NSString *> *classNames = [[NSMutableArray alloc] init];
  Class currentClass = [self class];
  do {
    [classNames addObject:NSStringFromClass(currentClass)];
  } while ((currentClass = class_getSuperclass(currentClass)) != nil);
  return classNames;
}

@end
