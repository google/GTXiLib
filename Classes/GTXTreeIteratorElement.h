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

NS_ASSUME_NONNULL_BEGIN

/**
 *  Class for the element that is used in the context of tree iteration.
 */
@interface GTXTreeIteratorElement : NSObject

/**
 *  -init is unavailable, use -initWithElement:inContainer: instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Initializes a new @c GTXTreeIteratorElement object.
 *
 *  @param element The element to be used as current element.
 *  @param root The element to be used as the root of the current element.
 *
 *  @return An initialized @c GTXTreeIteratorElement object.
 */
- (instancetype)initWithElement:(id)element inContainer:(nullable id)container;

/**
 *  The current element in the context of iteration.
 */
@property(nonatomic, strong, readonly) id current;

/**
 *  Container for the current element, is @c nil if the current element is a root element.
 */
@property(nonatomic, strong, nullable, readonly) id container;

/**
 *  @return A mutable array of @c GTXTreeIteratorElement objects with the elements in @c
 *          elementArray.
 */
+ (NSMutableArray<GTXTreeIteratorElement *> *)mutableIteratorElementArrayFromArray:
    (NSArray *)elementArray;

@end

NS_ASSUME_NONNULL_END
