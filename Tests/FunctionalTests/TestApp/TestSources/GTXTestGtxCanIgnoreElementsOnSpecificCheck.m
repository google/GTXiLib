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

#import "GTXTestBaseTest.h"
#import "GTXiLib.h"

@interface GTXTestGtxCanIgnoreElementsOnSpecificCheck : GTXTestBaseTest
@end

@implementation GTXTestGtxCanIgnoreElementsOnSpecificCheck

+ (void)setUp {
  [super setUp];
  NSString *className = NSStringFromClass([GTXTestFailingClass class]);
  NSArray *blacklist =
      @[[GTXBlacklistFactory blacklistWithClassName:className
                                             checkName:checkFailsIfFailingClass.name]];
  id<GTXChecking> secondFailingCheck = [GTXiLib checkWithName:@"secondFailingCheck"
                                            block:^BOOL(id element, GTXErrorRefType errorOrNil) {
    return ![element isKindOfClass:[GTXTestFailingClass class]];
  }];
  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:@[checkFailsIfFailingClass, secondFailingCheck]
            elementBlacklists:blacklist];
  [GTXTestViewController addElementToTestArea:
      [[GTXTestFailingClass alloc] initWithFrame:CGRectMake(0, 0, 100, 100)]];
}

+ (void)tearDown {
  [GTXTestViewController clearTestArea];
  [super tearDown];
}

- (void)tearDown {
  [self assertAndClearSingleFailure];

  [super tearDown];
}

- (void)testJustToTriggerTearDown {
  // Pass
}

@end
