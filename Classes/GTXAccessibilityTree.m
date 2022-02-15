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

#import "GTXAssertions.h"
#import "GTXTreeIteratorContext.h"

/**
 * There seems to be errors in accessibility children reported by some UIKit classes especially
 * UITextEffectsWindow which reports 9223372036854775807 possibly due to internal type conversions
 * with -1, we use this bounds value to detect that case..
 */
static const NSInteger kAccessibilityChildrenUpperBound = 50000;

/**
 * The class name for @c UIPickerTableView elements. Must be accessed via @c NSClassFromString
 * because it is a private class.
 */
static NSString *const kUIPickerTableViewClassName = @"UIPickerTableView";

/**
 * The class name for accessibility children of @c UIPickerTableView elements. Must be accessed via
 * @c NSClassFromString because it is a private class.
 */
static NSString *const kUIPickerTableViewAccessibilityElementClassName =
    @"UITableViewCellAccessibilityElement";

@implementation GTXAccessibilityTree {
  // Context for this object's NSEnumerator.
  GTXTreeIteratorContext *_enumeratorContext;

  // Root elements that this object handles.
  NSArray *_rootElements;
}

- (instancetype)initWithRootElements:(NSArray *)rootElements {
  self = [super init];
  if (self) {
    for (id element in rootElements) {
      if ([element isKindOfClass:[UIViewController class]]) {
        GTX_ASSERT(NO,
                   @"Invalid root element %@ found. Check GTXToolkit docs to learn more about "
                   @"valid root elements. Did you mean to use the .view property instead?",
                   element);
      }
    }

    _enumeratorContext = [[GTXTreeIteratorContext alloc] initWithElements:rootElements];
    _rootElements = rootElements;
  }
  return self;
}

- (void)iterateAllElementsWithBlock:(GTXTreeIterationBlock)block {
  // Create a new tree object for iteration since the current object may be in the middle of a
  // for-in loop.
  GTXAccessibilityTree *tree = [[GTXAccessibilityTree alloc] initWithRootElements:_rootElements];
  GTXTreeIteratorElement *iteratorElement;
  while ((iteratorElement = [tree gtx_nextObject])) {
    block(iteratorElement);
  }
}

#pragma mark - NSEnumerator

- (id)nextObject {
  id nextObject = [self gtx_nextObject].current;
  if (!nextObject) {
    // Allow the tree object to be re-enumerated once through.
    _enumeratorContext = [[GTXTreeIteratorContext alloc] initWithElements:_rootElements];
  }
  return nextObject;
}

#pragma mark - NSExtendedEnumerator

- (NSArray *)allObjects {
  NSMutableArray *allObjects = [[NSMutableArray alloc] init];
  [self iterateAllElementsWithBlock:^(GTXTreeIteratorElement *_Nonnull iteratorElement) {
    [allObjects addObject:iteratorElement.current];
  }];
  return allObjects;
}

#pragma mark - Private

/**
 *  @return The next @c GTXTreeIteratorElement for the current @c GTXTreeIteratorContext.
 */
- (GTXTreeIteratorElement *)gtx_nextObject {
  if (![_enumeratorContext hasElementsInQueue]) {
    return nil;
  }

  id nextInQueue;
  GTXTreeIteratorElement *nextIterationElementInQueue;
  // Get the next "unvisited" element.
  do {
    GTXTreeIteratorElement *nextIterationElementCandidate = [_enumeratorContext peekNextElement];
    id nextCandidate = nextIterationElementCandidate.current;
    [_enumeratorContext dequeueNextElement];
    if (![_enumeratorContext didVisitElement:nextCandidate]) {
      if (![self gtx_isAccessibilityHiddenElement:nextCandidate]) {
        nextInQueue = nextCandidate;
        nextIterationElementInQueue = nextIterationElementCandidate;
      }
    }
  } while ([_enumeratorContext hasElementsInQueue] && !nextInQueue);
  if (!nextInQueue) {
    return nil;
  }
  [_enumeratorContext visitElement:nextInQueue];
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
                 accessibilityElementsSet, @([nextInQueue accessibilityElementCount]),
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
          if (![_enumeratorContext didVisitElement:element]) {
            [_enumeratorContext
                queueElement:[[GTXTreeIteratorElement alloc] initWithElement:element
                                                                 inContainer:nextInQueue]];
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
      if ([nextInQueue respondsToSelector:@selector(isHidden)] && ![nextInQueue isHidden]) {
        for (id child in subViews) {
          if (![_enumeratorContext didVisitElement:child]) {
            [_enumeratorContext
                queueElement:[[GTXTreeIteratorElement alloc] initWithElement:child
                                                                 inContainer:nextInQueue]];
          }
        }
      }
    }
  }
  return nextIterationElementInQueue;
}

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
    isHiddenDueToAccessibilityFrame =
        (accessibilityFrame.size.width == 0 || accessibilityFrame.size.height == 0);
  }
  if ([element respondsToSelector:@selector(frame)]) {
    CGRect frame = [element frame];
    isHiddenDueToFrame = frame.size.width == 0 || frame.size.height == 0;
  }
  return (isHidden || isAccessibilityHidden ||
          (isHiddenDueToFrame && isHiddenDueToAccessibilityFrame) ||
          [self gtx_isElementOffscreenPickerViewElement:element]);
}

/**
 * Determines if the element represents an accessibility element in a @c UIPickerTableView, and the
 * element is offscreen.
 *
 * @param element The accessibility element to check.
 * @return @c YES if the element is an offscreen accessibility element whose container is a
 *  @c UIPickerTableView, @c NO otherwise.
 */
- (BOOL)gtx_isElementOffscreenPickerViewElement:(id)element {
  if (![element respondsToSelector:@selector(accessibilityFrame)] ||
      ![element respondsToSelector:@selector(accessibilityContainer)]) {
    return NO;
  }
  id accessibilityContainer = [element accessibilityContainer];
  if ([accessibilityContainer isKindOfClass:NSClassFromString(kUIPickerTableViewClassName)] &&
      [element isKindOfClass:NSClassFromString(kUIPickerTableViewAccessibilityElementClassName)]) {
    CGRect containerAccessibilityFrame = [accessibilityContainer accessibilityFrame];
    CGRect childAccessibilityFrame = [element accessibilityFrame];
    if (!CGRectIntersectsRect(childAccessibilityFrame, containerAccessibilityFrame)) {
      return YES;
    }
  }
  return NO;
}

@end
