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

#import "GTXXCUIElementQueryProxy.h"

/**
 A proxy class for XCUIApplication class. This is needed since XCTest framework that contains
 XCUIApplication class is only linked when tests are run.
 */
@interface GTXXCUIApplicationProxy : NSObject

/**
 @return Last known instance of XCUIApplication object created by the tests, generally this is the
 app being tested.
 */
+ (GTXXCUIApplicationProxy *)lastKnownApplicationProxy;

/**
 Indicates to the proxy class that test teardown is now complete. (allows the proxy class
 to clear some caches).
 */
+ (void)didFinishTestTeardown;

/**
 @return Array of all onscreen accessibility elements (of the app referenced by the last known
 XCUIApplication instance). NOTE: we need gtx_ prefix here to avoid name collision with actual
 XCUIApplication methods.
 */
- (NSArray<UIAccessibilityElement *> *)gtx_onScreenAccessibilityElements;

@end
