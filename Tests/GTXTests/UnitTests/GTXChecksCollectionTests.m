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

#import "GTXTestDynamicTypeCheckOptions.h"

NSString *const kExpectedErrorDescription = @"Check \"Accessibility label punctuation\" failed";

/**
 * A view which responds to touches in a region defined by @c touchableRect, independent of @c frame
 * or @c accessibilityFrame.
 */
@interface GTXTestDynamicTouchView : UIView

/**
 * The region to respond to touches in, in this view's coordinate system.
 */
@property(assign, nonatomic) CGRect touchableRect;

@end

@implementation GTXTestDynamicTouchView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  return CGRectContainsPoint(self.touchableRect, point);
}

@end

@interface GTXChecksCollectionTests : XCTestCase
@end

@implementation GTXChecksCollectionTests

- (void)testAllGTXChecksForVersionExcludingChecksWithNamesNoExclusions {
  NSSet<NSString *> *excludedNames = [[NSSet alloc] init];
  NSArray<id<GTXChecking>> *checks = [GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest
                                                        excludingChecksWithNames:excludedNames];
  NSSet<NSString *> *actual = [self gtxtest_namesOfChecks:checks];
  NSSet<NSString *> *expected =
      [self gtxtest_namesOfChecks:[GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest]];
  XCTAssertEqualObjects(actual, expected);
}

- (void)testAllGTXChecksForVersionExcludingChecksWithNamesOneExclusion {
  NSSet<NSString *> *excludedNames = [[NSSet alloc]
      initWithArray:@[ [[GTXChecksCollection checkForSufficientContrastRatio] name] ]];
  NSArray<id<GTXChecking>> *checks = [GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest
                                                        excludingChecksWithNames:excludedNames];
  NSSet<NSString *> *actual = [self gtxtest_namesOfChecks:checks];
  NSSet<NSString *> *expected = [self gtxtest_namesOfChecks:@[
    [GTXChecksCollection checkForAXLabelPresent],
    [GTXChecksCollection checkForAXLabelNotPunctuated],
    [GTXChecksCollection checkForAXLabelNotRedundantWithTraits],
    [GTXChecksCollection checkForAXTraitDontConflict],
    [GTXChecksCollection checkForMinimumTappableArea],
    [GTXChecksCollection checkForSupportsDynamicType]
  ]];
  XCTAssertEqualObjects(actual, expected);
}

- (void)testAllGTXChecksForVersionExcludingChecksWithNamesManyExclusions {
  NSSet<NSString *> *excludedNames = [[NSSet alloc] initWithArray:@[
    [[GTXChecksCollection checkForSufficientContrastRatio] name],
    [[GTXChecksCollection checkForAXLabelNotPunctuated] name],
    [[GTXChecksCollection checkForSupportsDynamicType] name]
  ]];
  NSArray<id<GTXChecking>> *checks = [GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest
                                                        excludingChecksWithNames:excludedNames];
  NSSet<NSString *> *actual = [self gtxtest_namesOfChecks:checks];
  NSSet<NSString *> *expected = [self gtxtest_namesOfChecks:@[
    [GTXChecksCollection checkForAXLabelPresent],
    [GTXChecksCollection checkForAXLabelNotRedundantWithTraits],
    [GTXChecksCollection checkForAXTraitDontConflict],
    [GTXChecksCollection checkForMinimumTappableArea]
  ]];
  XCTAssertEqualObjects(actual, expected);
}

- (void)testAllGTXChecksForVersionExcludingChecksWithNamesAllExclusions {
  NSSet<NSString *> *excludedNames =
      [self gtxtest_namesOfChecks:[GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest]];
  NSArray<id<GTXChecking>> *checks = [GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest
                                                        excludingChecksWithNames:excludedNames];
  NSSet<NSString *> *actual = [self gtxtest_namesOfChecks:checks];
  NSSet<NSString *> *expected = [self gtxtest_namesOfChecks:@[]];
  XCTAssertEqualObjects(actual, expected);
}

