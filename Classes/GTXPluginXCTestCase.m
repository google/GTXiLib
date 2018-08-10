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

#import "GTXPluginXCTestCase.h"

#import "GTXAssertions.h"
#import "GTXiLibCore.h"
#import "GTXTestEnvironment.h"

#import <objc/runtime.h>

/**
 Reference to XCTestCase class which will be dynamically set when needed, this allows for tests as
 well as apps (which dont link to XCTest) use GTX.
 */
Class gXCTestCaseClass;

@implementation GTXPluginXCTestCase

+ (void)installPlugin {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gXCTestCaseClass = NSClassFromString(@"XCTestCase");
    NSAssert(gXCTestCaseClass, @"XCTestCase class was not found, either XCTest framework is not "
                               @"being linked or not loaded yet.");
    [self gtx_addInstanceMethod:@selector(gtx_tearDown)
                      fromClass:self
                        toClass:gXCTestCaseClass];
    [self gtx_addInstanceMethod:@selector(gtx_invokeTest)
                      fromClass:self
                        toClass:gXCTestCaseClass];
    [self gtx_swizzleInstanceMethod:@selector(invokeTest)
                         withMethod:@selector(gtx_invokeTest)
                            inClass:gXCTestCaseClass];
    [GTXTestEnvironment setupEnvironment];
  });
}

#pragma mark - XCTestCase Methods

- (void)tearDown {
  NSAssert(NO, @"This method was added only for a reference to the selector but must never be "
               @"invoked directly.");
}

- (void)invokeTest {
  NSAssert(NO, @"This method was added only for a reference to the selector but must never be "
               @"invoked directly.");
}

#pragma mark - Private

/**
 Adds the given method from the given source to the given destination class.

 @param methodSelector selector of the method to be added.
 @param srcClass Source class from where to get the method implementation
 @param destClass destination class where the method implementation is to be added.
 */
+ (void)gtx_addInstanceMethod:(SEL)methodSelector
                    fromClass:(Class)srcClass
                      toClass:(Class)destClass {
  Method instanceMethod = class_getInstanceMethod(srcClass, methodSelector);
  const char *typeEncoding = method_getTypeEncoding(instanceMethod);
  NSAssert(typeEncoding, @"Failed to get method type encoding.");

  BOOL success = class_addMethod(destClass,
                                 methodSelector,
                                 method_getImplementation(instanceMethod),
                                 typeEncoding);
  NSAssert(success, @"Failed to add %@ from %@ to %@",
                    NSStringFromSelector(methodSelector), srcClass, destClass);
  (void)success; // Ensures 'success' is marked as used even if NSAssert is removed.
}

/**
 Swizzles the given methods in the given class.

 @param methodSelector1 Selector for the original method.
 @param methodSelector2 Selector for the method to be swizzled with.
 @param clazz Target class to be swizzled in.
 */
+ (void)gtx_swizzleInstanceMethod:(SEL)methodSelector1
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

/**
 @return Closest superclass to @c clazz that has -tearDown method.
 */
+ (Class)gtx_classWithInstanceTearDown:(Class)clazz {
  while (clazz != gXCTestCaseClass &&
         ![clazz instanceMethodForSelector:@selector(tearDown)]) {
    clazz = [clazz superclass];
  }
  return clazz;
}

/**
 Wires up teardown in the given class so that -gtx_tearDown is invoked instead.

 @param clazz The class to be modified.
 */
+ (void)gtx_wireUpTeardownInClass:(Class)clazz {
  Class baseClass = gXCTestCaseClass;

  // If gtx_tearDown does not exists in clazz, add it first.
  if (baseClass != clazz) {
    Method defaultGTXTearDown = class_getInstanceMethod(baseClass, @selector(gtx_tearDown));
    struct objc_method_description *desc = method_getDescription(defaultGTXTearDown);
    IMP gtxTearDownIMP = [baseClass instanceMethodForSelector:@selector(gtx_tearDown)];
    class_addMethod(clazz, @selector(gtx_tearDown), gtxTearDownIMP, desc->types);
  }
  [self gtx_swizzleInstanceMethod:@selector(tearDown)
                       withMethod:@selector(gtx_tearDown)
                          inClass:clazz];
}

/**
 Restores @c clazz to its original state (opposite of +gtx_wireUpTeardownInClass).
 */
+ (void)gtx_unWireTeardownInClass:(Class)clazz {
  // Swizzle again to restore tearDown/gtx_tearDown to their original IMPs.
  [self gtx_swizzleInstanceMethod:@selector(tearDown)
                       withMethod:@selector(gtx_tearDown)
                          inClass:clazz];
}

#pragma mark - Swizzled methods

/**
 Swizzled method for -invokeTest method that posts notifications when test begins.
 */
- (void)gtx_invokeTest {
  id actualSelf = self; // Note that self is of type XCTestCase
  Class classWithTearDown =
      [[GTXPluginXCTestCase class] gtx_classWithInstanceTearDown:[self class]];
  [[GTXPluginXCTestCase class] gtx_wireUpTeardownInClass:classWithTearDown];
  [[NSNotificationCenter defaultCenter] postNotificationName:gtxTestCaseDidBeginNotification
                                                      object:self
                                                    userInfo:@{gtxTestClassUserInfoKey:
                                                                 [self class],
                                                               gtxTestInvocationUserInfoKey:
                                                                 [actualSelf invocation]}];
  @try {
    typedef void (*InvokeTestMethodType)(id, SEL);
    InvokeTestMethodType method =
        (InvokeTestMethodType)[self methodForSelector:@selector(gtx_invokeTest)];
    method(self, _cmd);
  } @finally {
    [[GTXPluginXCTestCase class] gtx_unWireTeardownInClass:classWithTearDown];
  }
}

/**
 Swizzled method for -tearDown method that posts notifications for teardown.
 */
- (void)gtx_tearDown {
  id actualSelf = self; // Note that self is of type XCTestCase
  [[NSNotificationCenter defaultCenter] postNotificationName:gtxTestCaseDidEndNotification
                                                      object:self
                                                    userInfo:@{gtxTestClassUserInfoKey:
                                                                 [self class],
                                                               gtxTestInvocationUserInfoKey:
                                                                 [actualSelf invocation]}];
  typedef void (*TearDownMethodType)(id, SEL);
  TearDownMethodType method =
      (TearDownMethodType)[self methodForSelector:@selector(gtx_tearDown)];
  method(self, _cmd);
}

@end
