//
// Copyright 2021 Google Inc.
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
#import <XCTest/XCTest.h>
#include <string>
#include <vector>

#include "typedefs.h"

/**
 * Common Objective-C++ used across test cases.
 */
@interface GTXObjCPPTestUtils : NSObject

/**
 * @return @c YES if the map in @c metadata contains all the values in @c keys,
 * @c NO otherwise.
 */
+ (BOOL)metadata:(const MetadataProto &)metadata contains:(const std::vector<std::string> &)keys;

/**
 * Asserts that @c str1 equals @c str2. Converts to NSString so XCTAssertEqualObjects displays the
 * contents of the string instead of the address of the string's character buffer when tests fail.
 * Fails with an assertion if @c str1 is not equal to @c str2.
 *
 * @param str1 The first string to compare.
 * @param str2 The second string to compare.
 */
+ (void)assertString:(const std::string &)str1 equalsString:(const std::string &)str2;

@end
