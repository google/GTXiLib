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

#import "GTXSnapshotContainer.h"

#pragma mark - Test Artifacts

@interface GTXTestArtifactFoo : NSObject <GTXArtifactImplementing>
@property(nonatomic, assign) NSInteger foo;
@end

@implementation GTXTestArtifactFoo

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

@interface GTXTestArtifactBar : NSObject <GTXArtifactImplementing>
@property(nonatomic, assign) NSInteger bar;
@end

@implementation GTXTestArtifactBar

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

#pragma mark - Tests

@interface GTXSnapshotTests : XCTestCase
@end

@implementation GTXSnapshotTests

- (void)testSnapshotCanBeCreatedAndRetrieved {
  GTXSnapshotContainer *snapshot = [[GTXSnapshotContainer alloc] initWithSnapshots:@[
    [[GTXTestArtifactFoo alloc] init],
    [[GTXTestArtifactBar alloc] init],
  ]];

  GTXTestArtifactFoo *fooSnapshot = [snapshot snapshotFromArtifactClass:[GTXTestArtifactFoo class]];
  GTXTestArtifactBar *barSnapshot = [snapshot snapshotFromArtifactClass:[GTXTestArtifactBar class]];
  XCTAssertTrue([fooSnapshot isKindOfClass:[GTXTestArtifactFoo class]]);
  XCTAssertTrue([barSnapshot isKindOfClass:[GTXTestArtifactBar class]]);
}

- (void)testSnapshotAssertsForMultipleSnapshotsOfSameClass {
  NSArray *sameClassSnapshots =
      @[ [[GTXTestArtifactFoo alloc] init], [[GTXTestArtifactFoo alloc] init] ];
  XCTAssertThrows([[GTXSnapshotContainer alloc] initWithSnapshots:sameClassSnapshots]);
}

- (void)testSnapshotRetrievedAssertForNonExistantClass {
  GTXSnapshotContainer *snapshot = [[GTXSnapshotContainer alloc] initWithSnapshots:@[
    [[GTXTestArtifactFoo alloc] init],
    [[GTXTestArtifactBar alloc] init],
  ]];
  XCTAssertThrows([snapshot snapshotFromArtifactClass:[self class]]);
}

@end
