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
#import <XCTest/XCTest.h>

#import "GTXImageRGBAData+GTXOOPAdditions.h"

@interface GTXImageRGBADataTests : XCTestCase
@end

@implementation GTXImageRGBADataTests

- (void)testGTXImageCanBeCreated {
  GTXImageRGBAData *data =
      [[GTXImageRGBAData alloc] initWithUIImage:[self gtxtest_testImageOfSize:CGSizeMake(5, 10)]];

  std::unique_ptr<gtx::Image> image = [data gtxImage];
  XCTAssertEqual(image->width, static_cast<int>(data.width));
  XCTAssertEqual(image->height, static_cast<int>(data.height));
  XCTAssertTrue(image->pixels != NULL);

  const NSInteger pixelCount = image->width * image->height;
  for (NSInteger i = 0; i < pixelCount; i++) {
    gtx::Pixel p = image->pixels[i];
    XCTAssertEqual(p.red, 255);
    XCTAssertEqual(p.green, 0);
    XCTAssertEqual(p.blue, 0);
    XCTAssertEqual(p.alpha, 255);
  }
}

#pragma mark - Private

/**
@return a test with the given @c size.
*/
- (UIImage *)gtxtest_testImageOfSize:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, UIColor.redColor.CGColor);
  CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
  UIImage *testImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return testImage;
}

@end
