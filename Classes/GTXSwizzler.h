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

/**
 Class for performing Objective-C swizzle operations.
 */
@interface GTXSwizzler : NSObject

/**
 Adds the given method from the given source to the given destination class.

 @param methodSelector selector of the method to be added.
 @param srcClass Source class from where to get the method implementation
 @param destClass destination class where the method implementation is to be added.
 */
+ (void)addInstanceMethod:(SEL)methodSelector fromClass:(Class)srcClass toClass:(Class)destClass;

/**
 Swizzles the given methods in the given class.

 @param methodSelector1 Selector for the original method.
 @param methodSelector2 Selector for the method to be swizzled with.
 @param clazz Target class to be swizzled in.
 */
+ (void)swizzleInstanceMethod:(SEL)methodSelector1
                   withMethod:(SEL)methodSelector2
                      inClass:(Class)clazz;

@end
