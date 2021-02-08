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

#import "GTXTestDynamicTypeCheckOptions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GTXTestDynamicTypeCheckOptions

- (instancetype)initWithFont:(nullable UIFont *)font
    adjustsFontForContentSizeCategory:(BOOL)adjustsFontForContentSizeCategory
                             succeeds:(BOOL)succeeds {
  self = [super init];
  if (self) {
    _font = font;
    _adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory;
    _succeeds = succeeds;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
