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

#import "GTXiLib.h"
#import "GTXTestBaseTest.h"

@interface GTXTestGtxWithDefaultChecks : GTXTestBaseTest
@end

@implementation GTXTestGtxWithDefaultChecks {
  BOOL _expectErrors;
  BOOL _foundErrors;
}

+ (void)setUp {
  [super setUp];

  NSString *notRedundantCheckName =
      [[GTXChecksCollection checkForAXLabelNotRedundantWithTraits] name];
  NSArray<id<GTXExcludeListing>> *excludeLists =
      @[ [GTXExcludeListFactory excludeListWithAccessibilityIdentifier:kAddInaccessibleButton
                                                             checkName:notRedundantCheckName] ];
  NSMutableArray *checks =
      [NSMutableArray arrayWithArray:[GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest]];
  [checks addObject:[GTXChecksCollection checkForSufficientTextViewContrastRatio]];
  // Install all the default checks on the current test class.
  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:checks
          elementExcludeLists:excludeLists];
}

- (void)setUp {
  [super setUp];

  [GTXTestViewController clearTestArea];
  [self waitForAppEvents:kGTXDefaultAppEventsWaitTime];

  // Set up failure handler to simple detect if errors were found.
  _expectErrors = NO;
  _foundErrors = NO;
  [GTXiLib setFailureHandler:^(NSError *_Nonnull error) {
    _foundErrors = YES;
  }];
}

- (void)tearDown {
  XCTAssertEqual(_expectErrors, _foundErrors);

  [super tearDown];
}

- (void)testNoLabelElementsCauseFailures {
  [self performTestActionNamed:kAddNoLabelElementActionName];
  _expectErrors = YES;
}

- (void)testNonpunctuatedLabelsDoesNotCauseFailures {
  [self performTestActionNamed:kAddNonpunctuatedLabelElementActionName];
  _expectErrors = NO;
}

- (void)testPunctuatedLabelsCauseFailures {
  [self performTestActionNamed:kAddPunctuatedLabelElementActionName];
  _expectErrors = YES;
}

- (void)testDefaultKeyboardDoesNotCauseFailures {
  [self performTestActionNamed:kShowKeyboardActionName];
  [self waitForAppEvents:1.0];
  _expectErrors = NO;
}

- (void)testButtonsMarkedInaccessibleAreSkippedByDefault {
  [self performTestActionNamed:kAddInaccessibleButton];
  _expectErrors = NO;
}

- (void)testAccessibleButtonsInsideContainersDoesNotCauseFailures {
  [self performTestActionNamed:kAddAccessibleButtonInContainer];
  _expectErrors = NO;
}

- (void)testTinyTappableAreasCauseErrors {
  [self performTestActionNamed:kAddTinyTappableElement];
  _expectErrors = YES;
}

- (void)testLowContrastLabelsCauseErrors {
  [self performTestActionNamed:kAddVeryLowContrastLabel];
  _expectErrors = YES;
}

- (void)testBarelyContrastLabelsCauseErrors {
  [self performTestActionNamed:kAddBarelyLowContrastLabel];
  _expectErrors = YES;
}

- (void)testHighContrastLabelsDoesNotCauseFailures {
  [self performTestActionNamed:kAddVeryHighContrastLabel];
  _expectErrors = NO;
}

- (void)testBarelyHighContrastLabelsDoesNotCauseFailures {
  [self performTestActionNamed:kAddBarelyHighContrastLabel];
  _expectErrors = NO;
}

- (void)testNoContrastLabelsCauseErrors {
  [self performTestActionNamed:kAddNoContrastLabel];
  _expectErrors = YES;
}

- (void)testTransparentHighContrastLabelDoesNotCauseFailures {
  [self performTestActionNamed:kAddTransparentHighContrastLabel];
  _expectErrors = NO;
}

- (void)testTransparentLowContrastLabelsCauseError {
  [self performTestActionNamed:kAddTransparentLowContrastLabel];
  _expectErrors = YES;
}

- (void)testLowContrastTextViewCausesErrors {
  [self performTestActionNamed:kAddLowContrastTextView];
  _expectErrors = YES;
}

- (void)testStandardContrastTextViewDoesNotCauseFailures {
  [self performTestActionNamed:kAddStandardUIKitTextView];
  _expectErrors = NO;
}

- (void)testLabelWithFontWithNameCausesErrors {
  [self performTestActionNamed:kAddLabelWithFontWithName];
  _expectErrors = YES;
}

- (void)testLabelWithPreferredFontForTextStyleDoesNotCauseFailures {
  [self performTestActionNamed:kAddLabelWithPreferredFontForTextStyle];
  _expectErrors = NO;
}

- (void)testLabelWithFontMetricsDoesNotCauseFailures {
  // This test is a no-op when UIFontMetrics doesn't exist, so there are no errors either way.
  [self performTestActionNamed:kAddLabelWithFontMetrics];
  _expectErrors = NO;
}

- (void)testTextViewWithFontWithNameCausesErrors {
  [self performTestActionNamed:kAddTextViewWithFontWithName];
  _expectErrors = YES;
}

- (void)testTextViewWithPreferredFontForTextStyleDoesNotCauseFailures {
  [self performTestActionNamed:kAddTextViewWithPreferredFontForTextStyle];
  _expectErrors = NO;
}

- (void)testTextViewWithFontMetricsDoesNotCauseFailures {
  // This test is a no-op when UIFontMetrics doesn't exist, so there are no errors either way.
  [self performTestActionNamed:kAddTextViewWithFontMetrics];
  _expectErrors = NO;
}

@end
