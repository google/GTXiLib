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

#import "GTXSnapshotContainer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  @c GTXSnapshotBuffer instances are thread safe FIFO buffers for @c GTXSnapshotContainer objects.
 */
@interface GTXSnapshotBuffer : NSObject

/**
 *  Puts the given @c newSnapshots object into the buffer.
 */
- (void)putSnapshotsContainer:(GTXSnapshotContainer *)newSnapshots;

/**
 *  Gets the next snapshot container object from the buffer or @c nil if the buffer is empty.
 */
- (nullable GTXSnapshotContainer *)getNextSnapshotsContainer;

@end

NS_ASSUME_NONNULL_END
