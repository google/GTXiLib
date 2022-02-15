//
// Copyright 2020 Google Inc.
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

#import "GTXTestIntegrationTestCase.h"

@interface GTXTestXCUIElementTests : GTXTestIntegrationTestCase
@end

@implementation GTXTestXCUIElementTests

- (void)testNoLabelCheck {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddNoLabelElementActionName];
  XCTAssertFalse([self runAllGTXChecksOnTestElement]);
}

- (void)testMinimumTappableAreaCheck {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddTinyTappableElement];
  XCTAssertFalse([self runAllGTXChecksOnTestElement]);
}

- (void)testContrastCheckWithHighContrastLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddVeryHighContrastLabel];
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
}

- (void)testContrastCheckWithLowContrastLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddVeryLowContrastLabel];
  XCTAssertFalse([self runAllGTXChecksOnTestElement]);
}

- (void)testContrastCheckWithBarelyHighContrastLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddBarelyHighContrastLabel];
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
}

- (void)testContrastCheckWithBarelyLowContrastLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddBarelyLowContrastLabel];
  XCTAssertFalse([self runAllGTXChecksOnTestElement]);
}

- (void)testAccessibilityLabelNotPunctuatedCheckWithNonpunctuatedLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddNonpunctuatedLabelElementActionName];
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
}

- (void)testAccessibilityLabelNotPunctuatedCheckWithPunctuatedLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddPunctuatedLabelElementActionName];
  XCTAssertFalse([self runAllGTXChecksOnTestElement]);
}

- (void)testAccessibilityLabelNotPunctuatedCheckWithConcatenatedLabel {
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
  [self performTestActionNamed:kAddConcatenatedLabelElementActionName];
  XCTAssertTrue([self runAllGTXChecksOnTestElement]);
}

@end
