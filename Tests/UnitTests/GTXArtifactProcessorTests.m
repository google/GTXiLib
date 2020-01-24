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
#import "GTXArtifactProcessor.h"

static const NSTimeInterval kMaxCheckProcessingTime = 2.0;

#pragma mark - Test Artifacts

@interface GTXTestProcessorArtifactFoo : NSObject <GTXArtifactImplementing>
@end

@implementation GTXTestProcessorArtifactFoo

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

@interface GTXTestProcessorArtifactBar : NSObject <GTXArtifactImplementing>
@end

@implementation GTXTestProcessorArtifactBar

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

@interface GTXTestProcessorArtifactBaz : NSObject <GTXArtifactImplementing>
@end

@implementation GTXTestProcessorArtifactBaz

+ (nonnull instancetype)createArtifactSnapshot {
  return [[self alloc] init];
}

@end

#pragma mark - Test Checks

/**
 *  A Test check that requires GTXTestProcessorArtifactFoo artifact.
 */
@interface GTXTestProcessorCheckFoo : NSObject <GTXChecking>
@end

@implementation GTXTestProcessorCheckFoo

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  return YES;
}

- (NSString *)name {
  return NSStringFromClass(self.class);
}

- (NSArray<Class<GTXArtifactImplementing>> *)requiredArtifactClasses {
  return @[ GTXTestProcessorArtifactFoo.class ];
}

- (BOOL)performCheckOnSnapshot:(GTXSnapshotContainer *)snapshot
          addingErrorsToReport:(nonnull GTXReport *)report {
  // Add a dummy error.
  [report addByDeDupingErrors:@[[GTXError errorWithElement:nil
                                               elementID:@"id1"
                                               checkName:[self name]
                                              errorTitle:@"title"
                                        errorDescription:@"description"]]];
  return NO;
}

@end

/**
 *  A Test check that requires GTXTestProcessorArtifact{Foo,Bar} artifacts.
 */
@interface GTXTestProcessorCheckFooBar : NSObject <GTXChecking>
@end

@implementation GTXTestProcessorCheckFooBar

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  return YES;
}

- (NSString *)name {
  return NSStringFromClass(self.class);
}

- (NSArray<Class<GTXArtifactImplementing>> *)requiredArtifactClasses {
  return @[ GTXTestProcessorArtifactFoo.class, GTXTestProcessorArtifactBar.class ];
}

- (BOOL)performCheckOnSnapshot:(GTXSnapshotContainer *)snapshot
                         addingErrorsToReport:(nonnull GTXReport *)report {
  // Add a couple of dummy errors.
  [report addByDeDupingErrors:@[[GTXError errorWithElement:nil
                                               elementID:@"id1"
                                               checkName:[self name]
                                              errorTitle:@"title"
                                        errorDescription:@"description"]]];
  [report addByDeDupingErrors:@[[GTXError errorWithElement:nil
                                               elementID:@"id2"
                                               checkName:[self name]
                                              errorTitle:@"title"
                                        errorDescription:@"description"]]];
  return NO;
}

@end

#pragma mark - Tests

@interface GTXArtifactProcessorTests : XCTestCase <GTXArtifactProcessorDelegate>
@end

@implementation GTXArtifactProcessorTests {
  volatile NSInteger artifactProcessorDidProcessSnapshotContainerCount;
  volatile NSInteger artifactProcessorDidShutdownCount;
}

- (void)setUp {
  [super setUp];

  artifactProcessorDidProcessSnapshotContainerCount = 0;
  artifactProcessorDidShutdownCount = 0;
}

- (void)testArtifactProcessorCanProcessArtifacts {
  // Create some checks and an ArtifactProcessor with them.
  NSArray<id<GTXChecking>> *checks =
      @[ [[GTXTestProcessorCheckFoo alloc] init], [[GTXTestProcessorCheckFooBar alloc] init] ];
  GTXArtifactProcessor *processor = [[GTXArtifactProcessor alloc] initWithChecks:checks
                                                                        delegate:self];

  // Start processing and add a snapshot.
  [processor startProcessing];
  GTXArtifactCollector *collector = [[GTXArtifactCollector alloc] initWithChecks:checks];
  [processor addSnapshotContainerForProcessing:[collector snapshot]];

  // Retrieve the report after processing and verify it.
  [processor stopProcessing];
  __block GTXReport *finalReport;
  XCTestExpectation *reportFetchedExpectation =
      [[XCTestExpectation alloc] initWithDescription:@"Report fetched"];
  [processor fetchLatestReportAsync:^(GTXReport *_Nonnull report) {
    finalReport = report;
    [reportFetchedExpectation fulfill];
  }];

  // Wait for the report to be available.
  XCTAssertEqual([XCTWaiter waitForExpectations:@[ reportFetchedExpectation ]
                                        timeout:kMaxCheckProcessingTime],
                 XCTWaiterResultCompleted);
  XCTAssertNotNil(finalReport);

  // Assert report has issues in it.
  __block NSInteger issuesCount = 0;
  [finalReport forEachError:^(GTXError *error) {
    issuesCount += 1;
  }];
  // Expected total checks is 3, 1 from GTXTestProcessorCheckFoo and 2 from
  // GTXTestProcessorCheckFooBar.
  XCTAssertEqual(issuesCount, 3);
}

- (void)testArtifactProcessorInvokesDelegatesCorrectly {
  // Create some checks and an ArtifactProcessor with them.
  NSArray<id<GTXChecking>> *checks =
  @[ [[GTXTestProcessorCheckFoo alloc] init], [[GTXTestProcessorCheckFooBar alloc] init] ];
  GTXArtifactProcessor *processor = [[GTXArtifactProcessor alloc] initWithChecks:checks
                                                                        delegate:self];

  // Start processing and add a snapshot.
  [processor startProcessing];
  GTXArtifactCollector *collector = [[GTXArtifactCollector alloc] initWithChecks:checks];
  [processor addSnapshotContainerForProcessing:[collector snapshot]];

  // Wait for the processing to end.
  [processor stopProcessing];
  XCTestExpectation *reportFetchedExpectation =
  [[XCTestExpectation alloc] initWithDescription:@"Report fetched"];
  [self performSelectorInBackground:@selector(gtxtest_waitForProcessorToShutDown:)
                         withObject:reportFetchedExpectation];
  XCTAssertEqual([XCTWaiter waitForExpectations:@[ reportFetchedExpectation ]
                                        timeout:kMaxCheckProcessingTime],
                 XCTWaiterResultCompleted);

  // Verify the delegate invocation counts.
  XCTAssertTrue(artifactProcessorDidProcessSnapshotContainerCount == 1);
  XCTAssertTrue(artifactProcessorDidShutdownCount == 1);
}

#pragma mark - Private

- (void)gtxtest_waitForProcessorToShutDown:(XCTestExpectation *)expectation {
  XCTAssertFalse([NSThread isMainThread]);
  while (artifactProcessorDidShutdownCount == 0) {
    [NSThread sleepForTimeInterval:0.01];
  }
  [expectation fulfill];
}

#pragma mark - GTXArtifactProcessorDelegate methods

- (void)artifactProcessorDidProcessSnapshotContainer {
  artifactProcessorDidProcessSnapshotContainerCount += 1;
}

- (void)artifactProcessorDidShutdown {
  artifactProcessorDidShutdownCount += 1;
}

@end
