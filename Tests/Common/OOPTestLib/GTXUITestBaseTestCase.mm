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

#import "GTXUITestBaseTestCase.h"

#import "GTXiLib.h"

@implementation GTXUITestBaseTestCase {
  NSInteger _expectedFailureCount;
  NSInteger _actualFailureCount;
}

- (void)setUp {
  [super setUp];

  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelDeveloper];
  __weak typeof(self) weakSelf = self;
  [GTXiLib setFailureHandler:^(NSError* _Nonnull error) {
    typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf->_actualFailureCount += 1;
    }
  }];
}

- (void)tearDown {
  [super tearDown];

  XCTAssertEqual(_expectedFailureCount, _actualFailureCount);
  _actualFailureCount = 0;
}

- (void)setExpectedFailureCount:(NSInteger)expectedCount {
  _expectedFailureCount = expectedCount;
}

@end
