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

#import "GTXChecking.h"

/**
 Implements an OCR based contrast check that works by first identifying text regions on the
 element's UI and performs a contrast check only on them. Since we do not rely on the element being
 a UIKit's text view this check will work with custom elements as well.
 @note This check requires iOS 11 for VisionKit APIs that identify text.
 */
API_AVAILABLE(ios(11.0))
@interface GTXOCRContrastCheck : NSObject <GTXChecking>

- (instancetype)init NS_UNAVAILABLE;

/**
 Creates an instance of @c GTXOCRContrastCheck with the given @c name and @c minRatio.
 */
- (instancetype)initWithName:(NSString *)name expectedMinimumContrastRatio:(CGFloat)minRatio;

@end
