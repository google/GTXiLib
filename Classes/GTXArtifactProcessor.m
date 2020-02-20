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

#import "GTXArtifactProcessor.h"

#import <Foundation/Foundation.h>

#import "GTXAssertions.h"
#import "GTXSnapshotBuffer.h"

@implementation GTXArtifactProcessor {
  NSArray<id<GTXChecking>> *_checks;
  id<GTXArtifactProcessorDelegate> _delegate;
  volatile BOOL _isShuttingDown;
  GTXSnapshotBuffer *_buffer;
  GTXReport *_report;

  // GTXArtifactProcessor uses a command buffer model to deal with multi-threading: all
  // processing and its associated tasks enqueue as commands on a command queue and are executed
  // from it. @c _queueKey and @c _queueContext are used to ensure that commands related code is
  // only invoked from the command queue context.
  dispatch_queue_t _commandQueue;
  void *_queueKey, *_queueContext;
}

- (instancetype)initWithChecks:(NSArray<id<GTXChecking>> *)checks
                      delegate:(id<GTXArtifactProcessorDelegate>)delegate {
  self = [super init];
  if (self) {
    _checks = checks;
    _delegate = delegate;
    _buffer = [[GTXSnapshotBuffer alloc] init];
  }
  return self;
}

- (void)startProcessing {
  GTX_ASSERT(!_commandQueue, @"GTXArtifactProcessor was already started");
  _report = [[GTXReport alloc] init];
  _commandQueue =
      dispatch_queue_create("com.google.gtxilib.artifactprocessor", DISPATCH_QUEUE_SERIAL);
  _queueKey = &_queueKey;
  _queueContext = &_queueContext;
  dispatch_queue_set_specific(_commandQueue, _queueKey, _queueContext, NULL);
}

- (void)stopProcessing {
  __weak typeof(self) weakSelf = self;
  dispatch_async(_commandQueue, ^{
    [weakSelf gtx_commandForProcessorShutdown];
  });
}

- (BOOL)addSnapshotContainerForProcessing:(GTXSnapshotContainer *)container {
  if (_isShuttingDown) {
    return NO;
  }
  [_buffer putSnapshotsContainer:container];
  __weak typeof(self) wSelf = self;
  dispatch_async(_commandQueue, ^{
    [wSelf gtx_commandForProcessingNextSnapshot];
  });
  return YES;
}

- (void)fetchLatestReportAsync:(GTXArtifactProcessorReportFetchBlock)fetchBlock {
  __weak typeof(self) weakSelf = self;
  dispatch_async(_commandQueue, ^{
    [weakSelf gtx_commandForReportFetch:fetchBlock];
  });
}

#pragma mark - Artifact Processor Command Implementations

- (void)gtx_assertCallerIsCommandQueue {
  void *context = dispatch_queue_get_specific(_commandQueue, _queueKey);
  (void)context;  // Marking context as used when below assert is removed due to compiler
                  // optimizations.
  GTX_ASSERT(context == _queueContext, @"This method can only be executed from command queue.");
}

- (void)gtx_commandForProcessingNextSnapshot {
  [self gtx_assertCallerIsCommandQueue];
  if (_isShuttingDown) {
    return;
  }
  GTXSnapshotContainer *container = [_buffer getNextSnapshotsContainer];
  if (container) {
    // Process this container and add errors to the report.
    for (id<GTXChecking> check in _checks) {
      if ([check respondsToSelector:@selector(performCheckOnSnapshot:addingErrorsToReport:)]) {
        [check performCheckOnSnapshot:container addingErrorsToReport:_report];
        // @TODO: Consider adding all passing elements to the report as well, it might be useful to
        // look at all the elements that were scanned.
      }
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      typeof(self) strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf->_delegate artifactProcessorDidProcessSnapshotContainer];
      }
    });
  }
}

- (void)gtx_commandForProcessorShutdown {
  [self gtx_assertCallerIsCommandQueue];
  _isShuttingDown = YES;
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf->_delegate artifactProcessorDidShutdown];
    }
  });
}

- (void)gtx_commandForReportFetch:(GTXArtifactProcessorReportFetchBlock)fetchBlock {
  [self gtx_assertCallerIsCommandQueue];
  GTXReport *reportCopy = [_report copy];
  dispatch_async(dispatch_get_main_queue(), ^{
    fetchBlock(reportCopy);
  });
}

@end
