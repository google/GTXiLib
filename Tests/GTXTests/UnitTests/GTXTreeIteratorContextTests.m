//
// Copyright 2020 Google Inc.
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

#import "GTXTreeIteratorContext.h"

@interface GTXTreeIteratorContextTests : XCTestCase
@end

@implementation GTXTreeIteratorContextTests

- (void)testHasElementsInQueueIsNOForEmptyQueue {
  XCTAssertFalse([[self gtxtest_testContextWithElements:NO] hasElementsInQueue]);
}

- (void)testHasElementsInQueueIsYESForNonEmptyQueue {
  XCTAssertTrue([[self gtxtest_testContextWithElements:YES] hasElementsInQueue]);
}

- (void)testPeekElementIsNilForEmptyQueue {
  XCTAssertNil([[self gtxtest_testContextWithElements:NO] peekNextElement]);
}

- (void)testNewElementsAreMarkedUnvisited {
  NSObject *testElement = [[NSObject alloc] init];
  XCTAssertFalse([[self gtxtest_testContextWithElements:YES] didVisitElement:testElement]);
  XCTAssertFalse([[self gtxtest_testContextWithElements:NO] didVisitElement:testElement]);
}

- (void)testElementsCanBeMarkedVisited {
  NSObject *testElement = [[NSObject alloc] init];
  GTXTreeIteratorContext *contextWithElements = [self gtxtest_testContextWithElements:YES];
  [contextWithElements visitElement:testElement];
  XCTAssertTrue([contextWithElements didVisitElement:testElement]);

  GTXTreeIteratorContext *contextWithoutElements = [self gtxtest_testContextWithElements:NO];
  [contextWithoutElements visitElement:testElement];
  XCTAssertTrue([contextWithoutElements didVisitElement:testElement]);
}

- (void)testGTXTreeIteratorContextCanDequeueAllElements {
  NSArray *testElements =
      @[ [[NSObject alloc] init], [[NSObject alloc] init], [[NSObject alloc] init] ];
  GTXTreeIteratorContext *context = [[GTXTreeIteratorContext alloc] initWithElements:testElements];
  for (NSUInteger i = 0; i < testElements.count; i++) {
    XCTAssertEqualObjects([context peekNextElement].current, testElements[i]);
    XCTAssertTrue([context hasElementsInQueue]);
    [context dequeueNextElement];
  }
  XCTAssertFalse([context hasElementsInQueue]);
}

- (void)testGTXTreeIteratorContextCanEnqueueElements {
  NSArray *testElements = @[
    [[NSObject alloc] init], [[NSObject alloc] init], [[NSObject alloc] init],
    [[NSObject alloc] init]
  ];
  GTXTreeIteratorContext *context = [[GTXTreeIteratorContext alloc] initWithElements:testElements];
  // Dequeue half the elements.
  for (NSUInteger i = 0; i < testElements.count / 2; i++) {
    [context dequeueNextElement];
  }

  // Enqueue an element.
  GTXTreeIteratorElement *expectedIteratorElement =
      [[GTXTreeIteratorElement alloc] initWithElement:[[NSObject alloc] init]
                                          inContainer:[[NSObject alloc] init]];
  [context queueElement:expectedIteratorElement];

  // Dequeue the other half of the elements and verify the expected element is next.
  for (NSUInteger i = testElements.count / 2; i < testElements.count; i++) {
    [context dequeueNextElement];
  }

  XCTAssertEqualObjects([context peekNextElement], expectedIteratorElement);
  [context dequeueNextElement];
  XCTAssertFalse([context hasElementsInQueue]);
}

- (GTXTreeIteratorContext *)gtxtest_testContextWithElements:(BOOL)hasElements {
  return [[GTXTreeIteratorContext alloc]
      initWithElements:hasElements ? @[ [[NSObject alloc] init] ] : @[]];
}

@end
