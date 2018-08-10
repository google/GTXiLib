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

#import <UIKit/UIKit.h>

#import "GTXAccessibilityTree.h"

/**
 * There seems to be errors in accessibility children reported by some UIKit classes especially
 * UITextEffectsWindow which reports 9223372036854775807 possibly due to internal type conversions
 * with -1, we use this bounds value to detect that case..
 */
static const NSInteger kAccessibilityChildrenUpperBound = 50000;

@implementation GTXAccessibilityTree {
  // A queue of elements to be visited.
  NSMutableArray *_queue;
  // A queue of elements already visited.
  NSMutableSet *_visitedElements;
}

- (instancetype)initWithRootElements:(NSArray *)rootElements {
  self = [super init];
  if (self) {
    _queue = [[NSMutableArray alloc] initWithArray:rootElements];
    _visitedElements = [[NSMutableSet alloc] init];
  }
  return self;
}

#pragma mark - NSEnumerator

- (id)nextObject {
  if ([_queue count] == 0) {
    return nil;
  }

  id nextInQueue;
  // Get the next "unvisited" element.
  do {
    id candidateNext = [_queue firstObject];
    [_queue removeObjectAtIndex:0];
    if (![_visitedElements containsObject:candidateNext]) {
      if (![self gtx_isAccessibilityHiddenElement:candidateNext]) {
        nextInQueue = candidateNext;
      }
    }
  } while ([_queue count] > 0 && !nextInQueue);
  if (!nextInQueue) {
    return nil;
  }

  [_visitedElements addObject:nextInQueue];
  if ([nextInQueue respondsToSelector:@selector(isAccessibilityElement)]) {
    if (![nextInQueue isAccessibilityElement]) {
      // nextInQueue could be an accessibility container, if so enqueue its children.
      // There are two ways of getting the children of an accessibility container:
      // First, using @selector(accessibilityElements)
      NSArray *axElements = [self gtx_accessibilityElementsOfElement:nextInQueue];

      // Second, using @selector(accessibilityElementAtIndex:)
      NSArray *axElementsFromIndices =
          [self gtx_accessibilityElementsFromIndicesOfElement:nextInQueue];

      // Ensure that either the children are available only through one method or elements via both
      // are the same. Otherwise we must fail as the the accessibility tree is inconsistent.
      if (axElements && axElementsFromIndices) {
        NSSet *accessibilityElementsSet = [NSSet setWithArray:axElements];
        NSSet *accessibilityElementsFromIndicesSet = [NSSet setWithArray:axElementsFromIndices];
        NSAssert([accessibilityElementsSet isEqualToSet:accessibilityElementsFromIndicesSet],
                 @"Accessibility elements obtained from -accessibilityElements and"
                 @" -accessibilityElementAtIndex: are different - they must not be. Either provide"
                 @" elements via one method or provide the same elements.\nDetails:\nElements via"
                 @" accessibilityElements:%@\nElements via accessibilityElementAtIndex:\n"
                 @"accessibilityElementCount:%@\nElements:%@",
                 accessibilityElementsSet,
                 @([nextInQueue accessibilityElementCount]),
                 accessibilityElementsFromIndicesSet);

        // Ensure accessibilityElements* are marked as used even if NSAssert is removed.
        (void)accessibilityElementsSet;
        (void)accessibilityElementsFromIndicesSet;
      } else {
        // Set accessibilityElements to whichever is non nil or leave it as is.
        axElements = axElementsFromIndices ? axElementsFromIndices : axElements;
      }
      if (![nextInQueue respondsToSelector:@selector(accessibilityElementsHidden)] ||
          ![nextInQueue accessibilityElementsHidden]) {
        for (id element in axElements) {
          if (![_visitedElements containsObject:element]) {
            [_queue addObject:element];
          }
        }
      }

      // nextInQueue could be a UIView subclass, if so enqueue its subviews.
      NSArray *subViews;
      if ([nextInQueue isKindOfClass:[UITableViewCell class]] ||
          [nextInQueue isKindOfClass:[UICollectionViewCell class]]) {
        subViews = [nextInQueue contentView].subviews;
      } else if ([nextInQueue respondsToSelector:@selector(subviews)]) {
        subViews = [nextInQueue subviews];
      }
      if ([nextInQueue respondsToSelector:@selector(isHidden)] &&
          ![nextInQueue isHidden]) {
        for (id child in subViews) {
          if (![_visitedElements containsObject:child]) {
            [_queue addObject:child];
          }
        }
      }
    }
  }
  return nextInQueue;
}

#pragma mark - NSExtendedEnumerator

- (NSArray *)allObjects {
  NSMutableArray *remainingObjects = [[NSMutableArray alloc] init];
  id nextObject;
  while ((nextObject = [self nextObject])) {
    [remainingObjects addObject:nextObject];
  }
  return remainingObjects;
}

#pragma mark - Private


/**
 *  @return An array of accessible children of the given @c element as reported by the selector
 *          -[NSObject(UIAccessibility) accessibilityElements].
 */
- (NSArray *)gtx_accessibilityElementsOfElement:(id)element {
  if ([element respondsToSelector:@selector(accessibilityElements)]) {
    return [element accessibilityElements];
  }
  return nil;
}

/**
 *  @return An array of accessible children of the given @c element as reported by the selector
 *          -[NSObject(UIAccessibility) accessibilityElementAtIndex:].
 */
- (NSArray *)gtx_accessibilityElementsFromIndicesOfElement:(id)element {
  NSMutableArray *axElementsFromIndices;
  if ([element respondsToSelector:@selector(accessibilityElementAtIndex:)] &&
      [element respondsToSelector:@selector(accessibilityElementCount)]) {
    NSInteger childrenCount = [element accessibilityElementCount];
    // This is a workaround to deal with UIKit classes that are reporting incorrect
    // accessibilityElementCount, see kAccessibilityChildrenUpperBound.
    if (childrenCount > 0 && childrenCount < kAccessibilityChildrenUpperBound) {
      axElementsFromIndices = [[NSMutableArray alloc] initWithCapacity:(NSUInteger)childrenCount];
      for (NSInteger index = 0; index < childrenCount; index++) {
        [axElementsFromIndices addObject:[element accessibilityElementAtIndex:index]];
      }
    }
  }
  return axElementsFromIndices;
}

/**
 *  Elements are hidden from accessibility trees
 *
 *  @return @c YES if the element is hidden from accessibility tree @c NO otherwise.
 */
- (BOOL)gtx_isAccessibilityHiddenElement:(id)element {
  BOOL isHidden = NO;
  BOOL isAccessibilityHidden = NO;
  BOOL isHiddenDueToAccessibilityFrame = NO;
  BOOL isHiddenDueToFrame = NO;
  if ([element respondsToSelector:@selector(isHidden)]) {
    isHidden = [element isHidden];
  }
  if ([element respondsToSelector:@selector(accessibilityElementsHidden)]) {
    isAccessibilityHidden = [element accessibilityElementsHidden];
  }
  if ([element respondsToSelector:@selector(accessibilityFrame)]) {
    CGRect accessibilityFrame = [element accessibilityFrame];
    isHiddenDueToAccessibilityFrame = (accessibilityFrame.size.width == 0 ||
                                       accessibilityFrame.size.height == 0);
  }
  if ([element respondsToSelector:@selector(frame)]) {
    CGRect frame = [element frame];
    isHiddenDueToFrame = frame.size.width == 0 || frame.size.height == 0;
  }
  return (isHidden || isAccessibilityHidden ||
          (isHiddenDueToFrame && isHiddenDueToAccessibilityFrame));
}

@end