- (void)testAllGTXChecksForVersionExcludingChecksWithNamesExclusionNotInChecks {
  NSSet<NSString *> *excludedNames = [[NSSet alloc] initWithArray:@[ @"nonexistent name" ]];
  XCTAssertThrows([GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest
                                     excludingChecksWithNames:excludedNames]);
}

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
  CGFloat exactlyValidSize = 44.0;
  CGFloat invalidSize = 16.0;
  CGRect validFrame = CGRectMake(0.0, 0.0, validSize, validSize);
  CGRect invalidFrame = CGRectMake(0.0, 0.0, invalidSize, invalidSize);
  CGRect validTouchableRect = CGRectMake(-validSize / 2.0, -validSize / 2.0, validSize, validSize);
  CGRect exactlyValidTouchableRect = CGRectMake(-exactlyValidSize / 2.0, -exactlyValidSize / 2.0,
                                                exactlyValidSize, exactlyValidSize);
  CGRect invalidTouchableRect =
      CGRectMake(-invalidSize / 2.0, -invalidSize / 2.0, invalidSize, invalidSize);
  // accessibilityFrame
  //
  // width and height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:YES
                   withElement:[self gtxtest_tappableUIAccessibilityElementWithFrame:validFrame]
              errorDescription:accessibilityFrameErrorDescription];
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableUIAccessibilityElementWithFrame:invalidFrame]
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
                   withElement:[self gtxtest_tappableViewWithFrame:validFrame]
              errorDescription:frameErrorDescription];
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:invalidFrame]
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
                   withElement:[self gtxtest_tappableViewWithFrame:validFrame
                                                accessibilityFrame:invalidFrame]
              errorDescription:accessibilityFrameErrorDescription];
  // width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:validFrame
                                                accessibilityFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)]
              errorDescription:accessibilityFrameErrorDescription];
  // width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:validFrame
                                                accessibilityFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)]
              errorDescription:accessibilityFrameErrorDescription];

  // frame (accessibilityFrame always valid)
  //
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:invalidFrame
                                                accessibilityFrame:validFrame]
              errorDescription:frameErrorDescription];
  // width valid, height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, validSize,
                                                                              invalidSize)
                                                accessibilityFrame:validFrame]
              errorDescription:frameErrorDescription];
  // width invalid, height valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:CGRectMake(0, 0, invalidSize,
                                                                              validSize)
                                                accessibilityFrame:validFrame]
              errorDescription:frameErrorDescription];

  // frame and accessibilityFrame both invalid
  //
  // width and height invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tappableViewWithFrame:invalidFrame
                                                accessibilityFrame:invalidFrame]
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

  // frame and accessibility frame invalid, pointInside:withEvent: valid.
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                    succeeds:YES
                 withElement:[self gtxtest_tabbableViewRespondingToTouchesInRect:validTouchableRect]
            errorDescription:nil];
  // frame and accessibility frame invalid, pointInside:withEvent: exactly valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:YES
                   withElement:[self gtxtest_tabbableViewRespondingToTouchesInRect:
                                         exactlyValidTouchableRect]
              errorDescription:nil];
  // frame, accessibility frame, and pointInside:withEvent: all invalid.
  [self
      gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                    succeeds:NO
                 withElement:[self
                                 gtxtest_tabbableViewRespondingToTouchesInRect:invalidTouchableRect]
            errorDescription:nil];
  // frame, accessibility frame, and pointInside:withEvent: all valid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:YES
                   withElement:[self gtxtest_tabbableViewRespondingToTouchesInRect:validFrame
                                                                             frame:validFrame
                                                                accessibilityFrame:validFrame]
              errorDescription:nil];
  // frame, accessibility frame valid, but pointInside:withEvent: invalid.
  [self gtxtest_assertGtxCheck:[GTXChecksCollection checkForMinimumTappableArea]
                      succeeds:NO
                   withElement:[self gtxtest_tabbableViewRespondingToTouchesInRect:invalidFrame
                                                                             frame:validFrame
                                                                accessibilityFrame:validFrame]
              errorDescription:nil];
}

