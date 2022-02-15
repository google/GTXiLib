//
// Copyright 2021 Google Inc.
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
 *  Class to hold GTX tree's current iteration context including a queue of elements to be traversed
 *  and a set of elements traversed.
 */
@interface GTXTreeIteratorContext : NSObject

/**
 *  -init is unavailable, use -initWithElements: instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Initializes a new @c GTXTreeIteratorContext object.
 *
 *  @param elements The elements to begin the tree iteration from.
 *
 *  @return An initialized @c GTXTreeIteratorContext object.
 */
- (instancetype)initWithElements:(NSArray<id> *)elements;

/**
 *  @return @c YES if the current context has elements in its queue, @c NO otherwise.
 */
- (BOOL)hasElementsInQueue;

/**
 *  @return The next element in the queue (without removing it from the queue).
 */
- (GTXTreeIteratorElement *)peekNextElement;

/**
 *  Dequeues the next element in the queue.
 */
- (void)dequeueNextElement;

/**
 *  Queues the given element into the queue.
 *
 *  @param element The element to be queued.
 */
- (void)queueElement:(GTXTreeIteratorElement *)element;

/**
 *  @return @c YES if the given @c element was visited, @c NO otherwise.
 */
- (BOOL)didVisitElement:(id)element;

/**
 *  Marks the given element as visited.
 *
 *  @param element The element to be marked as visited.
 */
- (void)visitElement:(id)element;

@end

NS_ASSUME_NONNULL_END
