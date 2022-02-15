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

#include "gtx_types.h"

@interface UIColor (GTXOOPAdditions)

/**
 *  @return a unique pointer to gtx::Color instance for the given color.
 */
+ (UIColor *)gtx_colorFromGTXColor:(const gtx::Color &)gtxColor;

/**
 *  @return a unique pointer to gtx::Color instance for the given color.
 */
- (std::unique_ptr<gtx::Color>)gtx_color;

@end

#endif
