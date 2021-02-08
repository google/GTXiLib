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

#import <UIKit/UIKit.h>

#import "GTXElementResultCollection.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * All the accessibility issues found in a view hierarchy, defined by an array of root elements.
 */
@interface GTXHierarchyResultCollection : NSObject

/**
 * All accessibility issues found in the hierarchy. Each entry represents an element with an
 * accessibility issue.
 */
@property(copy, nonatomic, readonly) NSArray<GTXElementResultCollection *> *elementResults;

/**
 * A screenshot of the view hierarchy as it appeared when the results were collected, or @c nil if
 * none exists.
 */
@property(strong, nonatomic, readonly) UIImage *screenshot;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes a @c GTXHierarchyResultCollection instance with the given parameters.
 *
 * @param elementResults The elements in the hierarchy with accessibility issues.
 * @param screenshot A screenshot of the view hierarchy as it appeared when the results were
 *  collected.
 * @return An initialized @c GTXHierarchyResultCollection instance.
 */
- (instancetype)initWithElementResults:(NSArray<GTXElementResultCollection *> *)elementResults
                            screenshot:(UIImage *)screenshot NS_DESIGNATED_INITIALIZER;

/**
 * Initializes a @c GTXHierarchyResultCollection instance by parsing @c errors representing
 * aggregate errors produced by @c GTXToolKit.
 *
 * @param errors An array of errors. Each error must be produced by a @c GTXToolKit instance. @c nil
 *  is treated as an empty array.
 * @param rootViews The root views scanned to produce @c errors. Fails with an assertion if
 *  @c rootViews is empty. It is assumed all elements in @c rootViews have the same origin.
 * @return An initialized @c GTXHierarchyResultCollection instance.
 */
- (instancetype)initWithErrors:(nullable NSArray<NSError *> *)errors
                     rootViews:(NSArray<UIView *> *)rootViews;

/**
 * @return The number of check results across all elements in this scan.
 */
- (NSUInteger)checkResultCount;

@end

NS_ASSUME_NONNULL_END
