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
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:@"foo"]
           errorDescription:nil];
  // Empty label.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:@""]
           errorDescription:nil];
  // nil label.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:nil]
           errorDescription:nil];
  // Label ending in period.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"foo."]
           errorDescription:kExpectedErrorDescription];
  // Label ending in period with trailing space.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"foo. "]
           errorDescription:kExpectedErrorDescription];
  // Single character label ending in period.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"f."]
           errorDescription:kExpectedErrorDescription];
  // Single character label with just period.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@"."]
           errorDescription:kExpectedErrorDescription];
  // UILabel with text ending in period must pass.
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
  label.text = @"foo.";
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:YES
                withElement:label
           errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelNotPunctuatedWorksWithAttributedStrings {
  id accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo"];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];

  accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo."];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelNotPunctuatedWorksWithMutableStrings {
  id accessibilityLabel = [NSMutableString stringWithString:@"foo"];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];

  accessibilityLabel = [NSMutableString stringWithString:@"foo."];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelNotPunctuated
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:kExpectedErrorDescription];
}

- (void)testGtxCheckForAXLabelPresent {
  NSString * const expectedErrorDescription = @"Check \"Accessibility Label Present\" failed";
  // Valid label.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:@"foo"]
           errorDescription:nil];
  // Label with just space.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@" "]
           errorDescription:expectedErrorDescription];
  // Empty string label.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:@""]
           errorDescription:expectedErrorDescription];
  // Element with no label.
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithLabel:nil]
           errorDescription:expectedErrorDescription];
}

- (void)testGtxCheckForAXLabelPresentWorksForTextElementsWithNotText {
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:[[UILabel alloc] initWithFrame:CGRectZero]
           errorDescription:nil];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:[[UITextField alloc] initWithFrame:CGRectZero]
           errorDescription:nil];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:[[UITextView alloc] initWithFrame:CGRectZero]
           errorDescription:nil];
  UIAccessibilityElement *textElement = [self uiAccessibilityElementWithLabel:@""];
  textElement.accessibilityTraits = UIAccessibilityTraitStaticText;
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:textElement
           errorDescription:nil];
}

- (void)testGtxCheckForAXLabelPresentWorksWithAttributedStrings {
  id accessibilityLabel = [[NSAttributedString alloc] initWithString:@"foo"];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];
}

- (void)testGtxCheckForAXLabelPresentWorksWithMutableStrings {
  id accessibilityLabel = [NSMutableString stringWithString:@"foo"];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityLabelPresent
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithLabel:accessibilityLabel]
           errorDescription:nil];
}

- (void)testGtxCheckForAXTraitsConflict {
  NSString * const expectedErrorDescription =
      @"Check \"Accessibility Traits Don't Conflict\" failed";
  // Check for a valid trait (in valid range, no conflict).
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityTraitsDontConflict
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithTraits:UIAccessibilityTraitButton]
           errorDescription:nil];
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityTraitsDontConflict
                   succeeds:YES
                withElement:[self uiAccessibilityElementWithTraits:
                             (UIAccessibilityTraitLink | UIAccessibilityTraitAdjustable)]
           errorDescription:nil];
  // Check for conflict rule no.1 (conflict among button, link, search field, keyboard key).
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityTraitsDontConflict
                   succeeds:NO
                withElement:[self uiAccessibilityElementWithTraits:
                             (UIAccessibilityTraitKeyboardKey | UIAccessibilityTraitSearchField)]
           errorDescription:expectedErrorDescription];
  // Check for conflict rule no.2 (conflict between button and adjustable (slider)).
  [self assertGtxCheckNamed:kGTXCheckNameAccessibilityTraitsDontConflict
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
 *  Asserts that the named GTXCheck succeeds or fails with the specified element.
 *
 *  @param name             The name of the check.
 *  @param expectedSuccess  A BOOL indicating if the check must succeed or not.
 *  @param element          The element on which to apply the check.
 *  @param descriptionOrNil An optional expected error description if the check is expected to fail
 *                          and the error description must also be verified.
 */
- (void)assertGtxCheckNamed:(NSString *)name
                   succeeds:(BOOL)expectedSuccess
                withElement:(id)element
           errorDescription:(nullable NSString *)descriptionOrNil {
  id<GTXChecking> gtxCheck = [GTXChecksCollection GTXCheckWithName:name];
  NSError *error = nil;
  BOOL success = [gtxCheck check:element error:&error];
  XCTAssertEqual(success, expectedSuccess);
  if (expectedSuccess) {
    XCTAssertNil(error);
  } else {
    XCTAssertNotNil(error);
    XCTAssertTrue([[error description] containsString:descriptionOrNil],
                  @"%@ was not present in %@", descriptionOrNil, [error description]);
  }
}

@end
