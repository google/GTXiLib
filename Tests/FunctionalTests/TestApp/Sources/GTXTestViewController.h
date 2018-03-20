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
 *  Name of the action that adds an element with very high contrast.
 */
FOUNDATION_EXTERN NSString *const kAddVeryHighContrastLabel;

/**
 *  Name of the action that adds an element with very low contrast.
 */
FOUNDATION_EXTERN NSString *const kAddVeryLowContrastLabel;

/**
 *  Name of the action that adds an element with barely high contrast.
 */
FOUNDATION_EXTERN NSString *const kAddBarelyHighContrastLabel;

/**
 *  Name of the action that adds an element with barely low contrast.
 */
FOUNDATION_EXTERN NSString *const kAddBarelyLowContrastLabel;

/**
 *  Name of the action that adds a low contrast background.
 */
FOUNDATION_EXTERN NSString *const kAddLowContrastBackground;

/**
 *  Name of the action that adds a high contrast background.
 */
FOUNDATION_EXTERN NSString *const kAddHighContrastBackground;

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
