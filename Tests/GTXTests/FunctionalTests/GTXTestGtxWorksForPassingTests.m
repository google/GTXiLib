//
// Copyright 2018 Google Inc.
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

#import "GTXiLib.h"
#import "GTXTestBaseTest.h"

@interface GTXTestGtxWorksForPassingTests : GTXTestBaseTest
@end

@implementation GTXTestGtxWorksForPassingTests

+ (void)setUp {
  [super setUp];
  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:@[ gAlwaysPass ]
          elementExcludeLists:@[]];
}

- (void)tearDown {
  [self assertNoFailure];

  [super tearDown];
}

- (void)testFirstEmpty {
  // This test exists to ensure teardown is called.
}

- (void)testSecondEmpty {
  // This test exists to ensure teardown is called.
}

@end
