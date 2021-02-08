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

#import <UIKit/UIKit.h>

/**
 *  Class for holding RGBA pixel data when processing images. This class allocates memory to hold
 *  the buffer required for RGBA data deallocates it when object is released.
 */
@interface GTXImageRGBAData : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithUIImage:(UIImage *)image;

/**
 *  Pointer to rgba data (in that order) of the provided image in row major order.
 */
@property(nonatomic, readonly) unsigned char *rgba NS_RETURNS_INNER_POINTER;

/**
 *  Width of the image as available in the rgba data.
 */
@property(nonatomic, readonly) NSUInteger width;

/**
 *  Height of the image as available in the rgba data.
 */
@property(nonatomic, readonly) NSUInteger height;

/**
 *  Number of bytes used for storing a single pixel in the rgba data.
 */
@property(nonatomic, readonly) NSUInteger bytesPerPixel;

/**
 *  Number of bytes in a single row of rgba data.
 */
@property(nonatomic, readonly) NSUInteger bytesPerRow;

@end
