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

#import <XCTest/XCTest.h>

#import "GTXArtifactCollector.h"

#pragma mark - Test Artifacts

@interface GTXTestCollectorArtifactFoo : NSObject<GTXArtifactImplementing>
@end

@implementation GTXTestCollectorArtifactFoo

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

@interface GTXTestCollectorArtifactBar : NSObject<GTXArtifactImplementing>
@end

@implementation GTXTestCollectorArtifactBar

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

@interface GTXTestCollectorArtifactBaz : NSObject<GTXArtifactImplementing>
@end

@implementation GTXTestCollectorArtifactBaz

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

#pragma mark - Test Check

/**
 *  A Test check that requires GTXTestCollectorArtifactFoo artifact.
 */
@interface GTXTestCollectorCheckNoArtifact : NSObject<GTXChecking>
@end

@implementation GTXTestCollectorCheckNoArtifact

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  return YES;
}

- (NSString *)name {
  return NSStringFromClass(self.class);
}

@end

/**
 *  A Test check that requires GTXTestCollectorArtifactFoo artifact.
 */
@interface GTXTestCollectorCheckFoo : NSObject<GTXChecking>
@end

@implementation GTXTestCollectorCheckFoo

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  return YES;
}

- (NSString *)name {
  return NSStringFromClass(self.class);
}

- (NSArray<Class<GTXArtifactImplementing>> *)requiredArtifactClasses {
  return @[GTXTestCollectorArtifactFoo.class];
}

- (BOOL)performCheckOnSnapshot:(GTXSnapshotContainer *)snapshot
                         error:(GTXErrorRefType)outError {
  return YES;
}

@end

/**
 *  A Test check that requires GTXTestCollectorArtifact{Foo,Bar} artifacts.
 */
@interface GTXTestCollectorCheckFooBar : NSObject<GTXChecking>
@end

@implementation GTXTestCollectorCheckFooBar

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  return YES;
}

- (NSString *)name {
  return NSStringFromClass(self.class);
}

- (NSArray<Class<GTXArtifactImplementing>> *)requiredArtifactClasses {
  return @[GTXTestCollectorArtifactFoo.class, GTXTestCollectorArtifactBar.class];
}

- (BOOL)performCheckOnSnapshot:(GTXSnapshotContainer *)snapshot
                         error:(GTXErrorRefType)outError {
  return YES;
}

@end

#pragma mark - Tests

@interface GTXArtifactCollectorTests : XCTestCase
@end

@implementation GTXArtifactCollectorTests

- (void)testArtifactCollectorCanTakeSnapshots {
  NSArray *checks = @[[[GTXTestCollectorCheckFoo alloc] init]];
  GTXArtifactCollector *collector = [[GTXArtifactCollector alloc] initWithChecks:checks];
  GTXSnapshotContainer *snapshot = [collector snapshot];
  XCTAssertNotNil(snapshot);
  XCTAssertNotNil([snapshot snapshotFromArtifactClass:GTXTestCollectorArtifactFoo.class]);
}

- (void)testArtifactCollectorCanTakeSnapshotsWithChecksOverlappingArtifacts {
  NSArray *checks = @[[[GTXTestCollectorCheckFoo alloc] init],
                      [[GTXTestCollectorCheckFooBar alloc] init]];
  GTXArtifactCollector *collector = [[GTXArtifactCollector alloc] initWithChecks:checks];
  GTXSnapshotContainer *snapshot = [collector snapshot];
  XCTAssertNotNil(snapshot);
  XCTAssertNotNil([snapshot snapshotFromArtifactClass:GTXTestCollectorArtifactFoo.class]);
  XCTAssertNotNil([snapshot snapshotFromArtifactClass:GTXTestCollectorArtifactBar.class]);
}

- (void)testArtifactCollectorReturnsNilForChecksThatDontSupportSnapshots {
  NSArray *checks = @[[[GTXTestCollectorCheckNoArtifact alloc] init]];
  GTXArtifactCollector *collector = [[GTXArtifactCollector alloc] initWithChecks:checks];
  GTXSnapshotContainer *snapshot = [collector snapshot];
  XCTAssertNil(snapshot);
}

@end
