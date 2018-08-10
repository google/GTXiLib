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

#pragma mark - Externs

NSString *const kGTXCheckNameAccessibilityLabelPresent = @"Accessibility Label Present";
NSString *const kGTXCheckNameAccessibilityLabelNotPunctuated =
    @"Accessibility Label Not Punctuated";
NSString *const kGTXCheckNameAccessibilityLabelIsNotRedundantWithTraits =
    @"Accessibility Label is Not Redundant with Traits";
NSString *const kGTXCheckNameAccessibilityTraitsDontConflict =
    @"Accessibility Traits Don't Conflict";
NSString *const kGTXCheckNameMinimumTappableArea = @"Element has Minimum Tappable Area";
NSString *const kGTXCheckNameMinimumContrastRatio = @"Element has Minimum Contrast Ratio";

#pragma mark - Globals

/**
 *  The minimum size (width or height) for a given element to be easily accessible. Based on
 *  Material design guidelines:
 *  https://material.io/design/layout/spacing-methods.html#touch-click-targets
 */
static const float kGTXMinSizeForAccessibleElements = 48.0;

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
    label = [self trimmedStringFromString:label];
    if ([label length] > 0) {
      // Check passed.
      return YES;
    }
    [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                     element:element
                                        name:kGTXCheckNameAccessibilityLabelPresent
                                 description:@"Accessibility elements should have an appropriate "
                                             @"accessibility label."];
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
    NSString *label = [self trimmedStringFromString:stringValue];
    // This check is not applicable for container elements that combine individual labels joined
    // with commas.
    if ([label rangeOfString:@","].location != NSNotFound) {
      return YES;
    }
    if ([label length] > 0 && [label hasSuffix:@"."]) {
      // Check failed.
      NSString *errorDescription = @"Suggest removing the period at the end of this element's "
                                   @"accessibility label. Accessibility labels are not sentences "
                                   @"therefore they should not end in period. If the element "
                                   @"visually displays text it should have the "
                                   @"UIAccessibilityTraitStaticText trait similar to "
                                   @"UITextView or UILabel.";
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
        [self traitsToRedundantLabelsDictionary];
    NSMutableArray<NSString *> *redundantTextList = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> *redundantTraitNameList = [[NSMutableArray alloc] init];
    for (NSNumber *testTrait in redundantLabelsDictionary) {
      NSString* redundantText = [redundantLabelsDictionary objectForKey:testTrait];
      UIAccessibilityTraits testUITrait = [testTrait unsignedLongLongValue];
      if ((BOOL)(elementAXTraits & testUITrait)) {
        if ([GTXChecksCollection caseInsensitive:elementAXLabel hasSuffix:redundantText]) {
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
      NSString *description = [NSString stringWithFormat:@"Suggest removing '%@' from the "
                                                         @"accessibility label '%@'. The element "
                                                         @"already contains the accessibility "
                                                         @"trait(s) %@. VoiceOver announces those "
                                                         @"traits to the user, so putting "
                                                         @"redundant words in the label causes "
                                                         @"VoiceOver to repeat them.",
                                                         stringOfRedundantTextList,
                                                         elementAXLabel,
                                                         stringOfRedundantTraitNameList];
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
              element:element
                 name:kGTXCheckNameAccessibilityLabelIsNotRedundantWithTraits
          description:description];
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
    for (NSArray<NSNumber *> *traitsConflictRule in [self traitsMutuallyExclusiveRules]) {
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
        NSString *description =
            [NSString stringWithFormat:@"Suggest removing the trait conflict among %@ since they "
                                       @"are mutually exclusive.", stringOfConflictTraitsNameList];
        [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                         element:element
                                            name:kGTXCheckNameAccessibilityTraitsDontConflict
                                     description:description];
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
    if ([element respondsToSelector:@selector(accessibilityFrame)]) {
      CGRect frame = [element accessibilityFrame];
      BOOL hasSmallWidth = CGRectGetWidth(frame) < kGTXMinSizeForAccessibleElements;
      BOOL hasSmallHeight = CGRectGetHeight(frame) < kGTXMinSizeForAccessibleElements;
      if (hasSmallWidth || hasSmallHeight) {
        NSString *dimensionsToBeFixed;
        // Append a suggestion to the error description.
        if (hasSmallWidth && hasSmallHeight) {
          // Both width and height make the element inaccessible.
          dimensionsToBeFixed = @"frame width and height";
        } else if (hasSmallWidth) {
          // Only width is making the element inaccessible.
          dimensionsToBeFixed = @"frame width";
        } else {
          // Only height is making the element inaccessible.
          dimensionsToBeFixed = @"frame height";
        }
        NSString *description =
            [NSString stringWithFormat:@"Suggest increasing element's %@ to at least %d for "
                                       @"a suggested tappable area of at least %dX%d",
                                       dimensionsToBeFixed,
                                       (int)kGTXMinSizeForAccessibleElements,
                                       (int)kGTXMinSizeForAccessibleElements,
                                       (int)kGTXMinSizeForAccessibleElements];

        [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                         element:element
                                            name:kGTXCheckNameMinimumTappableArea
                                     description:description];
        return NO;
      }
    }
    return YES;
  }];
  return check;
}

+ (id<GTXChecking>)checkForSufficientContrastRatio {
  id<GTXChecking> check =
      [GTXCheckBlock GTXCheckWithName:kGTXCheckNameMinimumContrastRatio
                                block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    if (![element isKindOfClass:[UILabel class]]) {
      return YES;
    }
    CGFloat ratio = [GTXImageAndColorUtils contrastRatioOfUILabel:element];
    BOOL hasSufficientContrast =
        (ratio >= kGTXMinContrastRatioForAccessibleText - kGTXContrastRatioAccuracy);
    if (!hasSufficientContrast) {
      NSString *description =
          [NSString stringWithFormat:@"Suggest increasing this element's contrast ratio to at "
                                     "least "
                                     @"%.5f the actual ratio was computed as %.5f",
                                     (float)kGTXMinContrastRatioForAccessibleText, (float)ratio];
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                       element:element
                                          name:kGTXCheckNameMinimumContrastRatio
                                   description:description];
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
+ (NSArray<NSArray<NSNumber *> *> *)traitsMutuallyExclusiveRules {
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
+ (NSDictionary<NSNumber *, NSString *> const *)traitsToStringDictionary {
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
  NSString *stringValue = [[self traitsToStringDictionary]
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
+ (NSString *)trimmedStringFromString:(NSString *)string {
  return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  @return The UIAccessibilityTraits to redundant NSString accessibility label mapping dictionary
 *          as type NSDictionary<NSNumber *, NSString *> const *.
 */
+ (NSDictionary<NSNumber *, NSString *> const *)traitsToRedundantLabelsDictionary {
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
  return ([element isKindOfClass:[UILabel class]] ||
          [element isKindOfClass:[UITextView class]] ||
          [element isKindOfClass:[UITextField class]] ||
          hasTextTrait);
}

/**
 *  @return @c YES if the last characters of @c string equals @c suffix. Comparison is done case
 *  insensitively.
 */
+ (BOOL)caseInsensitive:(NSString*)string hasSuffix:(NSString*)suffix {
  return [[string lowercaseString] hasSuffix:suffix];
}

@end
