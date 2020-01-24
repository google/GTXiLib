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

@implementation GTXReport {
  NSMutableArray *_uniqueErrors;
  NSMutableSet *_errorHashes;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _uniqueErrors = [[NSMutableArray alloc] init];
    _errorHashes = [[NSMutableSet alloc] init];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  GTXReport *reportCopy = [[[self class] allocWithZone:zone] init];
  reportCopy->_uniqueErrors = [_uniqueErrors copyWithZone:zone];
  reportCopy->_errorHashes = [_errorHashes copyWithZone:zone];
  return reportCopy;
}

- (void)addByDeDupingErrors:(NSArray<GTXError *> *)errors {
  for (GTXError *error in errors) {
    NSString *errorID = error.hashString;
    // Note that when de-duping elements of the same class that have nearly the same properties and
    // do not have accessibility IDs or labels to differentiate between them (such as cells in a
    // collection view) we will consider each of them as a new issue rather than one issue with
    // duplicates. This might show duplicates in reports but we can ensure that we catch issues that
    // actually manifest in different places in the report.
    if (![_errorHashes containsObject:errorID]) {
      [_errorHashes addObject:errorID];
      [_uniqueErrors addObject:error];
    }
  }
}

- (void)forEachError:(GTXReportHandler)handler {
  for (GTXError *error in _uniqueErrors) {
    handler(error);
  }
}

@end
