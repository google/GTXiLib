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

#import "GTXHierarchyResultCollection.h"

#import "GTXAssertions.h"
#import "GTXImageAndColorUtils.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GTXHierarchyResultCollection

- (instancetype)initWithElementResults:(NSArray<GTXElementResultCollection *> *)elementResults
                            screenshot:(UIImage *)screenshot {
  self = [super init];
  if (self) {
    GTX_ASSERT(elementResults, @"elementResults must be nonnil.");
    GTX_ASSERT(screenshot, @"screenshot must be nonnil.");
    _elementResults = [elementResults copy];
    _screenshot = screenshot;
  }
  return self;
}

- (instancetype)initWithErrors:(nullable NSArray<NSError *> *)errors
                     rootViews:(NSArray<UIView *> *)rootViews {
  GTX_ASSERT(rootViews.count > 0, @"rootViews must be nonnil and nonempty.");
  NSMutableArray<GTXElementResultCollection *> *elementResults = [[NSMutableArray alloc] init];
  for (NSError *error in errors) {
    [elementResults addObject:[[GTXElementResultCollection alloc] initWithError:error]];
  }
  UIImage *screenshot = [GTXImageAndColorUtils imageByCompositingViews:rootViews];
  return [self initWithElementResults:elementResults screenshot:screenshot];
}

- (NSUInteger)checkResultCount {
  NSUInteger count = 0;
  for (GTXElementResultCollection *result in self.elementResults) {
    count += result.checkResults.count;
  }
  return count;
}

@end

NS_ASSUME_NONNULL_END
