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

#import "GTXCheckResult.h"

#import "GTXAssertions.h"
#import "NSError+GTXAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GTXCheckResult

- (instancetype)initWithCheckName:(NSString *)checkName
                 errorDescription:(NSString *)errorDescription {
  self = [super init];
  if (self) {
    GTX_ASSERT(checkName, @"checkName must be nonnull.");
    GTX_ASSERT(errorDescription, @"errorDescription must be nonnull.");
    _checkName = [checkName copy];
    _errorDescription = [errorDescription copy];
  }
  return self;
}

+ (instancetype)checkResultFromError:(NSError *)error {
  GTX_ASSERT(error, @"error must not be nil");
  NSString *checkName = error.userInfo[kGTXErrorCheckNameKey];
  NSString *errorDescription = error.userInfo[NSLocalizedDescriptionKey];
  GTX_ASSERT(checkName, @"error.userInfo must contain an entry for kGTXErrorCheckNameKey");
  GTX_ASSERT(errorDescription,
             @"error.userInfo must contain an entry for NSLocalizedDescriptionKey");
  return [[GTXCheckResult alloc] initWithCheckName:checkName errorDescription:errorDescription];
}

@end

NS_ASSUME_NONNULL_END
