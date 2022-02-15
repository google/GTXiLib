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

// Do not publicly declare C++ methods when compiling in a pure Objective-C environment.
#if __cplusplus

#import <UIKit/UIKit.h>
#include <string>

/**
 *  Additions to NSObject to make it easy to create gtx::UIElements from UIViews and
 *  UIAccessibilityElements.
 */
@interface NSString (GTXAdditions)

/**
 *  @returns an NSString object from the given std::string.
 */
+ (NSString *)gtx_stringFromSTDString:(const std::string &)string;

/**
 *  @returns a std::string object for the given NSString instance.
 */
- (std::string)gtx_stdString;

@end

#endif
