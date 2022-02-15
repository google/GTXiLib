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

#import "GTXProtoUtils.h"

#import <XCTest/XCTest.h>

#import "typedefs.h"

@interface GTXProtoUtilsTests : XCTestCase
@end

@implementation GTXProtoUtilsTests

- (void)testProtoFromCGRect {
  CGRect rect = CGRectMake(1, 2, 3, 4);
  RectProto proto = [GTXProtoUtils protoFromCGRect:rect];
  XCTAssertEqual(proto.origin().x(), rect.origin.x);
  XCTAssertEqual(proto.origin().y(), rect.origin.y);
  XCTAssertEqual(proto.size().width(), rect.size.width);
  XCTAssertEqual(proto.size().height(), rect.size.height);
}

- (void)testCGRectFromProto {
  RectProto proto;
  proto.mutable_origin()->set_x(1);
  proto.mutable_origin()->set_y(2);
  proto.mutable_size()->set_width(3);
  proto.mutable_size()->set_height(4);
  CGRect rect = [GTXProtoUtils CGRectFromProto:proto];
  XCTAssertEqual(rect.origin.x, proto.origin().x());
  XCTAssertEqual(rect.origin.y, proto.origin().y());
  XCTAssertEqual(rect.size.width, proto.size().width());
  XCTAssertEqual(rect.size.height, proto.size().height());
}

- (void)testProtoFromUIColor {
  CGFloat r = 1.0;
  CGFloat g = 0.5;
  CGFloat b = 0.25;
  CGFloat a = 0.125;
  UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
  ColorProto proto = [GTXProtoUtils protoFromUIColor:color];
  XCTAssertEqual(proto.r(), r);
  XCTAssertEqual(proto.g(), g);
  XCTAssertEqual(proto.b(), b);
  XCTAssertEqual(proto.a(), a);
}

@end
