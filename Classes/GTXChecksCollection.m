//
// Copyright 2018 Google Inc.
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

#import "GTXChecksCollection.h"

#import "GTXCheckBlock.h"
#import "GTXChecking.h"
#import "GTXImageAndColorUtils.h"
#import "NSError+GTXAdditions.h"
#import "UIColor+GTXAdditions.h"

#pragma mark - Externs

NSString *const kGTXCheckNameAccessibilityLabelPresent = @"Accessibility label";
NSString *const kGTXCheckNameAccessibilityLabelNotPunctuated = @"Accessibility label punctuation";
NSString *const kGTXCheckNameAccessibilityLabelIsNotRedundantWithTraits =
    @"Accessibility label-trait overlap";
NSString *const kGTXCheckNameAccessibilityTraitsDontConflict = @"Accessibility traits";
NSString *const kGTXCheckNameMinimumTappableArea = @"Touch target size";
NSString *const kGTXCheckNameLabelMinimumContrastRatio = @"Contrast ratio (Label)";
NSString *const kGTXCheckNameTextViewMinimumContrastRatio = @"Contrast ratio (TextView)";

#pragma mark - Globals

/**
 *  The minimum size (width or height) for a given element to be easily accessible. Please read
 *  Material design guidelines for more on touch targets:
 *  https://material.io/design/layout/spacing-methods.html#touch-click-targets
 */
static const float kGTXMinSizeForAccessibleElements = 44.0;

/**
 *  The minimum contrast ratio for any given text to be considered accessible. Note that smaller
 *  text has even stricter requirement of 4.5:1.
 */
static const float kGTXMinContrastRatioForAccessibleText = 3.0;

#pragma mark - Implementations

@implementation GTXChecksCollection

+ (NSArray<id<GTXChecking>> *)allChecksForVersion:(GTXVersion)version {
  switch (version) {
    case GTXVersionLatest: return [self allGTXChecks];
    case GTXVersionPreRelease: return [self allGTXChecks];
    case GTXVersion_0: return [self allGTXChecks];
  }
}

+ (NSArray<id<GTXChecking>> *)allGTXChecks {
  return @[[self checkForAXLabelPresent],
           [self checkForAXLabelNotPunctuated],
           [self checkForAXLabelNotRedundantWithTraits],
           [self checkForAXTraitDontConflict],
           [self checkForMinimumTappableArea],
           [self checkForSufficientContrastRatio]];
}

#pragma mark - GTXChecks

+ (id<GTXChecking>)checkForAXLabelPresent {
  id<GTXChecking> check = [GTXCheckBlock GTXCheckWithName:kGTXCheckNameAccessibilityLabelPresent
                                   block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if ([self gtx_isTextDisplayingElement:element]) {
      // Elements that display text can use its text as an accessibility value making the
      // accessibility label optional.
      return YES;
    }
    NSError *error;
    NSString *label = [self stringValueOfAccessibilityLabelForElement:element
                                                                error:&error];
    if (error) {
      if (errorOrNil) {
        *errorOrNil = error;
      }
      return NO;
    }
    label = [self gtx_trimmedStringFromString:label];
    if ([label length] > 0) {
      // Check passed.
      return YES;
    }
    [NSError
        gtx_logOrSetGTXCheckFailedError:errorOrNil
                                element:element
                                   name:kGTXCheckNameAccessibilityLabelPresent
                            description:@"This element doesn’t have an accessibility label. All "
                                        @"accessibility elements must have accessibility labels."];
    return NO;
  }];
  return check;
}

