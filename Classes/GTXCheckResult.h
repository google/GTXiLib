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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes the result of an error produced by running a @c GTXChecking instance on a UI element.
 */
@interface GTXCheckResult : NSObject

/**
 * The check's name.
 */
@property(copy, nonatomic, readonly) NSString *checkName;

/**
 * A description of the error produced by the check.
 */
@property(copy, nonatomic, readonly) NSString *errorDescription;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes a @c GTXCheckResult with the given parameters.
 *
 * @param checkName The name of the check producing this result.
 * @param errorDescription A description of the error produced by the check.
 */
- (instancetype)initWithCheckName:(NSString *)checkName
                 errorDescription:(NSString *)errorDescription NS_DESIGNATED_INITIALIZER;

/**
 * Constructs a @c GTXCheckResult instance from an @c NSError object in the format returned by @c
 * GTXChecking objects.
 *
 * @param error Describes the result of a @c GTXChecking object. @c error.userInfo must contain the
 * keys @c kGTXErrorCheckNameKey and @c NSLocalizedDescriptionKey.
 */
+ (instancetype)checkResultFromError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
