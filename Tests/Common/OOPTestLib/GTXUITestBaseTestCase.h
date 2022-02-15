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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GTXTestViewController.h"

/**
 Base test for all GTXiLib functional/integration tests used to setup GTXiLib and capture check
 failures.
 */
@interface GTXUITestBaseTestCase : XCTestCase

/**
 Sets the expected failure count for the current test when run to completion.
 */
- (void)setExpectedFailureCount:(NSInteger)expectedCount;

@end
