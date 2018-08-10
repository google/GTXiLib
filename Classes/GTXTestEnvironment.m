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

#import "GTXTestEnvironment.h"

#import "GTXLogging.h"
#import "NSError+GTXAdditions.h"

#include <dlfcn.h>

#pragma mark - Exposed Interfaces

/**
 *  An Exposed internal class used for enabling accessibility on simulators.
 */
@interface AXBackBoardServer

/**
 *  Returns current backboard server instance.
 */
+ (instancetype)server;

/**
 *  Sets the given preference and posts the given notification.
 *
 *  @param key Name of the key whose value is to be set.
 *  @param value The value to be set to.
 *  @param notification The notification to be raised.
 */
- (void)setAccessibilityPreferenceAsMobile:(CFStringRef)key
                                     value:(CFBooleanRef)value
                              notification:(CFStringRef)notification;

@end

#pragma mark - Globals

/**
 *  Path to accessibility utils framework on the simulator.
 */
static NSString *const kPathToAXUtils =
    @"/System/Library/PrivateFrameworks/AccessibilityUtilities.framework/AccessibilityUtilities";

/**
 * Class name of the private class: XCAXClient_iOS class.
 */
static NSString *const kXCAXClientClassName = @"XCAXClient_iOS";

#pragma mark - Implementations

@implementation GTXTestEnvironment

+ (BOOL)setupEnvironmentWithError:(GTXErrorRefType)errorOrNil {
  static dispatch_once_t onceToken;
  __block BOOL setupSuccessful = YES;
  dispatch_once(&onceToken, ^{
#if TARGET_OS_SIMULATOR
    setupSuccessful = [self _enableAccessibilityForSimulatorWithError:errorOrNil];
#else
    setupSuccessful = [self _enableAccessibilityOnDeviceWithError:errorOrNil];
#endif
  });
  return setupSuccessful;
}

+ (void)setupEnvironment {
  NSAssert([GTXTestEnvironment setupEnvironmentWithError:nil],
           @"Test environment could not be set up");
}

/**
 *  Enables accessibility to allow using accessibility properties on simulators.
 *
 *  @param[out] errorOrNil A pointer to an error object to return information on failure, or nil.
 *  @return YES if accessibility was enabled, NO if there was an error.
 */
+ (BOOL)_enableAccessibilityForSimulatorWithError:(GTXErrorRefType)errorOrNil {
  // Set the preferences that turn on Accessibility.
  BOOL setSuccessful = YES;
  setSuccessful =
      [self _setAccessibilityPreference:(CFStringRef) @"ApplicationAccessibilityEnabled"
                                  value:kCFBooleanTrue
                           notification:(CFStringRef) @"com.apple.accessibility.cache.app.ax"
                                  error:errorOrNil];
  if (!setSuccessful) {
    return NO;
  }
  setSuccessful =
      [self _setAccessibilityPreference:(CFStringRef) @"AccessibilityEnabled"
                                  value:kCFBooleanTrue
                           notification:(CFStringRef) @"com.apple.accessibility.cache.ax"
                                  error:errorOrNil];
  return setSuccessful;
}

/**
 *  Sets the given preference and posts the given notification using @c AXBackBoardServer.
 *
 *  @param key Name of the key whose value is to be set.
 *  @param value The value to be set to.
 *  @param name The name of the notification to be raised.
 *  @param[out] errorOrNil A pointer to an error object to return information on failure, or nil.
 *  @return YES if the preference was set, NO if there was an error.
 */
+ (BOOL)_setAccessibilityPreference:(CFStringRef)key
                              value:(CFBooleanRef)value
                       notification:(CFStringRef)name
                              error:(GTXErrorRefType)errorOrNil {
  __block BOOL setupSuccessful = YES;
  static AXBackBoardServer *server;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    char const *const localPath = [kPathToAXUtils fileSystemRepresentation];
    void *handle = dlopen(localPath, RTLD_LOCAL);
    if (!handle) {
      NSString *description =
          [NSString stringWithFormat:@"Could not load AccessibilityUtilities at %s", localPath];
      [NSError gtx_logOrSetError:errorOrNil
                     description:description
                            code:GTXCheckErrorCodeInvalidTestEnvironment
                        userInfo:nil];
      setupSuccessful = NO;
      return;
    }
    (void)handle;  // Ensures 'handle' is marked as used even if NSError is removed.
    Class AXBackBoardServerClass = NSClassFromString(@"AXBackBoardServer");
    if (!AXBackBoardServerClass) {
      [NSError gtx_logOrSetError:errorOrNil
                     description:@"AXBackBoardServer class not found"
                            code:GTXCheckErrorCodeInvalidTestEnvironment
                        userInfo:nil];
      setupSuccessful = NO;
      return;
    }
    server = [AXBackBoardServerClass performSelector:@selector(server)];
    if (!server) {
      [NSError gtx_logOrSetError:errorOrNil
                     description:@"Could not retrieve AXBackBoardServer object"
                            code:GTXCheckErrorCodeInvalidTestEnvironment
                        userInfo:nil];
      setupSuccessful = NO;
      return;
    }
  });
  [server setAccessibilityPreferenceAsMobile:key
                                       value:value
                                notification:name];
  return setupSuccessful;
}

/**
 *  Enables accessibility to allow using accessibility properties on devices.
 */
+ (BOOL)_enableAccessibilityOnDeviceWithError:(GTXErrorRefType)errorOrNil {
  Class XCAXClientClass = NSClassFromString(kXCAXClientClassName);
  if (XCAXClientClass == nil) {
    NSString *description = [NSString stringWithFormat:@"%@ class not found", kXCAXClientClassName];
    [NSError gtx_logOrSetError:errorOrNil
                   description:description
                          code:GTXCheckErrorCodeInvalidTestEnvironment
                      userInfo:nil];
    return NO;
  }
  id XCAXClient = [XCAXClientClass sharedClient];
  if (XCAXClient == nil) {
    NSString *description =
        [NSString stringWithFormat:@"%@ sharedClient doesn't exist", kXCAXClientClassName];
    [NSError gtx_logOrSetError:errorOrNil
                   description:description
                          code:GTXCheckErrorCodeInvalidTestEnvironment
                      userInfo:nil];
    return NO;
  }
  // The method may not be available on versions older than iOS 9.1
  if ([XCAXClient respondsToSelector:@selector(loadAccessibility:)]) {
    typedef void (*MethodType)(id, SEL, void*);
    SEL selector = @selector(loadAccessibility:);
    static void *unused = 0;
    MethodType method = (MethodType)[XCAXClient methodForSelector:selector];
    method(XCAXClient, selector, &unused);
  } else {
    [NSError gtx_logOrSetError:errorOrNil
                   description:@"Could not enable accessibility! iOS version must be >= 9.1"
                          code:GTXCheckErrorCodeInvalidTestEnvironment
                      userInfo:nil];
    return NO;
  }
  return YES;
}

#pragma mark - unused methods

/**
 *  Unused method only used for selector name.
 */
- (id)sharedClient {
  NSAssert(NO, @"This method must not be invoked directly, its only used for exposing selector");
  return nil;
}

/**
 *  Unused method only used for selector name.
 */
- (BOOL)loadAccessibility:(void **)unused {
  NSAssert(NO, @"This method must not be invoked directly, its only used for exposing selector");
  return NO;
}

@end
