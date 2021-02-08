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

/**
 A proxy class for XCUIElement class. This is needed since XCTest framework that contains
 XCUIElement class is only linked when tests are run.
 */
@interface GTXXCUIElementProxy : NSObject

/**
 Installs GTXXCUIElementProxy plugin by swizzling some XCUIElement methods.
 */
+ (void)installPlugin;

/**
 @return UIAccessibilityElement representation of this element. NOTE: we need gtx_ prefix here to
 avoid name collision with actual XCUIElement methods.
 */
- (UIAccessibilityElement *)gtx_accessibilityElementWithContainer:(id)container;

@end
