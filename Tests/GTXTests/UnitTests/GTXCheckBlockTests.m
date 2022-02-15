//
// Copyright 2021 Google Inc.
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

#import "GTXCheckBlock.h"

#import "NSError+GTXAdditions.h"
#import "GTXBaseTestCase.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTXCheckBlockTests : GTXBaseTestCase

/**
 * The check block under test. Always fails and returns description "original".
 */
@property(strong, nonatomic) GTXCheckBlock *checkBlockUnderTest;

@end

@implementation GTXCheckBlockTests

- (void)setUp {
  self.checkBlockUnderTest =
      [GTXCheckBlock GTXCheckWithName:@"test"
                                block:^BOOL(id element, GTXErrorRefType errorOrNil) {
                                  [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                                                   element:element
                                                                      name:@"test"
                                                               description:@"original"];
                                  return NO;
                                }];
}

- (void)testCheckWithNoMessageProviderReturnsOriginalMessage {
  NSError *error;
  NSObject *element = [self newAccessibleElement];

  [self.checkBlockUnderTest check:element error:&error];

  NSString *message = [[error userInfo] objectForKey:kGTXErrorDescriptionKey];
  XCTAssertEqualObjects(message, @"original");
}

- (void)testCheckWithReplacingMessageProviderReturnsNewMessage {
  NSError *error;
  NSObject *element = [self newAccessibleElement];
  [self.checkBlockUnderTest
      registerMessageProvider:^NSString *(NSString *originalMessage, id element, NSError *error) {
        return @"new";
      }];

  [self.checkBlockUnderTest check:element error:&error];

  NSString *message = [[error userInfo] objectForKey:kGTXErrorDescriptionKey];
  XCTAssertEqualObjects(message, @"new");
}

- (void)testCheckWithAppendingMessageProviderReturnsNewMessage {
  NSError *error;
  NSObject *element = [self newAccessibleElement];
  [self.checkBlockUnderTest
      registerMessageProvider:^NSString *(NSString *originalMessage, id element, NSError *error) {
        return [originalMessage stringByAppendingString:@" appended"];
      }];

  [self.checkBlockUnderTest check:element error:&error];

  NSString *message = [[error userInfo] objectForKey:kGTXErrorDescriptionKey];
  XCTAssertEqualObjects(message, @"original appended");
}

- (void)testCheckWithAppendingThenReplacingMessageProviderReturnsReplacedMessage {
  NSError *error;
  NSObject *element = [self newAccessibleElement];
  [self.checkBlockUnderTest
      registerMessageProvider:^NSString *(NSString *originalMessage, id element, NSError *error) {
        return [originalMessage stringByAppendingString:@" appended"];
      }];
  [self.checkBlockUnderTest
      registerMessageProvider:^NSString *(NSString *originalMessage, id element, NSError *error) {
        return @"new";
      }];

  [self.checkBlockUnderTest check:element error:&error];

  NSString *message = [[error userInfo] objectForKey:kGTXErrorDescriptionKey];
  XCTAssertEqualObjects(message, @"new");
}

- (void)testCheckWithReplacingThenAppendingMessageProviderReturnsBothMessages {
  NSError *error;
  NSObject *element = [self newAccessibleElement];
  [self.checkBlockUnderTest
      registerMessageProvider:^NSString *(NSString *originalMessage, id element, NSError *error) {
        return @"new";
      }];
  [self.checkBlockUnderTest
      registerMessageProvider:^NSString *(NSString *originalMessage, id element, NSError *error) {
        return [originalMessage stringByAppendingString:@" appended"];
      }];

  [self.checkBlockUnderTest check:element error:&error];

  NSString *message = [[error userInfo] objectForKey:kGTXErrorDescriptionKey];
  XCTAssertEqualObjects(message, @"new appended");
}

@end

NS_ASSUME_NONNULL_END
