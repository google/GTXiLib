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

#import "GTXBlacklistBlock.h"
#import "GTXBlacklisting.h"
#import "GTXCheckBlock.h"
#import "GTXChecking.h"

NS_ASSUME_NONNULL_BEGIN

/**
 GTXToolKit can be used for custom implementation of a checking mechanism, @class GTXiLib uses
 GTXToolKit for performing the checks.
 */
@interface GTXToolKit : NSObject


/**
 Creates a check.

 @param name Name of the check.
 @param block Block that performs the check, returns NO on failure.
 @return A newly created check.
 */
+ (id<GTXChecking>)checkWithName:(NSString *)name block:(GTXCheckHandlerBlock)block;


/**
 Registers the given check to be executed on all elements this instance is used on.

 @param check The check to be registered.
 */
- (void)registerCheck:(id<GTXChecking>)check;

/**
 Registers the given blacklist to be executed on all elements this instance is used on. Registered
 checks are not performed on blacklisted elements.

 @param blacklist The blacklist to be registered.
 */
- (void)registerBlacklist:(id<GTXBlacklisting>)blacklist;


/**
 Applies the registered checks on the given element while respecting blacklisted elements.

 @param element element to be checked.
 @param errorOrNil Error object to be filled with error info on check failures.
 @return @c YES if all checks passed @c NO otherwise.
 */
- (BOOL)checkElement:(id)element error:(GTXErrorRefType)errorOrNil;


/**
 Applies the registered checks on all elements in the accessibility tree under the given root
 elements while respecting blacklisted elements.

 @param rootElements An array of root elements whose accessibility trees are to be checked.
 @param errorOrNil Error object to be filled with error info on check failures.
 @return @c YES if all checks passed on all elements @c NO otherwise.
 */
- (BOOL)checkAllElementsFromRootElements:(NSArray *)rootElements
                                   error:(GTXErrorRefType)errorOrNil;

@end

NS_ASSUME_NONNULL_END
