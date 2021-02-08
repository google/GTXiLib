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
#import "GTXCommon.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Block that performs a single accessibility check on the given element.
 *
 * @param      element    The target element on which GTX check is to be performed.
 * @param[out] errorOrNil The error set on failure. The error returned can be @c nil, signifying
 *                        that the check succeeded.
 *
 * @return @c YES if the check performed succeeded without any errors, else @c NO.
 */
typedef BOOL (^GTXCheckHandlerBlock)(id element, GTXErrorRefType errorOrNil);

/**
 * A block based interface for creating accessiblity checks.
 */
@interface GTXCheckBlock : NSObject<GTXChecking>

/**
 * GTXCheckBlock::init is disabled, instead use GTXCheckBlock::GTXCheckWithName:block: method
 * to create GTXChecks.
 */
- (instancetype)init __attribute__((unavailable("Use GTXCheckWithName:block: instead.")));

/**
 * Creates an GTXCheck with the given @c name and @c block that performs the check. Note that this
 * check is equivalent to check created using GTXCheckWithName:requiresWindow:block: where
 * requiresWindow is @c YES.
 *
 * @param name  The name of the check.
 * @param block A block that performs the check.
 *
 * @return An GTXCheck object.
 */
+ (id<GTXChecking>)GTXCheckWithName:(NSString *)name block:(GTXCheckHandlerBlock)block;

/**
 * Creates an GTXCheck with the given @c name and @c block that performs the check.
 *
 * @param name           The name of the check.
 * @param requiresWindow A boolean that indicates if element must have a window before running the
 * check.
 * @param block          A block that performs the check.
 *
 * @return An GTXCheck object.
 */
+ (id<GTXChecking>)GTXCheckWithName:(NSString *)name
                     requiresWindow:(BOOL)requiresWindow
                              block:(GTXCheckHandlerBlock)block;

@end

NS_ASSUME_NONNULL_END
