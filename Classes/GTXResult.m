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

#import "GTXResult.h"
#import "NSError+GTXAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTXResult ()

@property(nonatomic, strong) NSArray<NSError *> *errorsFound;
@property(nonatomic, assign) NSInteger elementsScanned;

@end

@implementation GTXResult {
  NSError *_aggregatedError;
}

- (instancetype)initWithErrorsFound:(NSArray<NSError *> *)errorsFound
                    elementsScanned:(NSInteger)elementsScanned {
  self = [super init];
  if (self) {
    _errorsFound = errorsFound;
    _elementsScanned = elementsScanned;
  }
  return self;
}

- (BOOL)allChecksPassed {
  return self.errorsFound.count == 0;
}

- (NSError *)aggregatedError {
  if (![self allChecksPassed]) {
    // Combine the error descriptions from all the errors into the following format ('.' is an
    // indent):
    // . . Element: <element description>
    // . . . . Error: <error description>
    // . . . . Error: <error description>
    // . . Element: <element description>
    // . . . . Error: <error description>
    // . . . . Error: <error description>

    NSMutableString *errorString =
        [[NSMutableString alloc] initWithString:@"One or more elements FAILED the accessibility "
                                                @"checks:\n"];
    for (NSError *error in self.errorsFound) {
      id element = [[error userInfo] objectForKey:kGTXErrorFailingElementKey];
      if (element) {
        // Add element description with an indent.
        [errorString appendFormat:@"  %@\n", element];
        for (NSError *underlyingError in
             // Add element's error description with twice the indent.
             [[error userInfo] objectForKey:kGTXErrorUnderlyingErrorsKey]) {
          [errorString appendFormat:@"    + %@\n", [underlyingError localizedDescription]];
        }
      }
    }
    [NSError gtx_logOrSetError:&_aggregatedError
                   description:errorString
                          code:GTXCheckErrorCodeGenericError
                      userInfo:@{kGTXErrorUnderlyingErrorsKey : self.errorsFound}];
  }
  return _aggregatedError;
}

@end

NS_ASSUME_NONNULL_END