+ (id<GTXChecking>)checkForAXLabelNotPunctuated {
  id<GTXChecking> check =
      [GTXCheckBlock GTXCheckWithName:kGTXCheckNameAccessibilityLabelNotPunctuated
                                block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if ([self gtx_isTextDisplayingElement:element]) {
      // This check is not applicable to text elements as accessibility labels can hold static text
      // that can be punctuated and formatted like a string.
      return YES;
    }
    NSError *error;
    NSString *stringValue = [self stringValueOfAccessibilityLabelForElement:element
                                                                      error:&error];
    if (error) {
      if (errorOrNil) {
        *errorOrNil = error;
      }
      return NO;
    }
    NSString *label = [self gtx_trimmedStringFromString:stringValue];
    // This check is not applicable for container elements that combine individual labels joined
    // with commas.
    if ([label rangeOfString:@","].location != NSNotFound) {
      return YES;
    }
    if ([label length] > 0 && [label hasSuffix:@"."]) {
      // Check failed.
      NSString *errorDescription = [NSString
          stringWithFormat:
              @"This element has an accessibility label that ends in a period but doesn’t have a "
              @"text trait. Accessibility labels aren’t sentences and don’t need periods. If the "
              @"element visually displays text it should have the UIAccessibilityTraitStaticText "
              @"trait similar to UITextView or UILabel.\n\nLabel found: %@.",
              label];
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                       element:element
                                          name:kGTXCheckNameAccessibilityLabelNotPunctuated
                                   description:errorDescription];
      return NO;
    }
    return YES;
  }];
  return check;
}

// @todo Include all UIAccessibilityTraits that announce themselves (image, search
// field, etc.), and find a more robust way to determine if the label is redundant. Currently, the
// suffix is compared to a single string, which causes false positives when that string occurs
// elsewhere in the label or synonyms are used. Additionally, the hardcoded string only works in
// English. This method also needs to be updated for i18n.
+ (id<GTXChecking>)checkForAXLabelNotRedundantWithTraits {
  id<GTXChecking> check =
    [GTXCheckBlock GTXCheckWithName:kGTXCheckNameAccessibilityLabelIsNotRedundantWithTraits
                              block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    UIAccessibilityTraits elementAXTraits = [element accessibilityTraits];
    NSString *elementAXLabel = [element accessibilityLabel];
    NSDictionary<NSNumber *, NSString *> const *redundantLabelsDictionary =
        [self gtx_traitsToRedundantLabelsDictionary];
    NSMutableArray<NSString *> *redundantTextList = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> *redundantTraitNameList = [[NSMutableArray alloc] init];
    for (NSNumber *testTrait in redundantLabelsDictionary) {
      NSString* redundantText = [redundantLabelsDictionary objectForKey:testTrait];
      UIAccessibilityTraits testUITrait = [testTrait unsignedLongLongValue];
      if ((BOOL)(elementAXTraits & testUITrait)) {
        if ([GTXChecksCollection gtx_caseInsensitive:elementAXLabel hasSuffix:redundantText]) {
          if ([element isKindOfClass:[UIButton class]] &&
              [GTXChecksCollection gtx_caseInsensitive:((UIButton *)element).titleLabel.text
                                             hasSuffix:redundantText]) {
            // This is a button whose title itself has the word "button", we must ignore this
            // kind of elements.
            continue;
          }
          NSError *error;
          NSString *stringValue = [self stringValueOfUIAccessibilityTraits:testUITrait
                                                                     error:&error];
          if (error) {
            if (errorOrNil) {
              *errorOrNil = error;
            }
            return NO;
          }

          [redundantTextList addObject:redundantText];
          [redundantTraitNameList addObject:stringValue];
        }
      }
    }
    if ([redundantTraitNameList count] > 0) {
      NSString* stringOfRedundantTextList = [redundantTextList componentsJoinedByString:@", "];
      NSString* stringOfRedundantTraitNameList =
          [redundantTraitNameList componentsJoinedByString:@", "];
      NSString *errorDescription = [NSString
          stringWithFormat:
              @"This element has an accessibility label that isn't needed because the element "
              @"already includes a trait.Traits such as the UIAccessibilityTraitButton cause "
              @"VoiceOver to speak \"button\" along with the label, so you don't need to include "
              @"the word \"button\".\n\nLabel found: %@\nRedundant label text found: %@\nRedundant "
              @"Trait(s) found: %@",
              elementAXLabel, stringOfRedundantTextList, stringOfRedundantTraitNameList];
      [NSError
          gtx_logOrSetGTXCheckFailedError:errorOrNil
                                  element:element
                                     name:kGTXCheckNameAccessibilityLabelIsNotRedundantWithTraits
                              description:errorDescription];
      return NO;
    }
    return YES;
  }];
  return check;
}

