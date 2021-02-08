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

#import "GTXCheckResult.h"
#import "GTXElementReference.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents all the accessibility issues found on a single UI element.
 */
@interface GTXElementResultCollection : NSObject

/**
 * Refers to the UI element without maintaining a reference to the original instance (which would
 * either retain it or be set to nil).
 */
@property(strong, nonatomic, readonly) GTXElementReference *elementReference;

/**
 * All accessibility issues found on @c elementReference. Each result should be produced by a
 * different @c GTXChecking instance.
 */
@property(copy, nonatomic, readonly) NSArray<GTXCheckResult *> *checkResults;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes a @c GTXElementResultCollection with the given parameters.
 *
 * @param element Represents the UI element with accessibility issues this instance refers to.
 * @param checkResults The accessibility issues associated with @c element. Each element in
 * @c checkResults must be produced by a different @c GTXChecking instance.
 * @return An initialized @c GTXElementResultCollection instance.
 */
- (instancetype)initWithElement:(GTXElementReference *)element
                   checkResults:(NSArray<GTXCheckResult *> *)checkResults NS_DESIGNATED_INITIALIZER;

/**
 * Initializes a @c GTXElementResultCollection with an error representing the element and check
 * results.
 *
 * @param error An error aggregating all errors produced by running @c GTXChecking instances on a
 * given element.
 * @return An initialized @c GTXElementResultCollection instance.
 */
- (instancetype)initWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
