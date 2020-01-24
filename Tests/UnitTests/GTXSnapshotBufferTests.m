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

#import "GTXSnapshotBuffer.h"

static const NSInteger kMaxSnapshots = 100;

#pragma mark - Test Artifacts

@interface GTXTestArtifact : NSObject<GTXArtifactImplementing>
@end

@implementation GTXTestArtifact

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

#pragma mark - Tests

@interface GTXSnapshotBufferTests : XCTestCase
@end

@implementation GTXSnapshotBufferTests

- (void)testSnapshotCanBeCreatedAndRetrievedFromSharedBuffer {
  GTXSnapshotBuffer *sharedBuffer = [[GTXSnapshotBuffer alloc] init];
  // Make a background thread put snapshots into buffer.
  [self performSelectorInBackground:@selector(gtxtest_putSnapshotsFromBackground:)
                         withObject:sharedBuffer];

  // On main thread attempt to retrieve them.
  NSMutableSet *snapshots = [[NSMutableSet alloc] init];
  BOOL mainThreadWasWaitingAtleastOnce = NO;
  while ((NSInteger)snapshots.count != kMaxSnapshots) {
    GTXSnapshotContainer *snapshot = [sharedBuffer getNextSnapshotsContainer];
    if (snapshot) {
      XCTAssertFalse([snapshots containsObject:snapshot], @"Got a stale object from buffer");
      [snapshots addObject:snapshot];
    } else {
      mainThreadWasWaitingAtleastOnce = YES;
    }
  }
  XCTAssertTrue(mainThreadWasWaitingAtleastOnce,
                @"Main thread and background thread were not interleaved");
}

#pragma mark - Private

/**
 *  Puts kMaxSnapshots snapshots into the given shared buffer, this method must only be invoked from
 *  background thread.
 */
- (void)gtxtest_putSnapshotsFromBackground:(GTXSnapshotBuffer *)sharedBuffer {
  XCTAssertFalse([NSThread isMainThread]);
  for (NSInteger i = 0; i < kMaxSnapshots; i++) {
    GTXSnapshotContainer *snapshot =
        [[GTXSnapshotContainer alloc] initWithSnapshots:@[[[GTXTestArtifact alloc] init]]];
    [sharedBuffer putSnapshotsContainer:snapshot];
  }
}

@end
