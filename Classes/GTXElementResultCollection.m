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

#import "GTXElementResultCollection.h"

#import "GTXAssertions.h"
#import "NSError+GTXAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GTXElementResultCollection

- (instancetype)initWithElement:(GTXElementReference *)element
                   checkResults:(NSArray<GTXCheckResult *> *)checkResults {
  self = [super init];
  if (self) {
    _elementReference = element;
    _checkResults = [checkResults copy];
  }
  return self;
}

- (instancetype)initWithError:(NSError *)error {
  GTX_ASSERT(error, @"error cannot be nil.");
  NSArray<NSError *> *underlyingErrors = error.userInfo[kGTXErrorUnderlyingErrorsKey];
  GTX_ASSERT(underlyingErrors.count != 0,
             @"error.userInfo must have a nonempty value for key kGTXErrorUnderlyingErrorsKey.");
  GTXElementReference *elementReference = [[GTXElementReference alloc] initWithError:error];
  NSMutableArray<GTXCheckResult *> *checkResults = [[NSMutableArray alloc] init];
  for (NSError *underlyingError in underlyingErrors) {
    [checkResults addObject:[GTXCheckResult checkResultFromError:underlyingError]];
  }
  return [self initWithElement:elementReference checkResults:checkResults];
}

@end

NS_ASSUME_NONNULL_END
