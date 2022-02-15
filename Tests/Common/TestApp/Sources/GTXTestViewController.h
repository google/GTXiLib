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

/**
 *  Name of the action that adds an element that has no accessibilityLabel.
 */
FOUNDATION_EXTERN NSString *const kAddNoLabelElementActionName;

/**
 *  Name of the action that adds an element whose accessibility label does not end with punctuation.
 */
FOUNDATION_EXTERN NSString *const kAddNonpunctuatedLabelElementActionName;

/**
 *  Name of the action that adds an element whose accessibility label has been punctuated.
 */
FOUNDATION_EXTERN NSString *const kAddPunctuatedLabelElementActionName;

/**
 *  Name of the action that adds an element whose accessibility label has been concatenated (with
 *  commas).
 */
FOUNDATION_EXTERN NSString *const kAddConcatenatedLabelElementActionName;

/**
 *  Name of the action that adds a text field and focuses it to show a keyboard.
 */
FOUNDATION_EXTERN NSString *const kShowKeyboardActionName;

/**
 *  Name of the action that hides the shown keyboard.
 */
FOUNDATION_EXTERN NSString *const kHideKeyboardActionName;

/**
 *  Name of the action that adds a button marked as not accessible.
 */
FOUNDATION_EXTERN NSString *const kAddInaccessibleButton;

/**
 *  Name of the action that adds a button marked as not accessible inside a container.
 */
FOUNDATION_EXTERN NSString *const kAddAccessibleButtonInContainer;

/**
 *  Name of the action that adds an element with tiny tap area.
 */
FOUNDATION_EXTERN NSString *const kAddTinyTappableElement;

/**
 *  Name of the action that adds a label with very high contrast.
 */
FOUNDATION_EXTERN NSString *const kAddVeryHighContrastLabel;

/**
 *  Name of the action that adds a label with very low contrast.
 */
FOUNDATION_EXTERN NSString *const kAddVeryLowContrastLabel;

/**
 *  Name of the action that adds a label with barely high contrast.
 */
FOUNDATION_EXTERN NSString *const kAddBarelyHighContrastLabel;

/**
 *  Name of the action that adds a label with barely low contrast.
 */
FOUNDATION_EXTERN NSString *const kAddBarelyLowContrastLabel;

/**
 *  Name of the action that adds a label with zero contrast.
 */
FOUNDATION_EXTERN NSString *const kAddNoContrastLabel;

/**
 *  Name of the action that adds a label with transparency that still has high contrast.
 */
FOUNDATION_EXTERN NSString *const kAddTransparentHighContrastLabel;

/**
 *  Name of the action that adds a label with low contrast because of its transparency.
 */
FOUNDATION_EXTERN NSString *const kAddTransparentLowContrastLabel;

/**
 *  Name of the action that adds a text view with low contrast.
 */
FOUNDATION_EXTERN NSString *const kAddLowContrastTextView;

/**
 *  Name of the action that adds a standard text view.
 */
FOUNDATION_EXTERN NSString *const kAddStandardUIKitTextView;

/**
 *  Name of the action that adds a label with a font constructed with fontWithName.
 */
FOUNDATION_EXTERN NSString *const kAddLabelWithFontWithName;

/**
 *  Name of the action that adds a label with a font constructed with preferredFontForTextStyle.
 */
FOUNDATION_EXTERN NSString *const kAddLabelWithPreferredFontForTextStyle;

/**
 *  Name of the action that adds a label with a font constructed with UIFontMetrics
 *  scaledFontForFont. This event is a no-op before iOS 11, when UIFontMetrics had not been
 *  introduced.
 */
FOUNDATION_EXTERN NSString *const kAddLabelWithFontMetrics;

/**
 *  Name of the action that adds a text view with a font constructed with fontWithName.
 */
FOUNDATION_EXTERN NSString *const kAddTextViewWithFontWithName;

/**
 *  Name of the action that adds a text view with a font constructed with preferredFontForTextStyle.
 */
FOUNDATION_EXTERN NSString *const kAddTextViewWithPreferredFontForTextStyle;

