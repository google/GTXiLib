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

NSString * const kExpectedErrorDescription = @"Check \"Accessibility Label Not Punctuated\" failed";

@interface GTXChecksCollectionTests : XCTestCase
@end

@implementation GTXChecksCollectionTests

- (void)testGtxCheckForAXLabelNotPunctuated {
  // Valid label.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:@"foo"]
           errorDescription:nil];
  // Empty label.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:@""]
           errorDescription:nil];
  // nil label.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:nil]
           errorDescription:nil];
  // Label ending in period.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"foo."]
           errorDescription:kExpectedErrorDescription];
  // Label ending in period with trailing space.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"foo. "]
           errorDescription:kExpectedErrorDescription];
  // Single character label ending in period.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"f."]
           errorDescription:kExpectedErrorDescription];
  // Single character label with just period.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"."]
           errorDescription:kExpectedErrorDescription];
  // UILabel with text ending in period must pass.
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
  label.text = @"foo.";
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:YES
                withElement:label
           errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelNotPunctuatedWorksWithAttributedStrings {
  id accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo"];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];

  accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo."];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelNotPunctuatedWorksWithMutableStrings {
  id accessibilityLabel = [NSMutableString stringWithString:@"foo"];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];

  accessibilityLabel = [NSMutableString stringWithString:@"foo."];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelPresent {
  NSString * const expectedErrorDescription = @"Check \"Accessibility Label Present\" failed";
  // Valid label.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:@"foo"]
           errorDescription:nil];
  // Label with just space.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@" "]
           errorDescription:expectedErrorDescription];
  // Empty string label.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@""]
           errorDescription:expectedErrorDescription];
  // Element with no label.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:nil]
           errorDescription:expectedErrorDescription];
}

- (void)testGtxCheckForAXLabelPresentWorksForTextElementsWithNotText {
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:[[UILabel alloc] initWithFrame:CGRectZero]
           errorDescription:nil];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:[[UITextField alloc] initWithFrame:CGRectZero]
           errorDescription:nil];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:[[UITextView alloc] initWithFrame:CGRectZero]
           errorDescription:nil];
  UIAccessibilityElement *textElement = [self uiAccessibilityElementWithLabel:@""];
  textElement.accessibilityTraits = UIAccessibilityTraitStaticText;
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:textElement
           errorDescription:nil];
}

- (void)testGtxCheckForAXLabelPresentWorksWithAttributedStrings {
  id accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo"];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];
}

- (void)testGtxCheckForAXLabelPresentWorksWithMutableStrings {
  id accessibilityLabel = [NSMutableString stringWithString:@"foo"];
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelPresent]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];
}

- (void)testGtxCheckForAXLabelNotRedundantWithTraits {
  // Label is not redundant with traits.
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@"foo"
                                                      traits:UIAccessibilityTraitButton]
      errorDescription:nil];
  // Label is redundant with traits (uppercase).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:NO
           withElement:[self uiAccessibilityElementWithLabel:@"FOO BUTTON"
                                                      traits:UIAccessibilityTraitButton]
      errorDescription:nil];
  // Label is redundant with traits (lowercase).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:NO
           withElement:[self uiAccessibilityElementWithLabel:@"foo button"
                                                      traits:UIAccessibilityTraitButton]
      errorDescription:nil];
  // Label is not redundant with traits (not suffix).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@"button foo"
                                                      traits:UIAccessibilityTraitButton]
      errorDescription:nil];
  // Empty label (not redundant).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@""
                                                      traits:UIAccessibilityTraitButton]
      errorDescription:nil];
  // Whitespace label (not redundant).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@" "
                                                      traits:UIAccessibilityTraitButton]
      errorDescription:nil];
  // No traits or violating label (not redundant).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@"foo"]
      errorDescription:nil];
  // No traits (not redundant).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@"foo button"]
      errorDescription:nil];
  // Wrong traits (not redundant).
  [self assertGtxCheck:[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
              succeeds:YES
           withElement:[self uiAccessibilityElementWithLabel:@"foo button"
                                                      traits:UIAccessibilityTraitStaticText]
      errorDescription:nil];
}

- (void)testGtxCheckForAXTraitsConflict {
  NSString * const expectedErrorDescription =
      @"Check \"Accessibility Traits Don't Conflict\" failed";
  // Check for a valid trait (in valid range, no conflict).
  [self assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithTraits:UIAccessibilityTraitButton]
           errorDescription:nil];
  [self assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithTraits:
                             (UIAccessibilityTraitLink | UIAccessibilityTraitAdjustable)]
           errorDescription:nil];
  // Check for conflict rule no.1 (conflict among button, link, search field, keyboard key).
  [self assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithTraits:
                             (UIAccessibilityTraitKeyboardKey | UIAccessibilityTraitSearchField)]
           errorDescription:expectedErrorDescription];
  // Check for conflict rule no.2 (conflict between button and adjustable (slider)).
  [self assertGtxCheck:[GTXChecksCollection checkForAXTraitDontConflict]
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithTraits:
                             (UIAccessibilityTraitAdjustable | UIAccessibilityTraitButton)]
           errorDescription:expectedErrorDescription];
}

#pragma mark - Private

/**
 *  @return An accessibility element whose accessibility label is set to the specified @c label.
 */
- (UIAccessibilityElement *)uiAccessibilityElementWithLabel:(id)label {
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
- (UIAccessibilityElement *)uiAccessibilityElementWithTraits:(UIAccessibilityTraits)traits {
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
- (UIAccessibilityElement *)uiAccessibilityElementWithLabel:(id)label
                                                     traits:(UIAccessibilityTraits)traits {
  UIAccessibilityElement *element = [self uiAccessibilityElementWithLabel:label];
  element.accessibilityTraits = traits;
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
- (void)assertGtxCheck:(id<GTXChecking>)gtxCheck
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