+ (id<GTXChecking>)checkForAXTraitDontConflict {
  id<GTXChecking> check =
      [GTXCheckBlock GTXCheckWithName:kGTXCheckNameAccessibilityTraitsDontConflict
                                block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if ([NSStringFromClass([element class]) isEqualToString:@"UIAccessibilityElementKBKey"]) {
      // iOS keyboard keys are known to have conflicting traits skip them.
      return YES;
    }
    UIAccessibilityTraits elementAXTraits = [element accessibilityTraits];
    // Even though we can check for valid accessibility traits, we are not doing that because some
    // undocumented UIKit controls, e.g., UINavigationItemButtonView, are known to have unknown
    // values. Check b/29226386 for more details.
    // Check mutually exclusive conflicts for the element's accessibility traits.
    for (NSArray<NSNumber *> *traitsConflictRule in [self gtx_traitsMutuallyExclusiveRules]) {
      NSMutableArray<NSString *> *conflictTraitsNameList = [[NSMutableArray alloc] init];
      for (NSNumber *testTrait in traitsConflictRule) {
        UIAccessibilityTraits testUITrait = [testTrait unsignedLongLongValue];
        if ((BOOL)(elementAXTraits & testUITrait)) {
          NSError *error;
          NSString *stringValue = [self stringValueOfUIAccessibilityTraits:testUITrait
                                                                     error:&error];
          if (error) {
            if (errorOrNil) {
              *errorOrNil = error;
            }
            return NO;
          }
          [conflictTraitsNameList addObject:stringValue];
        }
      }
      if ([conflictTraitsNameList count] > 1) {
        NSString *stringOfConflictTraitsNameList =
            [conflictTraitsNameList componentsJoinedByString:@", "];
        NSString *errorDescription =
            [NSString stringWithFormat:@"This element has traits that are conflicting. These "
                                       @"traits can’t occur at the same time: %@",
                                       stringOfConflictTraitsNameList];
        [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                         element:element
                                            name:kGTXCheckNameAccessibilityTraitsDontConflict
                                     description:errorDescription];
        return NO;
      }
    }
    return YES;
  }];
  return check;
}

+ (id<GTXChecking>)checkForMinimumTappableArea {
  id<GTXChecking> check =
      [GTXCheckBlock GTXCheckWithName:kGTXCheckNameMinimumTappableArea
                                block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if (![self gtx_isTappableNonLinkElement:element]) {
      // Element is not tappable or is a link, links follow the font size of the text on page and
      // are exempt from this check.
      return YES;
    }
    NSMutableArray<NSString *> *errorDescriptions = [[NSMutableArray alloc] init];
    if ([element respondsToSelector:@selector(accessibilityFrame)]) {
      [GTXChecksCollection gtx_errorDescriptionForMinimumTappableArea:[element accessibilityFrame]
                                                         propertyName:@"accessibilityFrame"
                                                           addToArray:errorDescriptions];
    }
    // In iOS 13, UIAccessibilityElement responds to the frame selector but always returns
    // CGRectZero. This causes all UIAccessibilityElement instances to fail touch target guidelines.
    // Since UIAccessibilityElement instances don't really have a frame independent of their
    // accessibility frame, ignoring elements with frames that are not UIView subclasses solves
    // this.
    else if ([element respondsToSelector:@selector(frame)] && [element isKindOfClass:[UIView class]]) {
      [GTXChecksCollection gtx_errorDescriptionForMinimumTappableArea:[element frame]
                                                         propertyName:@"frame"
                                                           addToArray:errorDescriptions];
    }
    if ([errorDescriptions count] > 0) {
      NSString *joiner = @"\n\n";
      NSString *propertyErrorDescription = [errorDescriptions componentsJoinedByString:joiner];
      NSString *errorDescription = [NSString
          stringWithFormat:
              @"This element has a small touch target. All tappable elements must have a minimum "
              @"touch target size of %dX%d points.%@%@",
              (int)kGTXMinSizeForAccessibleElements, (int)kGTXMinSizeForAccessibleElements, joiner,
              propertyErrorDescription];
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                       element:element
                                          name:kGTXCheckNameMinimumTappableArea
                                   description:errorDescription];
      return NO;
    }
    return YES;
  }];
  return check;
}

