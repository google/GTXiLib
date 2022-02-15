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

#import "GTXOCRContrastCheck.h"

#import <Vision/Vision.h>

#import "GTXAssertions.h"
#import "GTXChecksCollection.h"
#import "GTXImageAndColorUtils.h"
#import "NSError+GTXAdditions.h"
#import "GTXImageRGBAData+GTXOOPAdditions.h"
#import "UIColor+GTXOOPAdditions.h"
#import "UIColor+GTXAdditions.h"
#include "contrast_swatch.h"

/**
 @return A @c CGRect equal to @c inRect scaled by the given @c scaleX in x-direction and @c scaleY
 in y-direction.
 */
static CGRect GTXScaleCGRect(CGRect inRect, CGFloat scaleX, CGFloat scaleY);

@implementation GTXOCRContrastCheck {
  CGFloat _minRatio;
  NSString *_name;
}

- (instancetype)initWithName:(NSString *)name expectedMinimumContrastRatio:(CGFloat)minRatio {
  self = [super init];
  if (self) {
    _minRatio = minRatio;
    _name = [name copy];
  }
  return self;
}

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  if (@available(iOS 11.0, *)) {
    if (![GTXChecksCollection isTextDisplayingElement:element]) {
      return YES;
    }
    UIImage *elementImage = [GTXImageAndColorUtils imageFromUIView:element];
    CGSize size = elementImage.size;
    __block NSString *errorDescription = nil;
    VNDetectTextRectanglesRequest *request = [[VNDetectTextRectanglesRequest
        alloc] initWithCompletionHandler:^(VNRequest *_Nonnull request, NSError *_Nullable error) {
      NSArray *results = request.results;
      NSUInteger resultsRemaining = results.count;
      for (VNTextObservation *observation in results) {
        resultsRemaining -= 1;
        // Observation bounding box is normalized 0 - 1, 0 being empty and 1 being input size,
        // we must scale it and flip y to get it to input image cordinates.
        CGRect rect = GTXScaleCGRect(observation.boundingBox, size.width, size.height);
        rect.origin.y = size.height - CGRectGetMaxY(rect);
        // Finally scale the rect to image scale to get it to pixel coordinates.
        rect = GTXScaleCGRect(rect, elementImage.scale, elementImage.scale);

        // Extract the sub-image that has text for contrast analysis.
        CGImageRef subCGImage = CGImageCreateWithImageInRect(elementImage.CGImage, rect);
        UIImage *subImage = [UIImage imageWithCGImage:subCGImage];
        CGImageRelease(subCGImage);
        GTXImageRGBAData *imageRGBAData = [[GTXImageRGBAData alloc] initWithUIImage:subImage];
        auto image = [imageRGBAData gtxImage];
        gtx::Rect gtxRect(0, 0, rect.size.width, rect.size.height);
        gtx::ContrastSwatch swatch = gtx::ContrastSwatch::Extract(*image, gtxRect);
        UIColor *foregroundColor = [UIColor gtx_colorFromGTXColor:swatch.foreground()];
        UIColor *backgroundColor = [UIColor gtx_colorFromGTXColor:swatch.background()];
        CGFloat foregroundLuminance = [GTXImageAndColorUtils luminanceWithColor:foregroundColor];
        CGFloat backgroundLuminance = [GTXImageAndColorUtils luminanceWithColor:backgroundColor];
        CGFloat ratio =
            [GTXImageAndColorUtils contrastRatioWithLuminaceOfFirstColor:foregroundLuminance
                                               andLuminanceOfSecondColor:backgroundLuminance];
        if (ratio < _minRatio) {
          // This error postfix indicates if user might see contrast failures even after fixing
          // the current issue.
          NSString *errorPostfix = resultsRemaining > 0
                                       ? @" Additional text was detected on this element, which "
                                         @"may require manual evaluation"
                                       : @"";
          errorDescription = [NSString
              stringWithFormat:@"Low contrast text with an estimated foreground color of %@, "
                               @"estimated background color of %@, and contrast ratio of %@:1 "
                               @"was detected at %@. Expected minimium contrast ratio was %@.%@",
                               [foregroundColor gtx_description], [backgroundColor gtx_description],
                               @(ratio), NSStringFromCGRect(rect), @(_minRatio), errorPostfix];
          break;
        }
      }
    }];
    // Enable reportCharacterBoxes to get bounding boxes which is what we use.
    request.reportCharacterBoxes = YES;
    VNImageRequestHandler *handler =
        [[VNImageRequestHandler alloc] initWithCGImage:elementImage.CGImage options:@{}];
    NSError *requestError;
    [handler performRequests:@[ request ] error:&requestError];
    BOOL success = errorDescription == nil;
    GTX_ASSERT(requestError == nil, @"Unable to analyze image due to %@.", requestError);
    if (!success) {
      [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                       element:element
                                          name:self.name
                                   description:errorDescription];
    }
    return success;
  }
  return YES;
}

- (NSString *)name {
  return _name;
}

@end

#pragma mark - Utils

static CGRect GTXScaleCGRect(CGRect inRect, CGFloat scaleX, CGFloat scaleY) {
  return CGRectMake(inRect.origin.x * scaleX, inRect.origin.y * scaleY, inRect.size.width * scaleX,
                    inRect.size.height * scaleY);
}
