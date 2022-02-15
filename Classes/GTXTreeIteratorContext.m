//
// Copyright 2018 Google Inc.
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

#import "GTXTreeIteratorContext.h"

@implementation GTXTreeIteratorContext {
  // A running queue of the elements that tree iteration algorithm needs to traverse.
  NSMutableArray<GTXTreeIteratorElement *> *_iteratorElementQueue;

  // The set of elements that the iteration algorithm already traversed.
  NSMutableSet<id> *_visitedElements;
}

- (instancetype)initWithElements:(NSArray<id> *)elements {
  self = [super init];
  if (self) {
    _iteratorElementQueue = [GTXTreeIteratorElement mutableIteratorElementArrayFromArray:elements];
    _visitedElements = [[NSMutableSet alloc] init];
  }
  return self;
}

- (BOOL)hasElementsInQueue {
  return _iteratorElementQueue.count > 0;
}

- (GTXTreeIteratorElement *)peekNextElement {
  return [_iteratorElementQueue firstObject];
}

- (void)dequeueNextElement {
  [_iteratorElementQueue removeObjectAtIndex:0];
}

- (void)queueElement:(GTXTreeIteratorElement *)element {
  [_iteratorElementQueue addObject:element];
}

- (BOOL)didVisitElement:(id)element {
  return [_visitedElements containsObject:element];
}

- (void)visitElement:(id)element {
  [_visitedElements addObject:element];
}

@end