+ (id<GTXChecking>)checkForSufficientContrastRatio {
  id<GTXChecking> check =
  [GTXCheckBlock GTXCheckWithName:kGTXCheckNameLabelMinimumContrastRatio
                                block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if (![element isKindOfClass:[UILabel class]]) {
      return YES;
    } else if ([[(UILabel *)element text] length] == 0) {
      return  YES;
    }
    UIColor *textColor, *backgroundColor;
    CGFloat ratio = [GTXImageAndColorUtils contrastRatioOfUILabel:element
                                                  outAvgTextColor:&textColor
                                            outAvgBackgroundColor:&backgroundColor];
    BOOL hasSufficientContrast =
        (ratio >= kGTXMinContrastRatioForAccessibleText - kGTXContrastRatioAccuracy);
    if (!hasSufficientContrast) {
      // @TODO include actual color values found in the error description as well.
      NSString *errorDescription = [NSString
          stringWithFormat:@"This element has a low contrast ratio. All text and icons must have a "
                           @"minimum contrast ratio of %.5f.\n\nContrast ratio: %.5f\nText color: "
                           @"%@\nBackground color: %@",
                           (float)kGTXMinContrastRatioForAccessibleText, (float)ratio,
                           [textColor gtx_description], [backgroundColor gtx_description]];
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                       element:element
                                          name:kGTXCheckNameLabelMinimumContrastRatio
                                   description:errorDescription];
    }
    return hasSufficientContrast;
  }];
  return check;
}

+ (id<GTXChecking>)checkForSufficientTextViewContrastRatio {
  id<GTXChecking> check =
  [GTXCheckBlock GTXCheckWithName:kGTXCheckNameTextViewMinimumContrastRatio
                            block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if (![element isKindOfClass:[UITextView class]]) {
      return YES;
    } else if ([[(UITextView *)element text] length] == 0) {
      return  YES;
    }
    UIColor *textColor, *backgroundColor;
    CGFloat ratio = [GTXImageAndColorUtils contrastRatioOfUITextView:element
                                                     outAvgTextColor:&textColor
                                               outAvgBackgroundColor:&backgroundColor];

    BOOL hasSufficientContrast =
      (ratio >= kGTXMinContrastRatioForAccessibleText - kGTXContrastRatioAccuracy);
    if (!hasSufficientContrast) {
      NSString *errorDescription = [NSString
          stringWithFormat:@"This element has a low contrast ratio. All text and icons must have a "
                           @"minimum contrast ratio of %.5f.\n\nContrast ratio: %.5f\nText color: "
                           @"%@\nBackground color: %@",
                           (float)kGTXMinContrastRatioForAccessibleText, (float)ratio,
                           [textColor gtx_description], [backgroundColor gtx_description]];
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                       element:element
                                          name:kGTXCheckNameTextViewMinimumContrastRatio
                                   description:errorDescription];
    }
    return hasSufficientContrast;
  }];
  return check;
}

#pragma mark - Private

/**
 *  @return The NSArray contains the mutually exclusive rules for accessibility traits.
 *          For details, check go/gtx-ios.
 */
+ (NSArray<NSArray<NSNumber *> *> *)gtx_traitsMutuallyExclusiveRules {
  // Each item below consists of a mutually exclusive traits rule.
  return @[
    // Conflicting Rule No. 1
    @[
      @(UIAccessibilityTraitButton),
      @(UIAccessibilityTraitLink),
      @(UIAccessibilityTraitSearchField),
      @(UIAccessibilityTraitKeyboardKey)
    ],
    // Conflicting Rule No. 2
    @[
      @(UIAccessibilityTraitButton),
      @(UIAccessibilityTraitAdjustable)
    ]
  ];
}

/**
 *  @return The UIAccessibilityTraits to NSString mapping dictionary as type
 *          NSDictionary<NSNumber *, NSString *> *.
 */
