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

@class GTXXCUIElementProxy;

/**
 A proxy class for XCUIElementQuery class. This is needed since XCTest framework that contains
 XCUIElementQuery class is only linked when tests are run.
 */
@interface GTXXCUIElementQueryProxy : NSObject
@end

/**
 Category to expose the methods on XCUIElementQuery that this class uses.
 */
@interface GTXXCUIElementQueryProxy (XCUIElementQuery)

/**
 @return Array of GTXXCUIElementProxy instances of all elements matched by this query. Proxy for
 XCUIElementQuery's -allElementsBoundByIndex method.
 */
- (NSArray<GTXXCUIElementProxy *> *)allElementsBoundByIndex;

@end
