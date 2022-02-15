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

@interface GTXTestGtxWithOCRContrastCheck : GTXTestBaseTest
@end

@implementation GTXTestGtxWithOCRContrastCheck

- (void)setUp {
  [super setUp];

  [GTXTestViewController clearTestArea];
  [self waitForAppEvents:kGTXDefaultAppEventsWaitTime];
}

- (void)testOCRContrastCheckIgnoresNonTextAreas {
  if (@available(iOS 11.0, *)) {
    [self performTestActionNamed:kAddContrastCheckTestViewWithNoText];
    [self gtxtest_verifyOCRCheckWithExpectedFailures:NO];
  }
}

- (void)testOCRContrastCheckVerifiesTextWithOneWord {
  if (@available(iOS 11.0, *)) {
    [self performTestActionNamed:kAddContrastCheckTestViewWithSingleWord];
    [self gtxtest_verifyOCRCheckWithExpectedFailures:NO];
  }
}

- (void)testOCRContrastCheckVerifiesTextWithMultipleSeparatedWord {
  if (@available(iOS 11.0, *)) {
    [self performTestActionNamed:kAddContrastCheckTestViewWithMultipleWords];
    [self gtxtest_verifyOCRCheckWithExpectedFailures:NO];
  }
}

- (void)testOCRContrastChecksPassesHighContrastTextWithLowContrastDominantOtherColors {
  if (@available(iOS 11.0, *)) {
    [self performTestActionNamed:kAddContrastCheckTestViewWithLargeColorBlocks];
    [self gtxtest_verifyOCRCheckWithExpectedFailures:NO];
  }
}

- (void)testOCRContrastCheckFailsLowContrastSingleWordText {
  if (@available(iOS 11.0, *)) {
    [self performTestActionNamed:kAddContrastCheckTestViewWithLowContrastSingleWord];
    [self gtxtest_verifyOCRCheckWithExpectedFailures:YES];
  }
}

- (void)testOCRContrastCheckFailsWhenOneWordIsLowContrastInMultipleWordsText {
  if (@available(iOS 11.0, *)) {
    [self performTestActionNamed:kAddContrastCheckTestViewWithLowContrastMultipleWords];
    [self gtxtest_verifyOCRCheckWithExpectedFailures:YES];
  }
}

#pragma mark - Utils

- (void)gtxtest_verifyOCRCheckWithExpectedFailures:(BOOL)expectFailures {
  GTXToolKit *toolkit = [GTXToolKit toolkitWithNoChecks];
  id<GTXChecking> OCRCheck = [GTXChecksCollection checkForSufficientContrastRatioUsingOCR];
  XCTAssertNotNil(OCRCheck);
  [toolkit registerCheck:OCRCheck];
  NSError *error;
  BOOL success = [toolkit checkAllElementsFromRootElements:UIApplication.sharedApplication.windows
                                                     error:&error];
  if (expectFailures) {
    XCTAssertNotNil(error);
  } else {
    XCTAssertNil(error);
  }
  XCTAssertEqual(!expectFailures, success);
}

@end