+ (NSDictionary<NSNumber *, NSString *> const *)gtx_traitsToStringDictionary {
  // Each element below is an valid accessibility traits entity.
  return @{
    @(UIAccessibilityTraitNone):
      @"UIAccessibilityTraitNone",
    @(UIAccessibilityTraitButton):
      @"UIAccessibilityTraitButton",
    @(UIAccessibilityTraitLink):
      @"UIAccessibilityTraitLink",
    @(UIAccessibilityTraitSearchField):
      @"UIAccessibilityTraitSearchField",
    @(UIAccessibilityTraitImage):
      @"UIAccessibilityTraitImage",
    @(UIAccessibilityTraitSelected):
      @"UIAccessibilityTraitSelected",
    @(UIAccessibilityTraitPlaysSound):
      @"UIAccessibilityTraitPlaysSound",
    @(UIAccessibilityTraitKeyboardKey):
      @"UIAccessibilityTraitKeyboardKey",
    @(UIAccessibilityTraitStaticText):
      @"UIAccessibilityTraitStaticText",
    @(UIAccessibilityTraitSummaryElement):
      @"UIAccessibilityTraitSummaryElement",
    @(UIAccessibilityTraitNotEnabled):
      @"UIAccessibilityTraitNotEnabled",
    @(UIAccessibilityTraitUpdatesFrequently):
      @"UIAccessibilityTraitUpdatesFrequently",
    @(UIAccessibilityTraitStartsMediaSession):
      @"UIAccessibilityTraitStartsMediaSession",
    @(UIAccessibilityTraitAdjustable):
      @"UIAccessibilityTraitAdjustable",
    @(UIAccessibilityTraitAllowsDirectInteraction):
      @"UIAccessibilityTraitAllowsDirectInteraction",
    @(UIAccessibilityTraitCausesPageTurn):
      @"UIAccessibilityTraitCausesPageTurn",
    @(UIAccessibilityTraitHeader):
      @"UIAccessibilityTraitHeader"
  };
}

/**
 *  @return The NSString value of the specified accessibility traits.
 */
+ (NSString *)stringValueOfUIAccessibilityTraits:(UIAccessibilityTraits)traits
                                           error:(GTXErrorRefType)errorOrNil {
  NSString *stringValue = [[self gtx_traitsToStringDictionary]
      objectForKey:[NSNumber numberWithUnsignedLongLong:traits]];
  if (nil == stringValue) {
    NSString *errorMessage =
        [NSString stringWithFormat:@"This element defines accessibility traits 0x%016llx which may "
                                   @"be invalid.", traits];
    [NSError gtx_logOrSetError:errorOrNil
                   description:errorMessage
                          code:GTXCheckErrorCodeGenericError
                      userInfo:nil];
    return nil;
  }
  return stringValue;
}

/**
 *  @return The NSString value of the @c element's accessibility label or @c nil if label was not
 *          set or an error occurred extracting the label.
 */
+ (NSString *)stringValueOfAccessibilityLabelForElement:(id)element
                                                  error:(GTXErrorRefType)errorOrNil {
  NSString *stringValue;
  id accessibilityLabel = [element accessibilityLabel];
  if ([accessibilityLabel isKindOfClass:[NSString class]]) {
    stringValue = accessibilityLabel;
  } else if ([accessibilityLabel respondsToSelector:@selector(string)]) {
    stringValue = [accessibilityLabel string];
  } else if (accessibilityLabel) {
    NSString *errorMessage =
        [NSString stringWithFormat:@"String value of accessibility label %@ of class"
                                   @" %@ could not be extracted from element %@",
                                   accessibilityLabel,
                                   NSStringFromClass([accessibilityLabel class]),
                                   element];
    [NSError gtx_logOrSetError:errorOrNil
                   description:errorMessage
                          code:GTXCheckErrorCodeGenericError
                      userInfo:nil];
    return nil;
  }
  return stringValue;
}

/**
 *  @return Returns the string obtained by removing whitespace and newlines present at the beginning
 *          and the end of the specified @c string.
 */
