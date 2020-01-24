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
#import <XCTest/XCTest.h>

#import "GTXChecksCollection.h"

NSString *const kExpectedErrorDescription = @"Check \"Accessibility label punctuation\" failed";

@interface GTXChecksCollectionTests : XCTestCase
@end

@implementation GTXChecksCollectionTests

- (void)testGtxCheckForAXLabelNotPunctuated {
  // Valid label.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"foo"]
              errorDescription:nil];
  // Empty label.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@""]
              errorDescription:nil];
  // nil label.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:nil]
              errorDescription:nil];
  // Label ending in period.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"foo."]
              errorDescription:kExpectedErrorDescription];
  // Label ending in period with trailing space.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"foo. "]
              errorDescription:kExpectedErrorDescription];
  // Single character label ending in period.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"f."]
              errorDescription:kExpectedErrorDescription];
  // Single character label with just period.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"."]
              errorDescription:kExpectedErrorDescription];
  // UILabel with text ending in period must pass.
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
  label.text = @"foo.";
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:YES
                   withElement:label
              errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelNotPunctuatedWorksWithAttributedStrings {
  id accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo"];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:accessibilityLabel]
              errorDescription:nil];

  accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo."];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:accessibilityLabel]
              errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelNotPunctuatedWorksWithMutableStrings {
  id accessibilityLabel = [NSMutableString stringWithString:@"foo"];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:accessibilityLabel]
              errorDescription:nil];

  accessibilityLabel = [NSMutableString stringWithString:@"foo."];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:accessibilityLabel]
              errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelPresent {
  NSString *const expectedErrorDescription = @"Check \"Accessibility label\" failed";
  // Valid label.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"foo"]
              errorDescription:nil];
  // Label with just space.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@" "]
              errorDescription:expectedErrorDescription];
  // Empty string label.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@""]
              errorDescription:expectedErrorDescription];
  // Element with no label.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:nil]
              errorDescription:expectedErrorDescription];
}

- (void)testGtxCheckForAXLabelPresentWorksForTextElementsWithNotText {
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:[[UILabel alloc] initWithFrame:CGRectZero]
              errorDescription:nil];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:[[UITextField alloc] initWithFrame:CGRectZero]
              errorDescription:nil];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:[[UITextView alloc] initWithFrame:CGRectZero]
              errorDescription:nil];
  UIAccessibilityElement *textElement = [self gtxtest_uiAccessibilityElementWithLabel:@""];
  textElement.accessibilityTraits = UIAccessibilityTraitStaticText;
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:textElement
              errorDescription:nil];
}

- (void)testGtxCheckForAXLabelPresentWorksForAccessibilityElementsContainedInUITextField {
  UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
  textField.text = @"foo";
  for (id element in textField.accessibilityElements) {
    [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                        succeeds:YES
                     withElement:element
                errorDescription:nil];
  }
}

- (void)testGtxCheckForAXLabelPresentWorksWithAttributedStrings {
  id accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo"];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:accessibilityLabel]
              errorDescription:nil];
}

- (void)testGtxCheckForAXLabelPresentWorksWithMutableStrings {
  id accessibilityLabel = [NSMutableString stringWithString:@"foo"];
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:accessibilityLabel]
              errorDescription:nil];
}

- (void)testGtxCheckForAXLabelNotRedundantWithTraits {
  // Label is not redundant with traits.
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                    succeeds:YES
                 withElement:[self
                                 gtxtest_uiAccessibilityElementWithLabel:@"foo"
                                                                  traits:UIAccessibilityTraitButton]
            errorDescription:nil];
  // Label is redundant with traits (uppercase).
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                    succeeds:NO
                 withElement:[self
                                 gtxtest_uiAccessibilityElementWithLabel:@"FOO BUTTON"
                                                                  traits:UIAccessibilityTraitButton]
            errorDescription:nil];
  // Label is redundant with traits (lowercase).
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                    succeeds:NO
                 withElement:[self
                                 gtxtest_uiAccessibilityElementWithLabel:@"foo button"
                                                                  traits:UIAccessibilityTraitButton]
            errorDescription:nil];
  // Label is not redundant with traits (not suffix).
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                    succeeds:YES
                 withElement:[self
                                 gtxtest_uiAccessibilityElementWithLabel:@"button foo"
                                                                  traits:UIAccessibilityTraitButton]
            errorDescription:nil];
  // Empty label (not redundant).
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                    succeeds:YES
                 withElement:[self
                                 gtxtest_uiAccessibilityElementWithLabel:@""
                                                                  traits:UIAccessibilityTraitButton]
            errorDescription:nil];
  // Whitespace label (not redundant).
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                    succeeds:YES
                 withElement:[self
                                 gtxtest_uiAccessibilityElementWithLabel:@" "
                                                                  traits:UIAccessibilityTraitButton]
            errorDescription:nil];
  // No traits or violating label (not redundant).
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"foo"]
              errorDescription:nil];
  // No traits (not redundant).
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                      succeeds:YES
                   withElement:[self gtxtest_uiAccessibilityElementWithLabel:@"foo button"]
              errorDescription:nil];
  // Wrong traits (not redundant).
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
                      succeeds:YES
                   withElement:
                       [self gtxtest_uiAccessibilityElementWithLabel:@"foo button"
                                                              traits:UIAccessibilityTraitStaticText]
              errorDescription:nil];
}

