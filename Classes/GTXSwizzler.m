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

#import "GTXSwizzler.h"

#import "GTXAssertions.h"

#import <objc/runtime.h>

@implementation GTXSwizzler

+ (void)addInstanceMethod:(SEL)methodSelector fromClass:(Class)srcClass toClass:(Class)destClass {
  Method instanceMethod = class_getInstanceMethod(srcClass, methodSelector);
  const char *typeEncoding = method_getTypeEncoding(instanceMethod);
  NSAssert(typeEncoding, @"Failed to get method type encoding.");

  BOOL success = class_addMethod(destClass, methodSelector,
                                 method_getImplementation(instanceMethod), typeEncoding);
  NSAssert(success, @"Failed to add %@ from %@ to %@", NSStringFromSelector(methodSelector),
           srcClass, destClass);
  (void)success;  // Ensures 'success' is marked as used even if NSAssert is removed.
}

+ (void)swizzleInstanceMethod:(SEL)methodSelector1
                   withMethod:(SEL)methodSelector2
                      inClass:(Class)clazz {
  Method method1 = class_getInstanceMethod(clazz, methodSelector1);
  Method method2 = class_getInstanceMethod(clazz, methodSelector2);
  // Only swizzle if both methods are found
  if (method1 && method2) {
    IMP imp1 = method_getImplementation(method1);
    IMP imp2 = method_getImplementation(method2);

    if (class_addMethod(clazz, methodSelector1, imp2, method_getTypeEncoding(method2))) {
      class_replaceMethod(clazz, methodSelector2, imp1, method_getTypeEncoding(method1));
    } else {
      method_exchangeImplementations(method1, method2);
    }
  } else {
    GTX_ASSERT(NO, @"Cannot swizzle %@", NSStringFromSelector(methodSelector1));
  }
}

@end