+ (NSString *)gtx_trimmedStringFromString:(NSString *)string {
  return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  @return The UIAccessibilityTraits to redundant NSString accessibility label mapping dictionary
 *          as type NSDictionary<NSNumber *, NSString *> const *.
 */
+ (NSDictionary<NSNumber *, NSString *> const *)gtx_traitsToRedundantLabelsDictionary {
  return @{
    @(UIAccessibilityTraitButton):
      @"button",
  };
}

/**
 *  @return @c YES if @c element is tappable (for ex button) @c NO otherwise.
 */
+ (BOOL)gtx_isTappableNonLinkElement:(id)element {
  BOOL hasTappableTrait = NO;
  if ([element respondsToSelector:@selector(accessibilityTraits)]) {
    UIAccessibilityTraits traits = [element accessibilityTraits];
    hasTappableTrait = ((traits & UIAccessibilityTraitButton) ||
                        (traits & UIAccessibilityTraitLink) ||
                        (traits & UIAccessibilityTraitSearchField) ||
                        (traits & UIAccessibilityTraitPlaysSound) ||
                        (traits & UIAccessibilityTraitKeyboardKey));
  }
  return hasTappableTrait;
}

/**
 *  @return @c YES if @c element displays text @c NO otherwise.
 */
+ (BOOL)gtx_isTextDisplayingElement:(id)element {
  BOOL hasTextTrait = NO;
  if ([element respondsToSelector:@selector(accessibilityTraits)]) {
    UIAccessibilityTraits traits = [element accessibilityTraits];
    hasTextTrait = ((traits & UIAccessibilityTraitStaticText) ||
                    (traits & UIAccessibilityTraitLink) ||
                    (traits & UIAccessibilityTraitSearchField) ||
                    (traits & UIAccessibilityTraitKeyboardKey));
  }
  BOOL isContainedInTextField = NO;
  if ([element respondsToSelector:@selector(accessibilityContainer)]) {
    UIAccessibilityElement *container = [element accessibilityContainer];
    isContainedInTextField = [container isKindOfClass:[UITextField class]];
  }
  return ([element isKindOfClass:[UILabel class]] ||
          [element isKindOfClass:[UITextView class]] ||
          [element isKindOfClass:[UITextField class]] ||
          hasTextTrait ||
          isContainedInTextField);
}

/**
 *  Determines if @c frame satisfies minimum touch target guidelines.
 *
 *  @param frame The frame of an interactable element. This can be its frame, accessibilityFrame, or
 *  some other bounding box.
 *  @param propertyName The name of the element's property being checked. This is included in the
 *  description.
 *  @return A string describing the error, or @c nil if @c frame satisfies minimum touch target
 *  guidelines.
 */
+ (nullable NSString *)gtx_errorDescriptionForMinimumTappableArea:(CGRect)frame
                                                     propertyName:(NSString *)propertyName {
  CGFloat width = CGRectGetWidth(frame);
  CGFloat height = CGRectGetHeight(frame);
  if (width < kGTXMinSizeForAccessibleElements || height < kGTXMinSizeForAccessibleElements) {
    return [NSString
        stringWithFormat:@"\n\nElement %@: %dx%d.", propertyName, (int)width, (int)height];
  }
  return nil;
}

/**
 *  Determines if @c frame satisfies minimum touch target guidelines, and if it doesn't, adds an
 *  error description to @c array.
 *
 *  @param frame The frame of an interactable element. This can be its frame, accessibilityFrame, or
 *  some other bounding box.
 *  @param propertyName The name of the element's property being checked. This is included in the
 *  description.
 *  @param array The array to which to add the error description, if it exists.
 */
+ (void)gtx_errorDescriptionForMinimumTappableArea:(CGRect)frame
                                      propertyName:(NSString *)propertyName
                                        addToArray:(NSMutableArray *)array {
  NSString *errorDescription =
      [GTXChecksCollection gtx_errorDescriptionForMinimumTappableArea:frame
                                                         propertyName:propertyName];
  if (errorDescription != nil) {
    [array addObject:errorDescription];
  }
}

/**
 *  @return @c YES if the last characters of @c string equals @c suffix. Comparison is done case
 *  insensitively.
 */
+ (BOOL)gtx_caseInsensitive:(NSString *)string hasSuffix:(NSString *)suffix {
  return [[string lowercaseString] hasSuffix:suffix];
}

@end