- (void)testGtxCheckForAXTraitsConflict {
  NSString *const expectedErrorDescription = @"Check \"Accessibility traits\" failed";
  // Check for a valid trait (in valid range, no conflict).
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                      succeeds:YES
                   withElement:
                       [self gtxtest_uiAccessibilityElementWithTraits:UIAccessibilityTraitButton]
              errorDescription:nil];
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                    succeeds:YES
                 withElement:[self gtxtest_uiAccessibilityElementWithTraits:
                                       (UIAccessibilityTraitLink | UIAccessibilityTraitAdjustable)]
            errorDescription:nil];
  // Check for conflict rule no.1 (conflict among button, link, search field, keyboard key).
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithTraits:
                                         (UIAccessibilityTraitKeyboardKey |
                                          UIAccessibilityTraitSearchField)]
              errorDescription:expectedErrorDescription];
  // Check for conflict rule no.2 (conflict between button and adjustable (slider)).
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                      succeeds:NO
                   withElement:[self gtxtest_uiAccessibilityElementWithTraits:
                                         (UIAccessibilityTraitAdjustable |
                                          UIAccessibilityTraitButton)]
              errorDescription:expectedErrorDescription];
}

- (void)testGtxCheckForMinimumTappableArea {
  NSString *accessibilityFrameErrorDescription = @"Element accessibilityFrame:";
  NSString *frameErrorDescription = @"Element frame:";
  CGFloat validSize = 64.0;
  CGFloat invalidSize = 16.0;

  // accessibilityFrame
  //
  // width and height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:YES
                   withElement:[self gtxtest_tappableUIAccessibilityElementWithFrame:CGRectMake(
                                                                                         0, 0,
                                                                                         validSize,
                                                                                         validSize)]
              errorDescription:accessibilityFrameErrorDescription];
  // width and height invalid.
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                    succeeds:NO
                 withElement:[self gtxtest_tappableUIAccessibilityElementWithFrame:CGRectMake(
                                                                                       0, 0,
                                                                                       invalidSize,
                                                                                       invalidSize)]
            errorDescription:accessibilityFrameErrorDescription];
  // width valid, height invalid.
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                    succeeds:NO
                 withElement:[self gtxtest_tappableUIAccessibilityElementWithFrame:CGRectMake(
                                                                                       0, 0,
                                                                                       validSize,
                                                                                       invalidSize)]
            errorDescription:accessibilityFrameErrorDescription];
  // width invalid, height valid.
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                    succeeds:NO
                 withElement:[self gtxtest_tappableUIAccessibilityElementWithFrame:CGRectMake(
                                                                                       0, 0,
                                                                                       invalidSize,
                                                                                       validSize)]
            errorDescription:accessibilityFrameErrorDescription];

  // frame
  //
  // width and height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:YES
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)]
              errorDescription:frameErrorDescription];
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              invalidSize)]
              errorDescription:frameErrorDescription];
  // width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)]
              errorDescription:frameErrorDescription];
  // width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)]
              errorDescription:frameErrorDescription];

  // accessibilityFrame (frame always valid)
  //
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)
                                                accessibilityFrame:CGRectMake(0, 0, invalidSize,
                                                                              invalidSize)]
              errorDescription:accessibilityFrameErrorDescription];
  // width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)]
              errorDescription:accessibilityFrameErrorDescription];
  // width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)
                                                accessibilityFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)]
              errorDescription:accessibilityFrameErrorDescription];

  // frame (accessibilityFrame always valid)
  //
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              invalidSize)
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)]
              errorDescription:frameErrorDescription];
  // width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)]
              errorDescription:frameErrorDescription];
  // width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              validSize)]
              errorDescription:frameErrorDescription];

  // frame and accessibilityFrame both invalid
  //
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              invalidSize)
                                                accessibilityFrame:CGRectMake(0, 0, invalidSize,
                                                                              invalidSize)]
              errorDescription:nil];
  // width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)]
              errorDescription:nil];
  // width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)
                                                accessibilityFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)]
              errorDescription:nil];
  // frame width valid, height invalid. accessibilityFrame width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)
                                                accessibilityFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)]
              errorDescription:nil];
  // frame width invalid, height valid. accessibilityFrame width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)]
              errorDescription:nil];
}

