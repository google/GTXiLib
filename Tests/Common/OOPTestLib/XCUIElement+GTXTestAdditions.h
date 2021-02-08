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

#import <XCTest/XCTest.h>

#include "element_type.h"
#include "ui_element.h"

@interface XCUIElement (GTXTestAdditions)

- (UIAccessibilityElement *)gtxtest_accessibilityElementWithContainer:(id)container;

/**
 * @return A @c gtx::UIElement representing this element.
 */
- (std::unique_ptr<gtx::UIElement>)gtxtest_UIElement;

/**
 * Converts an @c XCUIElementType to its corresponding @c gtx::ElementType value.
 * @param elementType The @c XCUIElementType to convert.
 * @return A @c gtx::ElementType::ElementTypeEnum value corresponding to @c elementType.
 */
+ (gtx::ElementType::ElementTypeEnum)gtxtest_elementTypeFromXCUIElementType:
    (XCUIElementType)elementType;

@end
