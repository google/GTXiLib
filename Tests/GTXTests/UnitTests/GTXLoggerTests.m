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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GTXLogger.h"
#import "NSObject+GTXLogging.h"

@interface GTXLoggerTests : XCTestCase
@end

@implementation GTXLoggerTests {
  NSArray<GTXLogProperty *> *_overriddenLogProperties;
  NSArray<GTXLogProperty *> *_appendedLogProperties;
  GTXLogProperty *_testLogProperty;
  NSInteger _testLogPropertyUseCount;
}

- (void)setUp {
  _overriddenLogProperties = _appendedLogProperties = nil;
  _testLogPropertyUseCount = 0;
  __weak typeof(self) weakSelf = self;
  _testLogProperty = [GTXLogProperty propertyWithName:@"foo"
                               isDeveloperLogProperty:NO
                                      descriptorBlock:^NSString *(NSObject *object) {
                                        typeof(self) strongSelf = weakSelf;
                                        if (strongSelf) {
                                          strongSelf->_testLogPropertyUseCount += 1;
                                        }
                                        return @"bar";
                                      }];
}

- (void)testGTXLoggerUsesNonDeveloperPropertiesInInfoLogs {
  _testLogProperty.isDeveloperLogProperty = NO;
  _appendedLogProperties = @[ _testLogProperty ];
  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelInfo];
  [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelInfo
                                      prefix:@"baz"
                         descriptionOfObject:self];
  XCTAssertNotEqual(_testLogPropertyUseCount, 0);
}

- (void)testGTXLoggerDoesNotUseDevOnlyPropertiesInInfoLogs {
  _testLogProperty.isDeveloperLogProperty = YES;
  _appendedLogProperties = @[ _testLogProperty ];
  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelInfo];
  [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelInfo
                                      prefix:@"baz"
                         descriptionOfObject:self];
  XCTAssertEqual(_testLogPropertyUseCount, 0);
}

- (void)testGTXLoggerUsesDeveloperPropertiesInDevLogs {
  _testLogProperty.isDeveloperLogProperty = YES;
  _appendedLogProperties = @[ _testLogProperty ];
  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelDeveloper];
  [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelDeveloper
                                      prefix:@"baz"
                         descriptionOfObject:self];
  XCTAssertNotEqual(_testLogPropertyUseCount, 0);
}

- (void)testGTXLoggerUsesOveriddenNonDeveloperPropertiesInInfoLogs {
  _testLogProperty.isDeveloperLogProperty = NO;
  _overriddenLogProperties = @[ _testLogProperty ];
  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelInfo];
  [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelInfo
                                      prefix:@"baz"
                         descriptionOfObject:self];
  XCTAssertNotEqual(_testLogPropertyUseCount, 0);
}

- (void)testGTXLoggerDoesNotUseOverriddenDevOnlyPropertiesInInfoLogs {
  _testLogProperty.isDeveloperLogProperty = YES;
  _overriddenLogProperties = @[ _testLogProperty ];
  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelInfo];
  [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelInfo
                                      prefix:@"baz"
                         descriptionOfObject:self];
  XCTAssertEqual(_testLogPropertyUseCount, 0);
}

- (void)testGTXLoggerUsesOverriddenDeveloperPropertiesInDevLogs {
  _testLogProperty.isDeveloperLogProperty = YES;
  _overriddenLogProperties = @[ _testLogProperty ];
  [[GTXLogger defaultLogger] setLogLevel:GTXLogLevelDeveloper];
  [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelDeveloper
                                      prefix:@"baz"
                         descriptionOfObject:self];
  XCTAssertNotEqual(_testLogPropertyUseCount, 0);
}

#pragma mark - GTXLogging

- (NSArray<GTXLogProperty *> *)gtx_logProperties {
  // Assert that only one of _overriddenLogProperties or _appendedLogProperties is used.
  XCTAssertTrue((_overriddenLogProperties && !_appendedLogProperties) ||
                    (!_overriddenLogProperties && _appendedLogProperties),
                @"Only one of _appendedLogProperties or _appendedLogProperties must be used.");
  if (_overriddenLogProperties) {
    return _overriddenLogProperties;
  } else {
    return [[super gtx_logProperties] arrayByAddingObjectsFromArray:_appendedLogProperties];
  }
}

@end
