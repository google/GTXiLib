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
 A matcher block that determines if the given element must be ignored for the given check.

 @param element Element to be looked up if it needs to be ignored.
 @param checkName Name of the check for which element must be looked up.
 @return @c YES if element needs to be ignored for the given check @c NO other wise.
 */
typedef BOOL (^GTXIgnoreElementMatcher)(id element, NSString *checkName);

@interface GTXExcludeListBlock : NSObject <GTXExcludeListing>

/**
 *  GTXExcludeListBlock::init is disabled, instead use GTXExcludeListBlock::excludeListWithBlock:
 *  method to create GTXExcludeLists.
 */
- (instancetype)init __attribute__((unavailable("Use excludeListWithBlock: instead.")));

/**
 *  Creates an GTXExcludeList with the given @c block that determines if an element should be
 * ignored.
 *
 *  @param block A block that determines if an element should be ignored.
 *
 *  @return A GTXExcludeList object.
 */
+ (id<GTXExcludeListing>)excludeListWithBlock:(GTXIgnoreElementMatcher)block;

@end

NS_ASSUME_NONNULL_END
