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

#import "GTXTestIntegrationTestCase.h"

#import "GTXiLib.h"


@implementation GTXTestIntegrationTestCase {
  NSInteger _expectedFailureCount;
  NSInteger _actualFailureCount;
}

- (void)setUp {
  [super setUp];

  [GTXiLib setFailureHandler:^(NSError* _Nonnull error) {
    _actualFailureCount += 1;
  }];

  self.clearTestAreaOnTeardown = NO;
  [self clearTestArea];
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
