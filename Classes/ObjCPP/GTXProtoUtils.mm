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

@implementation GTXProtoUtils

+ (RectProto)protoFromCGRect:(CGRect)rect {
  // Standardize the rect so it is safe to directly access origin and size.
  rect = CGRectStandardize(rect);
  RectProto proto;
  proto.mutable_origin()->set_x(rect.origin.x);
  proto.mutable_origin()->set_y(rect.origin.y);
  proto.mutable_size()->set_width(rect.size.width);
  proto.mutable_size()->set_height(rect.size.height);
  return proto;
}

+ (CGRect)CGRectFromProto:(RectProto)rect {
  return CGRectMake(rect.origin().x(), rect.origin().y(), rect.size().width(),
                    rect.size().height());
}

+ (ColorProto)protoFromUIColor:(UIColor *)color {
  CGFloat r, g, b, a;
  [color getRed:&r green:&g blue:&b alpha:&a];
  ColorProto proto;
  proto.set_r(r);
  proto.set_g(g);
  proto.set_b(b);
  proto.set_a(a);
  return proto;
}

@end
