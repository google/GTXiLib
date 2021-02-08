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

#import "GTXAccessibilityTree.h"
#import "GTXAnalytics.h"
#import "GTXCheckBlock.h"
#import "GTXChecksCollection.h"
#import "GTXCommon.h"
#import "GTXErrorReporter.h"
#import "GTXExcludeListing.h"
#import "GTXTestSuite.h"
#import "NSError+GTXAdditions.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Name of the notification that must be fired when testcase begins - i.e. before test method is
 *  executed but after setup has been.
 */
extern NSString *const gtxTestCaseDidBeginNotification;

/**
 *  Name of the notification that must be fired when testcase ends - i.e. after test method is
 *  executed but before tearDown has been.
 */
extern NSString *const gtxTestCaseDidEndNotification;

/**
 *  Name of the notification that must be fired when a test interaction (tap/swipe etc) begins.
 */
extern NSString *const gtxTestInteractionDidBeginNotification;

/**
 *  Name of the notification that must be fired after a test interaction (tap/swipe etc) has ended.
 */
extern NSString *const gtxTestInteractionDidEndNotification;

/**
 *  Name of the user info key for the notifications that must be set to the name of the currently
 *  running test class.
 */
extern NSString *const gtxTestClassUserInfoKey;

/**
 *  Name of the user info key for the notifications that must be set to the current test invocation.
 */
extern NSString *const gtxTestInvocationUserInfoKey;

/**
 *  Block type for GTXiLib failure handlers, this is invoked with the error detected.
 */
typedef void(^GTXiLibFailureHandler)(NSError *error);

/**
 *  Primary class that allows for installing checks, creating checks and excludeLists etc.
 */
@interface GTXiLib : NSObject

/**
 Install checks on all test cases of a given test suite.

 @param suite Suite of all test cases where checks are to be installed.
 @param checks Array of checks to be installed.
 @param excludeLists Array of element excludeLists to be skipped from checks.
 */
+ (void)installOnTestSuite:(GTXTestSuite *)suite
                    checks:(NSArray<id<GTXChecking>> *)checks
       elementExcludeLists:(NSArray<id<GTXExcludeListing>> *)excludeLists;

/**
 Creates a check with the given name and block.

 @param name Name of the check
 @param block Block that performs the check, the block must return NO if the check failed, YES
              otherwise.
 @return The newly created check.
 */
+ (id<GTXChecking>)checkWithName:(NSString *)name block:(GTXCheckHandlerBlock)block;

/**
 The failure handler to be invoked when checks fail, by default if checks fail an Assertion is
 raised.
 */
@property (class, nonatomic, strong) GTXiLibFailureHandler failureHandler;

@end

NS_ASSUME_NONNULL_END
