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

// Do not publicly declare C++ methods when compiling in a pure Objective-C environment.
#if __cplusplus

#import <UIKit/UIKit.h>

#import "gtx.pb.h"
#import "typedefs.h"

/**
 * Converts between iOS data structures and pure C++ proto data structures.
 */
@interface GTXProtoUtils : NSObject

/**
 * Converts a @c CGRect into a @c RectProto.
 * @param rect The value to convert.
 * @returns A @c RectProto with the same values at @c rect.
 */
+ (RectProto)protoFromCGRect:(CGRect)rect;

/**
 * Converts a @c RectProto into a @c CGRect.
 * @param rect The value to convert.
 * @returns A @c CGRect with the same values at @c rect.
 */
+ (CGRect)CGRectFromProto:(RectProto)rect;

/**
 * Converts a @c UIColor into a @c ColorProto.
 * @param rect The value to convert.
 * @returns A @c ColorProto with the same RGBA values at @c color.
 */
+ (ColorProto)protoFromUIColor:(UIColor *)color;

@end

#endif
