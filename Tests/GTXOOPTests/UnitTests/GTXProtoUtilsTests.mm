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

#include "proto_utils.h"

#import <XCTest/XCTest.h>

#include "typedefs.h"
#include "element_trait.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTXProtoUtilsTests : XCTestCase
@end

@implementation GTXProtoUtilsTests

- (void)testIsStaticTextElementNoTraitsNoElementType {
  UIElementProto proto;
  XCTAssertFalse(gtx::IsStaticTextElement(proto));
}

- (void)testIsStaticTextElementStaticTextTraitNoElementType {
  UIElementProto proto;
  proto.set_ax_traits((uint64)gtx::ElementTrait::kStaticText);
  XCTAssertTrue(gtx::IsStaticTextElement(proto));
}

- (void)testIsStaticTextElementNoTraitsStaticTextElementType {
  UIElementProto proto;
  proto.set_element_type(gtxilib::oopclasses::protos::
                             ElementType_ElementTypeEnum_STATIC_TEXT);
  XCTAssertTrue(gtx::IsStaticTextElement(proto));
}

- (void)testIsStaticTextElementStaticTextTraitAndElementType {
  UIElementProto proto;
  proto.set_ax_traits((uint64)gtx::ElementTrait::kStaticText);
  proto.set_element_type(gtxilib::oopclasses::protos::
                             ElementType_ElementTypeEnum_STATIC_TEXT);
  XCTAssertTrue(gtx::IsStaticTextElement(proto));
}

- (void)testIsTextDisplayingElementNoTraitsNoElementType {
  UIElementProto proto;
  XCTAssertFalse(gtx::IsTextDisplayingElement(proto));
}

- (void)testIsTextDisplayingElementTextDisplayingTraitNoElementType {
  UIElementProto proto;
  proto.set_ax_traits((uint64)gtx::ElementTrait::kStaticText);
  XCTAssertTrue(gtx::IsTextDisplayingElement(proto));
}

- (void)testIsTextDisplayingElementNoTraitsTextDisplayingElementType {
  UIElementProto proto;
  proto.set_element_type(gtxilib::oopclasses::protos::
                             ElementType_ElementTypeEnum_TEXT_FIELD);
  XCTAssertTrue(gtx::IsTextDisplayingElement(proto));
}

- (void)testIsTextDisplayingElementTextDisplayingTraitAndElementType {
  UIElementProto proto;
  proto.set_ax_traits((uint64)gtx::ElementTrait::kSearchField);
  proto.set_element_type(
      gtxilib::oopclasses::protos::ElementType_ElementTypeEnum_TEXT_VIEW);
  XCTAssertTrue(gtx::IsTextDisplayingElement(proto));
}

- (void)testIsButtonElementNoTraitsNoElementType {
  UIElementProto proto;
  XCTAssertFalse(gtx::IsButtonElement(proto));
}

- (void)testIsButtonElementButtonTraitNoElementType {
  UIElementProto proto;
  proto.set_ax_traits((uint64)gtx::ElementTrait::kButton);
  XCTAssertTrue(gtx::IsButtonElement(proto));
}

- (void)testIsButtonElementNoTraitsButtonElementType {
  UIElementProto proto;
  proto.set_element_type(
      gtxilib::oopclasses::protos::ElementType_ElementTypeEnum_BUTTON);
  XCTAssertTrue(gtx::IsButtonElement(proto));
}

- (void)testIsButtonElementButtonTraitButtonElementType {
  UIElementProto proto;
  proto.set_ax_traits((uint64)gtx::ElementTrait::kButton);
  proto.set_element_type(
      gtxilib::oopclasses::protos::ElementType_ElementTypeEnum_BUTTON);
  XCTAssertTrue(gtx::IsButtonElement(proto));
}

@end

NS_ASSUME_NONNULL_END