#pragma mark - Private

/**
 *  @return An accessibility element whose accessibility label is set to the specified @c label.
 */
- (UIAccessibilityElement *)gtxtest_uiAccessibilityElementWithLabel:(id)label {
  NSAssert(!label || [label isKindOfClass:[NSString class]] ||
               [label isKindOfClass:[NSAttributedString class]],
           @"Provided label must be a NSString or NSAttributedString object.");
  NSObject *container = [[NSObject alloc] init];
  UIAccessibilityElement *element =
      [[UIAccessibilityElement alloc] initWithAccessibilityContainer:container];
  element.accessibilityLabel = label;
  return element;
}

/**
 *  @return An accessibility element whose accessibility trait is set to the specified traits.
 */
- (UIAccessibilityElement *)gtxtest_uiAccessibilityElementWithTraits:(UIAccessibilityTraits)traits {
  NSObject *container = [[NSObject alloc] init];
  UIAccessibilityElement *element =
      [[UIAccessibilityElement alloc] initWithAccessibilityContainer:container];
  element.accessibilityTraits = traits;
  return element;
}

/**
 *  @return An accessibility element whose accessibility label is set to the specified @c label
 *  and accessibility trait is set to the specified @c traits.
 */
- (UIAccessibilityElement *)gtxtest_uiAccessibilityElementWithLabel:(id)label
                                                             traits:(UIAccessibilityTraits)traits {
  UIAccessibilityElement *element = [self gtxtest_uiAccessibilityElementWithLabel:label];
  element.accessibilityTraits = traits;
  return element;
}

/**
 *  @return An accessible and tappable view whose frame and accessibility frame are set to @c frame.
 */
- (UIView *)gtxtest_tappableViewWithFrame:(CGRect)frame {
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.isAccessibilityElement = YES;
  view.accessibilityFrame = frame;
  // The view must have UIAccessibilityTraitButton or else it cannot be tapped.
  view.accessibilityTraits = UIAccessibilityTraitButton;
  // Views without windows are ignored because they should not be part of the view hierarchy.
  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [window addSubview:view];
  return view;
}

/**
 *  @return An accessible and tappable view whose frame is set to @c frame and accessibility frame
 * is set to @c accessibilityFrame.
 */
- (UIView *)gtxtest_tappableViewWithFrame:(CGRect)frame
                       accessibilityFrame:(CGRect)accessibilityFrame {
  UIView *view = [self gtxtest_tappableViewWithFrame:frame];
  view.accessibilityFrame = accessibilityFrame;
  return view;
}

/**
 *  @return A tappable accessibility element whose accessibility frame is set to @c frame.
 */
- (UIAccessibilityElement *)gtxtest_tappableUIAccessibilityElementWithFrame:(CGRect)frame {
  // The element must have UIAccessibilityTraitButton or else it cannot be tapped.
  UIAccessibilityElement *element =
      [self gtxtest_uiAccessibilityElementWithTraits:UIAccessibilityTraitButton];
  element.accessibilityFrame = frame;
  return element;
}

/**
 *  Asserts that the given GTXCheck succeeds or fails with the specified element.
 *
 *  @param check            The check to be tested.
 *  @param expectedSuccess  A BOOL indicating if the check must succeed or not.
 *  @param element          The element on which to apply the check.
 *  @param descriptionOrNil An optional expected error description if the check is expected to fail
 *                          and the error description must also be verified.
 */
- (void)gtxtest_assertGtxCheck:(id<GTXChecking>)gtxCheck
                      succeeds:(BOOL)expectedSuccess
                   withElement:(id)element
              errorDescription:(nullable NSString *)descriptionOrNil {
  NSError *error = nil;
  BOOL success = [gtxCheck check:element error:&error];
  XCTAssertEqual(success, expectedSuccess);
  if (expectedSuccess) {
    XCTAssertNil(error);
  } else {
    XCTAssertNotNil(error);
    if (descriptionOrNil != nil) {
      XCTAssertTrue([[error description] containsString:descriptionOrNil],
                    @"[Expected] was not present in [Actual]!\n Expected: %@\n Actual: %@",
                    descriptionOrNil, [error description]);
    }
  }
}

@end
