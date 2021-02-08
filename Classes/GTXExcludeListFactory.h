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

#import "GTXExcludeListing.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Factory for GTXExcludeListing objects for excluding elements from checks.
 */
@interface GTXExcludeListFactory : NSObject

- (instancetype)init NS_UNAVAILABLE;
/**
 *  Returns a GTXExcludeListing object that ignores all elements that are instances of
 *  a given @c elementClassName.
 *
 *  @param elementClassName The name of the class that should be excluded.
 *  @return A GTXExcludeListing object that ignores all elements of the given class.
 */
+ (id<GTXExcludeListing>)excludeListWithClassName:(NSString *)elementClassName;
/**
 *  Returns a GTXExcludeListing object that ignores all elements that are instances of
 *  a given @c elementClassName, but only for GTXChecking objects with a given @c checkName.
 *
 *  @param elementClassName The name of the class that should be excluded.
 *  @param skipCheckName The name of the check that should ignore elements of the given class.
 *  @return A GTXExcludeListing object that ignores all elements of the given class when running the
 *  given check.
 */
+ (id<GTXExcludeListing>)excludeListWithClassName:(NSString *)elementClassName
                                        checkName:(NSString *)skipCheckName;
/**
 *  Returns a GTXExcludeListing object that ignores all elements with a given accessibility
 *  identifier, but only for GTXChecking objects with a given @c checkName.
 *
 *  @param accessibilityId The accessibility identifier of the element that should be excluded.
 *  @param skipCheckName The name of the check that should ignore elements with the given
 *  accessibility identifier.
 */
+ (id<GTXExcludeListing>)excludeListWithAccessibilityIdentifier:(NSString *)accessibilityId
                                                      checkName:(NSString *)skipCheckName;

@end

NS_ASSUME_NONNULL_END
