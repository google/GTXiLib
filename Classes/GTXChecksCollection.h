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

#import <UIKit/UIKit.h>

#import "GTXChecking.h"

/**
 Enum of all versions supported by GTXiLib.
 */
typedef NS_ENUM(NSUInteger, GTXVersion) {
  /**
   Placeholder enum for the latest version of GTX.
   */
  GTXVersionLatest,

  /**
   Placeholder enum for the prerelease version of GTX.
   */
  GTXVersionPreRelease,

  /**
   Enum for Version 0 of GTX.
   */
  GTXVersion_0,
};

/**
 *  Organizes all checks provided by GTX, developers can use these as a starting point
 *  for implementing their own checks. These checks are based on recommendations found in
 *  "Accessibility Programming Guide for iOS"
    @link
 https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/iPhoneAccessibility/Introduction/Introduction.html
 // NOLINT
 *  and on WCAG.
 */
@interface GTXChecksCollection : NSObject

/**
 *  @return An array of all supported GTXChecks for the given @c version.
 */
+ (NSArray<id<GTXChecking>> *)allGTXChecksForVersion:(GTXVersion)version;

/**
 *  @return An array of all supported GTXChecks.
 */
+ (NSArray<id<GTXChecking>> *)allGTXChecks;

/**
 * Returns an array of all supported GTXChecks for @c version except those with names in
 * @c excludedCheckNames. Crashes with an assertion if an element in @c excludedCheckNames does not
 * have a corresponding check.
 *
 * @param version The version of the GTX check suite to use.
 * @param excludedCheckNames The names of the checks to exclude from the returned array.
 * @return All GTXChecks for @c version, except checks whose names are found in
 * @c excludedCheckNames.
 */
+ (NSArray<id<GTXChecking>> *)allGTXChecksForVersion:(GTXVersion)version
                            excludingChecksWithNames:(NSSet<NSString *> *)excludedCheckNames;

/**
 *  @return a check that verifies that accessibility label is present on all accessibility elements.
 */
+ (id<GTXChecking>)checkForAXLabelPresent;

/**
 *  @return a check that verifies that accessibility labels are not punctuated as recommended by
 *  "Accessibility Programming Guide for iOS" (see class docs).
 */
+ (id<GTXChecking>)checkForAXLabelNotPunctuated;

/**
 *  @return a check that verifies that accessibility labels do not end in strings that VoiceOver
 *  announces via the element's accessibility traits.
 */
+ (id<GTXChecking>)checkForAXLabelNotRedundantWithTraits;

/**
 *  @return a check that verifies that accessibility traits dont conflict with each other as
 *  recommended by "Accessibility Programming Guide for iOS" (see class docs).
 */
+ (id<GTXChecking>)checkForAXTraitDontConflict;

/**
 *  @return a check that verifies that tappable areas of all buttons are at least 48X48 points.
 */
+ (id<GTXChecking>)checkForMinimumTappableArea;

/**
 *  @return a check that verifies that contrast of all UILabel elements is at least 3.0.
 */
+ (id<GTXChecking>)checkForSufficientContrastRatio;

/**
 *  @return a check that verifies that contrast of all UITextView elements is at least 3.0.
 */
+ (id<GTXChecking>)checkForSufficientTextViewContrastRatio;

/**
 *  @return a check that verifies that contrast of all text elements using OCR when available.
 */
+ (id<GTXChecking>)checkForSufficientContrastRatioUsingOCR;

/**
 *  @return a check that verifies that a text displaying element automatically scales font size with
 *  Dynamic Type. Text displaying elements include UILabel, UITextView, and UITextField, and custom
 *  views that implement @c adjustsFontForContentSizeCategory and @c font.
 */
+ (id<GTXChecking>)checkForSupportsDynamicType;

#pragma mark - Utils

/**
 *  @return @c YES if @c element displays text @c NO otherwise.
 */
+ (BOOL)isTextDisplayingElement:(id)element;

@end
