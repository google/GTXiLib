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

#import <Foundation/Foundation.h>

/**
 Class to hold all the data related to a single test case.
 */
@interface GTXTestCase : NSObject

/**
 The test class to which this test belongs.
 */
@property (nonatomic, strong) Class testClass;

/**
 The selector to the test method in the mentioned test class.
 */
@property (nonatomic, assign) SEL testCaseSelector;

- (instancetype)init NS_UNAVAILABLE;

/**
 Initialize a new instance, use this instead of init.

 @param testClass The test class to which this test belongs.
 @param testCaseSelector The selector to the test method in the mentioned test class.
 @return A new GTXTestCase instance.
 */
- (instancetype)initWithTestClass:(Class)testClass selector:(SEL)testCaseSelector;

@end
