//
// Copyright 2019 Google Inc.
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

#import "GTXReport.h"

// A monotonically increasing ID used to generate unique IDs for errors that refer to unknown
// elements.
static NSInteger gNextNilID;

@interface GTXError ()

@property(nonatomic, weak) id element;
@property(nonatomic, copy) NSString *elementID;
@property(nonatomic, copy) NSString *checkName;
@property(nonatomic, copy) NSString *errorTitle;
@property(nonatomic, copy) NSString *errorDescription;
@property(nonatomic, copy) NSString *hashString;

@end

@implementation GTXError

+ (instancetype)errorWithElement:(id)element
                       elementID:(NSString *)elementID
                       checkName:(NSString *)checkName
                      errorTitle:(NSString *)errorTitle
                errorDescription:(NSString *)errorDescription {
  GTXError *error = [[GTXError alloc] init];
  error.element = element;
  error.elementID = elementID;
  error.checkName = checkName;
  error.errorTitle = errorTitle;
  error.errorDescription = errorDescription;
  return error;
}

- (NSString *)hashString {
  if (!_hashString) {
    NSString *elementID = _elementID;
    if (!elementID) {
      elementID = [NSString stringWithFormat:@"nil_elementID_%d", (int)gNextNilID];
      gNextNilID += 1;
    }
    NSString *checkName = _checkName;
    if (!checkName) {
      checkName = [NSString stringWithFormat:@"nil_check_%d", (int)gNextNilID];
      gNextNilID += 1;
    }
    _hashString = [NSString stringWithFormat:@"%@:%@", elementID, checkName];
  }
  return _hashString;
}

@end
