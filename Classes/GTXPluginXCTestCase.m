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
#import "GTXSwizzler.h"
#import "GTXTestEnvironment.h"
#import "GTXiLibCore.h"

#import <objc/runtime.h>

/**
 Reference to XCTestCase class which will be dynamically set when needed, this allows for tests as
 well as apps (which dont link to XCTest) use GTX.
 */
static Class gXCTestCaseClass;

@implementation GTXPluginXCTestCase

+ (void)installPlugin {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gXCTestCaseClass = NSClassFromString(@"XCTestCase");
    NSAssert(gXCTestCaseClass, @"XCTestCase class was not found, either XCTest framework is not "
                               @"being linked or not loaded yet.");
    [GTXSwizzler addInstanceMethod:@selector(gtx_tearDown) fromClass:self toClass:gXCTestCaseClass];
    [GTXSwizzler addInstanceMethod:@selector(gtx_invokeTest)
                         fromClass:self
                           toClass:gXCTestCaseClass];
    [GTXSwizzler swizzleInstanceMethod:@selector(invokeTest)
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
  [GTXSwizzler swizzleInstanceMethod:@selector(tearDown)
                          withMethod:@selector(gtx_tearDown)
                             inClass:clazz];
}

/**
 Restores @c clazz to its original state (opposite of +gtx_wireUpTeardownInClass).
 */
+ (void)gtx_unWireTeardownInClass:(Class)clazz {
  // Swizzle again to restore tearDown/gtx_tearDown to their original IMPs.
  [GTXSwizzler swizzleInstanceMethod:@selector(tearDown)
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
