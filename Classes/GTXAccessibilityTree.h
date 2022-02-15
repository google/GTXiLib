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

#import <Foundation/Foundation.h>

#import "GTXTreeIteratorElement.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Block type used by GTXAccessibilityTree APIs for handling iteration.
 */
typedef void (^GTXTreeIterationBlock)(GTXTreeIteratorElement *iteratorElement);

/**
 *  An enumerator for the accessibility trees navigated by accessibility services like VoiceOver.
 */
@interface GTXAccessibilityTree : NSEnumerator

/**
 *  Creates a new accessibility tree whose traversals will include the given @c rootElements.
 */
- (instancetype)initWithRootElements:(NSArray *)rootElements;

/**
 *  Iterates through all the elements in the tree using the given block
 *
 *  @param block The block that will be invoked with iteration element objects.
 */
- (void)iterateAllElementsWithBlock:(GTXTreeIterationBlock)block;

@end

NS_ASSUME_NONNULL_END
