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

#import "GTXChecking.h"
#import "GTXSnapshotContainer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A delegate protocol for listening to events occurring in the @c GTXArtifactProcessor.
 */
@protocol GTXArtifactProcessorDelegate <NSObject>

- (void)artifactProcessorDidProcessSnapshotContainer;
- (void)artifactProcessorDidShutdown;

@end

typedef void (^GTXArtifactProcessorReportFetchBlock)(GTXReport *report);

/**
 *  An artifact processor which can process artifacts on background threads.
 */
@interface GTXArtifactProcessor : NSObject

/**
 *  Use initWithChecks:delegate: instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Initializes a new artifact processor to work with the given set of checks.
 *
 *  @param checks The checks to be performed on the snapshots.
 *  @param delegate An optional delegate to recieve callback of checks processing.
 *
 *  @return a new artifact processor.
 */
- (instancetype)initWithChecks:(NSArray<id<GTXChecking>> *)checks
                      delegate:(nullable id<GTXArtifactProcessorDelegate>)delegate;

/**
 *  Starts a background thread to process the submitted snapshots.
 */
- (void)startProcessing;

/**
 *  Stops the backgorund processing of snapshots, any snapshots submitted after this call may not
 *  be processed.
 */
- (void)stopProcessing;

/**
 *  Fetches the latest report held by the processor and invokes the given callback with it.
 *
 *  @param fetchBlock A callback to invoke once the report is prepared.
 */
- (void)fetchLatestReportAsync:(GTXArtifactProcessorReportFetchBlock)fetchBlock;

/**
 *  Adds a snapshot container into the artifact processor's internal buffer for processing.
 *
 *  @param container The snapshot container to be processed.
 *
 *  @return @c YES if the container was successfully added, @c NO otherwise.
 */
- (BOOL)addSnapshotContainerForProcessing:(GTXSnapshotContainer *)container;

@end

NS_ASSUME_NONNULL_END
