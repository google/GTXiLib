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

#import "GTXImageRGBAData+GTXOOPAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GTXImageRGBAData (GTXOOPAdditions)

- (std::unique_ptr<gtx::Image>)gtxImage {
  NSAssert(self.bytesPerPixel == 4, @"gtx::Image assumes 4 bytes per pixel, actual %d",
           static_cast<int>(self.bytesPerPixel));
  std::unique_ptr<gtx::Image> gtxImage = std::make_unique<gtx::Image>();
  gtxImage->pixels = (gtx::Pixel *)self.rgba;
  gtxImage->width = static_cast<int>(self.width);
  gtxImage->height = static_cast<int>(self.height);
  return gtxImage;
}

@end

NS_ASSUME_NONNULL_END