/**
 *  Name of the action that adds a text view with a font constructed with UIFontMetrics
 *  scaledFontForFont. This event is a no-op before iOS 11, when UIFontMetrics had not been
 *  introduced.
 */
FOUNDATION_EXTERN NSString *const kAddTextViewWithFontMetrics;

/**
 *  Name of the action that adds a high contrast background.
 */
FOUNDATION_EXTERN NSString *const kAddHighContrastBackground;

/**
 *  Name of the action that adds multiple nested accessibility elements.
 */
FOUNDATION_EXTERN NSString *const kAddMultipleElementsWithChildren;

/**
 *  Name of the action that adds test element with custom traits.
 */
FOUNDATION_EXTERN NSString *const kAddCustomTraitsTestElement;

/**
 *  Name of the action that adds UIAccessibilityTraitButton trait to test element.
 */
FOUNDATION_EXTERN NSString *const kAddButtonTraitToCustomTraitsElement;

/**
 *  Name of the action that adds UIAccessibilityTraitPlaysSound trait to test element.
 */
FOUNDATION_EXTERN NSString *const kAddPlaysSoundTraitToCustomTraitsElement;

/**
 *  Name of the action that adds OCRContrastCheck test view with no text.
 */
FOUNDATION_EXTERN NSString *const kAddContrastCheckTestViewWithNoText;

/**
 *  Name of the action that adds OCRContrastCheck test view with single word.
 */
FOUNDATION_EXTERN NSString *const kAddContrastCheckTestViewWithSingleWord;

/**
 *  Name of the action that adds OCRContrastCheck test view with multiple separated words.
 */
FOUNDATION_EXTERN NSString *const kAddContrastCheckTestViewWithMultipleWords;

/**
 *  Name of the action that adds low contrast OCRContrastCheck test view with single word.
 */
FOUNDATION_EXTERN NSString *const kAddContrastCheckTestViewWithLowContrastSingleWord;

/**
 *  Name of the action that adds low contrast OCRContrastCheck test view with multiple words (this
 * is low contrast due to one of words being low contrast).
 */
FOUNDATION_EXTERN NSString *const kAddContrastCheckTestViewWithLowContrastMultipleWords;

/**
 *  Name of the action that adds a test view with text and large color blocks.
 *
 *  This test view is useful for verifying if OCR check is able to locate text before contrast
 *  analysis, without OCR blocks become the dominant colors on the view.
 */
FOUNDATION_EXTERN NSString *const kAddContrastCheckTestViewWithLargeColorBlocks;

/**
 * Accessibility identifier for "clear test area" button.
 */
FOUNDATION_EXTERN NSString *const kGTXTestAppClearTestAreaID;

/**
 * Accessibility identifier for "Scroll to top" button.
 */
FOUNDATION_EXTERN NSString *const kGTXTestAppScrollToTopID;

/**
 * Accessibility identifier for the actions container view.
 */
FOUNDATION_EXTERN NSString *const kGTXTestAppActionsContainerID;

/**
 * Accessibility identifier for the testing area.
 */
FOUNDATION_EXTERN NSString *const kGTXTestTestingAreaID;

/**
 * Accessibility identifier for the added test element.
 */
FOUNDATION_EXTERN NSString *const kGTXTestTestingElementID;

/**
 * The number of elements in @c kGTXTestMultipleTestingElementsIDs.
 */
FOUNDATION_EXTERN const NSInteger kGTXTestMultipleTestingElementIDsCount;

/**
 * Accessibility identifiers of the elements added by the kAddMultipleElementsWithChildren action.
 */
FOUNDATION_EXTERN NSString *const kGTXTestMultipleTestingElementsIDs[4];

// The view controller for testing GTXiLib's Accessibility Checker.
@interface GTXTestViewController : UIViewController

/**
 Adds the given element to the Test App's test area.

 @param element Element to be added.
 */
+ (void)addElementToTestArea:(UIView *)element;

/**
 Clears the test area
 */
+ (void)clearTestArea;

/**
 Performs the named action.

 @param actionName The name of the action to be invoked.
 */
+ (void)performTestActionNamed:(NSString *)actionName;

@end
