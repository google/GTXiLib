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

#import <Foundation/Foundation.h>

#import "GTXArtifactCollector.h"
#import "GTXAssertions.h"

@implementation GTXArtifactCollector {
  NSArray<Class<GTXArtifactImplementing>> *_artifactClasses;
}

- (instancetype)initWithChecks:(NSArray<id<GTXChecking>> *)checks {
  self = [super init];
  if (self) {
    // Get the set of all (unique) Artifact classes that the checks need.
    NSMutableSet *classes = [[NSMutableSet alloc] init];
    for (id<GTXChecking> check in checks) {
      if ([check respondsToSelector:@selector(requiredArtifactClasses)]) {
        [classes addObjectsFromArray:[check requiredArtifactClasses]];
      }
    }
    _artifactClasses = [classes allObjects];
  }
  return self;
}

- (GTXSnapshotContainer *)snapshot {
  GTX_ASSERT([NSThread isMainThread], @"Snapshots cannot be taken on non-main threads");
  NSMutableArray<id<GTXArtifactImplementing>> *snapshots = [[NSMutableArray alloc] init];
  for (Class<GTXArtifactImplementing> cls in _artifactClasses) {
    id<GTXArtifactImplementing> snapshot = [cls createArtifactSnapshot];
    GTX_ASSERT(snapshot, @"Could not fetch a snapshot");
    [snapshots addObject:snapshot];
  }
  return snapshots.count > 0 ? [[GTXSnapshotContainer alloc] initWithSnapshots:snapshots] : nil;
}

@end
