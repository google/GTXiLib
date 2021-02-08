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

#include "ui_element.h"

/**
 *  Additions to NSObject to make it easy to create gtx::UIElements from UIViews and
 *  UIAccessibilityElements.
 */
@interface NSObject (GTXAdditions)

/**
 *  @returns a unique_ptr to @c gtx::UIElement representing this element (UIView or
 *  UIAccessibilityElement).
 */
- (std::unique_ptr<gtx::UIElement>)gtx_UIElement;

@end
