//
// Copyright 2018 Google Inc.
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

#import "GTXImageRGBAData.h"

@implementation GTXImageRGBAData

- (instancetype)initWithUIImage:(UIImage *)image {
  self = [super init];
  if (self) {
    _rgba = [GTXImageRGBAData RGBADataFromImage:image
                                       outWidth:&_width
                                      outheight:&_height
                                 outbytesPerRow:&_bytesPerRow];
  }
  return self;
}

- (NSUInteger)bytesPerPixel {
  return 4;
}

/**
 *  Provides RGBA pixel data for the given UIImage.
 *
 *  @param image The image whose RGBA data is to be extracted.
 *  @param[out] outWidth Populated with the image width, if provided.
 *  @param[out] outHeight Populated with the image height, if provided.
 *  @param[out] outBytesPerRow Populated with the byte count per row, if provided.
 *
 *  @return pointer to RGBA data for the given image.
 */
+ (unsigned char *)RGBADataFromImage:(UIImage *)image
                            outWidth:(NSUInteger *)outWidth
                           outheight:(NSUInteger *)outHeight
                      outbytesPerRow:(NSUInteger *)outBytesPerRow {
  // Extract the image dimentions.
  CGImageRef imageRef = [image CGImage];
  NSUInteger width = CGImageGetWidth(imageRef);
  NSUInteger height = CGImageGetHeight(imageRef);

  // Allocate an array to store the rgba values.
  const NSUInteger bytesPerPixel = 4;
  const NSUInteger bytesPerRow = bytesPerPixel * width;
  const NSUInteger bitsPerComponent = 8;
  unsigned char *rgba = (unsigned char *)malloc(height * width * bytesPerPixel);

  // Create a bitmap context that uses the allocated array as a backing store and render the image
  // onto it.
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context =
  CGBitmapContextCreate(rgba, width, height, bitsPerComponent, bytesPerRow, colorSpace,
                        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
  CGContextRelease(context);

  // Set the out arguments.
  if (outWidth) {
    *outWidth = width;
  }
  if (outHeight) {
    *outHeight = height;
  }
  if (outBytesPerRow) {
    *outBytesPerRow = bytesPerRow;
  }
  return rgba;
}

- (void)dealloc {
  if (_rgba) {
    free(_rgba);
    _rgba = NULL;
  }
}

@end
