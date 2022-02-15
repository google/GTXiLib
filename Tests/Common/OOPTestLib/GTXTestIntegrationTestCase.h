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

#import "GTXUITestBaseTestCase.h"

/**
 Base class for all GTXOOPLib Integration test classes.
 */
@interface GTXTestIntegrationTestCase : GTXUITestBaseTestCase

/**
 * The app under test.
 */
@property(nonatomic, strong, readonly) XCUIApplication *app;

/**
 Clears the test area in teardown if @c YES, default value is @c YES.
 */
@property(nonatomic, assign, getter=shouldClearTestAreaOnTeardown) BOOL clearTestAreaOnTeardown;

/**
 Performs the action named @c actionName by scrolling to the appropriate action.
 */
- (void)performTestActionNamed:(NSString *)actionName;

/**
 Clears the test area.
 */
- (void)clearTestArea;

/**
 Runs all the GTX checks on the test element.
 */
- (BOOL)runAllGTXChecksOnTestElement;

@end
