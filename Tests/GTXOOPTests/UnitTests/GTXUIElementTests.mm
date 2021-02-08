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

#include "ui_element.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTXUIElementTests : XCTestCase
@end

@implementation GTXUIElementTests

- (void)testIsTextDisplayingElementNoTraitsOrElementTypeIsFalse {
  gtx::UIElement element;
  XCTAssertFalse(element.is_text_displaying_element());
}

- (void)testIsTextDisplayingElementTraitsAndNoElementTypeIsTrue {
  gtx::UIElement element;
  element.set_ax_traits(gtx::ElementTrait::kStaticText);
  XCTAssertTrue(element.is_text_displaying_element());
}

- (void)testIsTextDisplayingNoElementTraitsAndElementTypeIsTrue {
  gtx::UIElement element;
  element.set_element_type(gtx::ElementType::TEXT_FIELD);
  XCTAssertTrue(element.is_text_displaying_element());
}

- (void)testIsTextDisplayingElementTraitsAndElementTypeIsTrue {
  gtx::UIElement element;
  element.set_ax_traits(gtx::ElementTrait::kSearchField);
  element.set_element_type(gtx::ElementType::TEXT_VIEW);
  XCTAssertTrue(element.is_text_displaying_element());
}

@end

NS_ASSUME_NONNULL_END
