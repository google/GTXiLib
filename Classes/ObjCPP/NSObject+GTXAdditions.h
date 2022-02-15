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

#include "gtx.pb.h"
#include "typedefs.h"

/**
 *  Additions to NSObject to make it easy to create gtx::UIElements from UIViews and
 *  UIAccessibilityElements.
 */
@interface NSObject (GTXAdditions)

/**
 * Converts this object into a @c UIElementProto. If this object is a subclass of @c NSObject
 * and contains properties declared by @c UIElementProto, those properties are included, too.
 * Does not set parent child relationships of @c UIElementProto.
 * @returns A @c UIElementProto populated by this object's properties.
 */
- (UIElementProto)gtx_toProto;

@end

#endif
