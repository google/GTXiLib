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

#import "GTXTestBaseTest.h"
#import "GTXiLib.h"

@interface GTXTestGtxWithDefaultChecks : GTXTestBaseTest
@end

@implementation GTXTestGtxWithDefaultChecks {
  BOOL _expectErrors;
  BOOL _foundErrors;
}

+ (void)setUp {
  [super setUp];

  NSString *notRedundantCheckName = [[GTXChecksCollection checkForAXLabelNotRedundantWithTraits]
      name];
  NSArray<id<GTXBlacklisting>> *blacklists = @[
    [GTXBlacklistFactory blacklistWithAccessibilityIdentifier:kAddInaccessibleButton
                                                    checkName:notRedundantCheckName]
  ];
  // Install all the default checks on the current test class.
  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:[GTXChecksCollection allGTXChecks]
            elementBlacklists:blacklists];
}

- (void)setUp {
  [super setUp];

  [GTXTestViewController clearTestArea];
  [self _waitForAppEvents:0.5];

  // Set up failure handler to simple detect if errors were found.
  _expectErrors = NO;
  _foundErrors = NO;
  [GTXiLib setFailureHandler:^(NSError * _Nonnull error) {
    _foundErrors = YES;
  }];
}

- (void)tearDown {
  XCTAssertEqual(_expectErrors, _foundErrors);

  [super tearDown];
}

- (void)testNoLableElementsCauseFailures {
  [self _performTestActionNamed:kAddNoLabelElementActionName];
  _expectErrors = YES;
}

- (void)testPunctuatedLablesCauseFailures {
  [self _performTestActionNamed:kAddPunctuatedLabelElementActionName];
  _expectErrors = YES;
}

- (void)testDefaultKeyboardDoesNotCauseFailures {
  [self _performTestActionNamed:kShowKeyboardActionName];
  [self _waitForAppEvents:1.0];
  _expectErrors = NO;
}

- (void)testButtonsMarkedInaccessibleAreSkippedByDefault {
  [self _performTestActionNamed:kAddInaccessibleButton];
  _expectErrors = NO;
}

- (void)testAccessibleButtonsInsideContainersDoesNotCauseFailures {
  [self _performTestActionNamed:kAddAccessibleButtonInContainer];
  _expectErrors = NO;
}

- (void)testTinyTappableAreasCauseErrors {
  [self _performTestActionNamed:kAddTinyTappableElement];
  _expectErrors = YES;
}

- (void)testLowContrastElementsCauseErrors {
  [self _performTestActionNamed:kAddVeryLowContrastLabel];
  _expectErrors = YES;
}

- (void)testBarelyContrastElementsCauseErrors {
  [self _performTestActionNamed:kAddBarelyLowContrastLabel];
  _expectErrors = YES;
}

- (void)testHighContrastElementsDoesNotCauseFailures {
  [self _performTestActionNamed:kAddVeryHighContrastLabel];
  _expectErrors = NO;
}

- (void)testBarelyHighContrastElementsDoesNotCauseFailures {
  [self _performTestActionNamed:kAddBarelyHighContrastLabel];
  _expectErrors = NO;
}

#pragma mark - private

/**
 Performs the provided test action on the test app and waits for its completion.
 */
- (void)_performTestActionNamed:(NSString *)testAction {
  [GTXTestViewController performTestActionNamed:testAction];
  [self _waitForAppEvents:0.5];
}

/**
 Waits given time interval for any app events to be processed.
 */
- (void)_waitForAppEvents:(NSTimeInterval)seconds {
  NSTimeInterval start = CACurrentMediaTime();
  while (CACurrentMediaTime() - start < seconds) {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, false);
  }
}

@end
