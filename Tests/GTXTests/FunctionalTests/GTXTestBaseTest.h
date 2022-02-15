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
#import <QuartzCore/QuartzCore.h>
#import <XCTest/XCTest.h>

#import "GTXiLib.h"
#import "GTXTestViewController.h"

/**
 Check that fails if the element is of Class @c GTXTestFailingClass.
 */
extern id<GTXChecking> gCheckFailsIfFailingClass;

/**
 Check that always passes.
 */
extern id<GTXChecking> gAlwaysFail;

/**
 Check that always fails.
 */
extern id<GTXChecking> gAlwaysPass;

/**
 The default wait time for app events.
 */
extern const NSTimeInterval kGTXDefaultAppEventsWaitTime;

/**
 Base test for all GTXiLib functional/integration tests used to setup GTXiLib and capture check
 failures.
 */
@interface GTXTestBaseTest : XCTestCase


/**
 Assert that @c count failures were detected.
 */
- (void)assertFailureCount:(NSInteger)count;

/**
 Assert that no failures were detected.
 */
- (void)assertNoFailure;

/**
 Assert a single failure then clear the detected failures.
 */
- (void)assertAndClearSingleFailure;

/**
 Performs the provided test action on the test app and waits for its completion.
 */
- (void)performTestActionNamed:(NSString *)testAction;

/**
 Waits given time interval for any app events to be processed.
 */
- (void)waitForAppEvents:(NSTimeInterval)seconds;

@end

/**
 Placeholder class for passing elements.
 */
@interface GTXTestPassingClass : UIView
@end

/**
 Placeholder class for failing elements.
 */
@interface GTXTestFailingClass : UIView
@end
