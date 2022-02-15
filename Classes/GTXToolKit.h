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

#import "GTXCheckBlock.h"
#import "GTXChecking.h"
#import "GTXExcludeListBlock.h"
#import "GTXExcludeListing.h"
#import "GTXResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 GTXToolKit can be used for custom implementation of a checking mechanism, @class GTXiLib uses
 GTXToolKit for performing the checks.
 */
@interface GTXToolKit : NSObject

/**
 Instead if init, use +defaultToolkit, +toolkitWithNoChecks or +toolkitWithAllDefaultChecks.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 @return A new toolkit object a single default check.
 */
+ (instancetype)defaultToolkit;

/**
 @return A new empty toolkit object.
 */
+ (instancetype)toolkitWithNoChecks;

/**
 @return A new toolkit object with all default checks.
 */
+ (instancetype)toolkitWithAllDefaultChecks;

/**
 Creates an accessibility check, note that this check can only be executed on elements that have a
 window (or are UIAccessibilityElements).

 @param name Name of the check.
 @param block Block that performs the check, returns NO on failure.

 @return A newly created check.
 */
+ (id<GTXChecking>)checkWithName:(NSString *)name block:(GTXCheckHandlerBlock)block;

/**
 Creates an element check. @note that this check will be executed on any element even if it is not
 in the view hierarchy and/or does not have a window if @c requiresWindow is @c NO.

 @param name           Name of the check.
 @param requiresWindow A boolean that indicates if element must have a window before running the
 check. For example to create checks that can be executed in unit testing environment set this value
 to NO.
 @param block          Block that performs the check, returns NO on failure.

 @return A newly created check.
 */
+ (id<GTXChecking>)checkWithName:(NSString *)name
                  requiresWindow:(BOOL)requiresWindow
                           block:(GTXCheckHandlerBlock)block;

/**
 Registers the given check to be executed on all elements this instance is used on.

 @param check The check to be registered.
 */
- (void)registerCheck:(id<GTXChecking>)check;

/**
 Registers the given excludeList to be executed on all elements this instance is used on. Registered
 checks are not performed on excluded elements.

 @param excludeList The excludeList to be registered.
 */
- (void)registerExcludeList:(id<GTXExcludeListing>)excludeList;

/**
 Applies the registered checks on the given element while respecting excluded elements.

 @param element element to be checked.
 @param errorOrNil Error object to be filled with error info on check failures.
 @return @c YES if all checks passed @c NO otherwise.
 */
- (BOOL)checkElement:(id)element error:(GTXErrorRefType)errorOrNil;

/**
 @deprecated Use -resultFromCheckingAllElementsFromRootElements: instead.

 Applies the registered checks on all elements in the accessibility tree under the given root
 elements while respecting excluded elements. Root elements are instances of @c UIView, @c UIWindow
 or @c UIAccessibiltyElement objects which conform to UIAccessibility or UIAccessibilityContainer
 protocols, objects such as UIViewControllers in general are not.

 @param rootElements An array of root elements whose accessibility trees are to be checked.
 @param errorOrNil Error object to be filled with error info on check failures.
 @return @c YES if all checks passed on all elements @c NO otherwise.
 */
- (BOOL)checkAllElementsFromRootElements:(NSArray *)rootElements error:(GTXErrorRefType)errorOrNil;

/**
 Applies the registered checks on all elements in the accessibility tree under the given root
 elements while respecting excluded elements. Root elements are instances of @c UIView, @c UIWindow
 or @c UIAccessibiltyElement objects which conform to UIAccessibility or UIAccessibilityContainer
 protocols, objects such as UIViewControllers in general are not.

 @param rootElements An array of root elements whose accessibility trees are to be checked.
 @return A @c GTXResult object encpsulating the results.
 */
- (GTXResult *)resultFromCheckingAllElementsFromRootElements:(NSArray *)rootElements;

@end

NS_ASSUME_NONNULL_END
