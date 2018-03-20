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

#import "GTXChecking.h"

FOUNDATION_EXTERN NSString *const kGTXCheckNameAccessibilityLabelPresent;
FOUNDATION_EXTERN NSString *const kGTXCheckNameAccessibilityLabelNotPunctuated;
FOUNDATION_EXTERN NSString *const kGTXCheckNameAccessibilityTraitsDontConflict;
FOUNDATION_EXTERN NSString *const kGTXCheckNameMinimumTappableArea;
FOUNDATION_EXTERN NSString *const kGTXCheckNameMinimumContrastRatio;

/**
 *  An enumeration of various versions of GTXSystems supported by GTX.
 *
 *  Ideally we would like everyone to use one stable version but since several users are using GTX
 *  and adding new checks can require work on part of those users - new checks for example, may
 *  expose new accessibility issues in those apps that will need to be fixed to get all tests to
 *  pass. Versions allow for easy development and deployment of those checks. All the users are on
 *  "stable" version and all new checks are developed under "latest" version when ready, the
 *  checks are moved into the "stable" version so that everyone gets it. Users can easily test (and
 *  debug/fix) their apps with latest checks by switching to the "latest" version.
 */
typedef NS_ENUM(NSUInteger, GTXSystemVersion) {

  /**
   *  The default version of checker uses all the latest *stable* checks.
   */
  GTXSystemVersionStable = 0,

  /**
   *  The version of the checker that uses *all* the latest checks.
   */
  GTXSystemVersionLatest,

  /**
   *  A placeholder for determining maximum count of the versions available.
   */
  GTXSystemVersionMax,
};

/**
 *  Organizes all GTX checks supported by GTXSystem.
 */
@interface GTXChecksCollection : NSObject

/**
 *  @return An array of all supported GTXChecks.
 */
+ (NSArray *)allGTXChecks;

/**
 *  @return An array of GTXChecks under the given version.
 */
+ (NSArray *)checksWithVersion:(GTXSystemVersion)version;

/**
 *  The GTX check instance that has the specified @c name, or @c nil if no such check exists.
 *
 *  @param name The name of the GTX check.
 *
 *  @return The GTX check instance that has the specified @c name.
 */
+ (id<GTXChecking>)GTXCheckWithName:(NSString *)name;

/**
 *  Registers the provided check and makes it available to all @c GTXSystem objects.
 *
 *  @param check The check to be registered, must conform to @c GTXChecking protocol.
 */
+ (void)registerCheck:(id<GTXChecking>)check;

/**
 *  Deregisters a previously registered check.
 *
 *  @param checkName The name of the check to be unregistered.
 */
+ (void)deRegisterCheck:(NSString *)checkName;

@end
