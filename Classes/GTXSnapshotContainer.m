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

#import "GTXSnapshotContainer.h"

#import "GTXAssertions.h"

@implementation GTXSnapshotContainer {
  NSDictionary *snapshotFromClass;
}

- (instancetype)initWithSnapshots:(NSArray<id<GTXArtifactImplementing>> *)uniqueSnapshots {
  GTX_ASSERT(uniqueSnapshots.count > 0, @"Attempting to create empty container");
  self = [super init];
  if (self) {
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (id<GTXArtifactImplementing> snapshot in uniqueSnapshots) {
      Class<GTXArtifactImplementing> cls = [snapshot class];
      GTX_ASSERT(![map.allKeys containsObject:cls],
                 @"Duplicate snapshots for %@ class in %@", cls, uniqueSnapshots);
      map[(id<NSCopying>)cls] = snapshot;
    }
    snapshotFromClass = map;
  }
  return self;
}

- (id<GTXArtifactImplementing>)snapshotFromArtifactClass:(Class<GTXArtifactImplementing>)cls {
  id<GTXArtifactImplementing> snapshot = snapshotFromClass[cls];
  GTX_ASSERT(snapshot, @"Snapshot was not present for %@", cls);
  return snapshot;
}

@end