- (void)testGtxCheckForSupportsDynamicType {
  id<GTXChecking> dynamicTypeCheck = [GTXChecksCollection checkForSupportsDynamicType];
  UIFont *fontFromPreferredFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  UIFont *fontFromFontWithName = [UIFont fontWithName:@"Arial" size:12.0];
  NSArray<GTXTestDynamicTypeCheckOptions *> *options = @[
    [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:nil
                       adjustsFontForContentSizeCategory:NO
                                                succeeds:NO],
    [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:nil
                       adjustsFontForContentSizeCategory:YES
                                                succeeds:NO],
    [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:fontFromPreferredFont
                       adjustsFontForContentSizeCategory:NO
                                                succeeds:NO],
    [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:fontFromPreferredFont
                       adjustsFontForContentSizeCategory:YES
                                                succeeds:YES],
    [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:fontFromFontWithName
                       adjustsFontForContentSizeCategory:NO
                                                succeeds:NO],
    [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:fontFromFontWithName
                       adjustsFontForContentSizeCategory:YES
                                                succeeds:NO],
  ];
  if (@available(iOS 11.0, *)) {
    UIFont *fontFromMetrics = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody]
        scaledFontForFont:fontFromFontWithName];
    options = [options arrayByAddingObjectsFromArray:@[
      [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:fontFromMetrics
                         adjustsFontForContentSizeCategory:NO
                                                  succeeds:NO],
      [[GTXTestDynamicTypeCheckOptions alloc] initWithFont:fontFromMetrics
                         adjustsFontForContentSizeCategory:YES
                                                  succeeds:YES],
    ]];
  }
  for (GTXTestDynamicTypeCheckOptions *option in options) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, 100, 44)];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 88, 100, 44)];
    label.adjustsFontForContentSizeCategory = option.adjustsFontForContentSizeCategory;
    textField.adjustsFontForContentSizeCategory = option.adjustsFontForContentSizeCategory;
    textView.adjustsFontForContentSizeCategory = option.adjustsFontForContentSizeCategory;
    if (option.font != nil) {
      label.font = option.font;
      textField.font = option.font;
      textView.font = option.font;
    }
    for (id element in @[ label, textField, textView ]) {
      [self gtxtest_assertGtxCheck:dynamicTypeCheck
                          succeeds:option.succeeds
                       withElement:element
                  errorDescription:nil];
    }
  }

  // Elements that don't implement font or adjustsFontForContentSizeCategory should be ignored, even
  // if they have the static traits text.
  UIAccessibilityElement *textElementWithoutProperties =
      [self gtxtest_uiAccessibilityElementWithTraits:UIAccessibilityTraitStaticText];
  [self gtxtest_assertGtxCheck:dynamicTypeCheck
                      succeeds:YES
                   withElement:textElementWithoutProperties
              errorDescription:nil];
}

#pragma mark - Private

- (NSSet<NSString *> *)gtxtest_namesOfChecks:(NSArray<id<GTXChecking>> *)checks {
  NSMutableSet<NSString *> *names = [[NSMutableSet alloc] init];
  for (id<GTXChecking> check in checks) {
    [names addObject:[check name]];
  }
  return names;
}

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
 * @return An accessible and tappable view responding to touches in @c rect. @c frame and
 *  @c accessibilityFrame have size 0.
 */
- (UIView *)gtxtest_tabbableViewRespondingToTouchesInRect:(CGRect)rect {
  CGRect centerRect = CGRectMake(CGRectGetMidX(rect), CGRectGetMidY(rect), 0, 0);
  return [self gtxtest_tabbableViewRespondingToTouchesInRect:rect
                                                       frame:centerRect
                                          accessibilityFrame:centerRect];
}

/**
 * @return An accessible and tabbable view whose touchable region, frame, and accessibility frame
 *  are set to the given values.
 */
- (UIView *)gtxtest_tabbableViewRespondingToTouchesInRect:(CGRect)rect
                                                    frame:(CGRect)frame
                                       accessibilityFrame:(CGRect)accessibilityFrame {
  GTXTestDynamicTouchView *view = [[GTXTestDynamicTouchView alloc] initWithFrame:frame];
  view.accessibilityFrame = accessibilityFrame;
  view.isAccessibilityElement = YES;
  view.accessibilityTraits = UIAccessibilityTraitButton;
  view.touchableRect = rect;
  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [window addSubview:view];
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
