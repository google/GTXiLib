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

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GTXAccessibilityTree.h"
#import "GTXTestAccessibilityElements.h"

@interface GTXAccessibilityTreeTests : XCTestCase
@end

@implementation GTXAccessibilityTreeTests

- (void)testGTXAccessibilityTreeWorksWithEmptyLists {
  for (id element in [[GTXAccessibilityTree alloc] initWithRootElements:@[]]) {
    XCTAssertTrue(FALSE, @"Unknown element found %@", element);
  }
}

- (void)testGTXAccessibilityTreeWorksWithSingleElement {
  id element = [self newUIElementWithAccessibility:YES];
  [self assertGTXAccessibilityTreeWithRootElements:@[element]
                                            yields:@[element]];
}

- (void)testGTXAccessibilityTreeWorksWithMultipleElementsAtSameLevel {
  id element1 = [self newUIElementWithAccessibility:YES];
  id element2 = [self newUIElementWithAccessibility:YES];
  NSArray *elements = @[element1, element2];
  [self assertGTXAccessibilityTreeWithRootElements:elements
                                            yields:elements];
}

- (void)testGTXAccessibilityTreeWorksWithAOneLevelTree {
  id element1 = [self newUIElementWithAccessibility:NO];
  id element2 = [self newUIElementWithAccessibility:NO];
  id element3 = [self newUIElementWithAccessibility:NO];
  [(UIView *)element1 addSubview:element2];
  [(UIView *)element1 addSubview:element3];

  NSArray *elements = @[element1, element2, element3];
  [self assertGTXAccessibilityTreeWithRootElements:@[element1]
                                            yields:elements];
}

- (void)testGTXAccessibilityTreeSkipsChildrenOfAccessibilityElements {
  UIView *root = [self newTestElementWithChildren];
  UIView *subTreeView = root.subviews[0];
  [subTreeView setIsAccessibilityElement:YES];

  NSArray *actualElements = [self accessibilityElementsInTree:root];
  XCTAssertFalse([actualElements containsObject:subTreeView.subviews[0]]);
  XCTAssertFalse([actualElements containsObject:subTreeView.subviews[1]]);

  [root setIsAccessibilityElement:YES];
  // Enumeration should now contain just the root element.
  actualElements = [self accessibilityElementsInTree:root];
  XCTAssertTrue([actualElements containsObject:root]);
  XCTAssertEqual([actualElements count], (NSUInteger)1);
}

- (void)testGTXAccessibilityTreeSkipsHiddenElements {
  UIView *root = [self newTestElementWithChildren];
  [root setHidden:YES];

  // Enumeration should be empty.
  NSArray *actualElements = [self accessibilityElementsInTree:root];
  XCTAssertEqual([actualElements count], (NSUInteger)0);
}

- (void)testGTXAccessibilityTreeSkipsAccessibilityHiddenElements {
  UIView *root = [self newTestElementWithChildren];
  [root setAccessibilityElementsHidden:YES];

  // Enumeration should be empty.
  NSArray *actualElements = [self accessibilityElementsInTree:root];
  XCTAssertEqual([actualElements count], (NSUInteger)0);
}

- (void)testGTXAccessibilityTreeSkipsEmptyFrameElements {
  UIView *root = [self newTestElementWithChildren];

  // Enumeration should be empty for zero width.
  root.accessibilityFrame = CGRectMake(0, 0, 0, 1);
  root.frame = CGRectMake(0, 0, 0, 1);
  NSArray *actualElements = [self accessibilityElementsInTree:root];
  XCTAssertEqual([actualElements count], (NSUInteger)0);

  // Enumeration should be empty for zero height.
  root.accessibilityFrame = CGRectMake(0, 0, 1, 0);
  root.frame = CGRectMake(0, 0, 1, 0);
  actualElements = [self accessibilityElementsInTree:root];
  XCTAssertEqual([actualElements count], (NSUInteger)0);

  // Enumeration should be empty for zero rect.
  root.accessibilityFrame = CGRectZero;
  root.frame = CGRectZero;
  actualElements = [self accessibilityElementsInTree:root];
  XCTAssertEqual([actualElements count], (NSUInteger)0);
}

- (void)testGTXAccessibilityTreeNotNonEmptyFrameElements {
  UIView *root = [self newTestElementWithChildren];

  // Enumeration should not be empty if frame is non-empty.
  CGRect nonZeroRect = CGRectMake(0, 0, 1, 1);
  root.accessibilityFrame = CGRectZero;
  root.frame = nonZeroRect;
  NSArray *actualElements = [self accessibilityElementsInTree:root];
  XCTAssertNotEqual([actualElements count], (NSUInteger)0);

  // Enumeration should not be empty if accessibilityFrame is non-empty.
  root.accessibilityFrame = nonZeroRect;
  root.frame = CGRectZero;
  actualElements = [self accessibilityElementsInTree:root];
  XCTAssertNotEqual([actualElements count], (NSUInteger)0);
}

- (void)testGTXAccessibilityTreeSkipsChildrenOfAccessibilityHiddenElements {
  // Accessibility element which provide same elements via element.accessibilityElements and
  // element.accessibilityElementAtIndex: are considered consistent.
  GTXTestAccessibilityElementFull *root = [[GTXTestAccessibilityElementFull alloc] init];
  id element1 = [self newUIElementWithAccessibility:YES];
  id element2 = [self newUIElementWithAccessibility:YES];

  root.accessibilityElementsOveride = @[element1, element2];
  root.accessibilityElementsAtIndexOveride = @[element2, element1];
  root.isAccessibilityElementOveride = NO;
  [self assertGTXAccessibilityTreeWithRootElements:@[root]
                                            yields:@[root, element1, element2]];
}

- (void)testGTXAccessibilityTreeSkipsChildrenOfHiddenElements {
  UIView *root = [self newTestElementWithChildren];
  UIView *subTreeView = root.subviews[0];
  [subTreeView setHidden:YES];

  NSArray *actualElements = [self accessibilityElementsInTree:root];
  XCTAssertFalse([actualElements containsObject:subTreeView.subviews[0]]);
  XCTAssertFalse([actualElements containsObject:subTreeView.subviews[1]]);
}

- (void)testGTXAccessibilityTreeFailsForInConsistentTrees {
  GTXTestAccessibilityElementFull *root = [[GTXTestAccessibilityElementFull alloc] init];
  root.accessibilityElementsOveride = @[[self newUIElementWithAccessibility:YES]];
  root.accessibilityElementsAtIndexOveride = @[[self newUIElementWithAccessibility:YES]];
  root.isAccessibilityElementOveride = NO;

  XCTAssertThrows([[[GTXAccessibilityTree alloc] initWithRootElements:@[root]] nextObject]);
}

- (void)testGTXAccessibilityTreeWorksForConsistentTrees {
  // Accessibility element which provide same elements via element.accessibilityElements and
  // element.accessibilityElementAtIndex: are considered consistent.
  GTXTestAccessibilityElementFull *root = [[GTXTestAccessibilityElementFull alloc] init];
  id element1 = [self newUIElementWithAccessibility:YES];
  id element2 = [self newUIElementWithAccessibility:YES];

  root.accessibilityElementsOveride = @[element1, element2];
  root.accessibilityElementsAtIndexOveride = @[element2, element1];
  root.isAccessibilityElementOveride = NO;
  [self assertGTXAccessibilityTreeWithRootElements:@[root]
                                            yields:@[root, element1, element2]];
}

- (void)testGTXAccessibilityTreeWorksWithAccessibilityElements {
  GTXTestAccessibilityElementA *root = [[GTXTestAccessibilityElementA alloc] init];
  root.isAccessibilityElementOveride = NO;
  id element = [self newUIElementWithAccessibility:YES];
  root.accessibilityElementsOveride = @[element];
  NSArray *elements = @[root, element];
  [self assertGTXAccessibilityTreeWithRootElements:@[root]
                                            yields:elements];
}

- (void)testGTXAccessibilityTreeWorksWithAccessibilityElementsAtIndex {
  GTXTestAccessibilityElementB *root = [[GTXTestAccessibilityElementB alloc] init];
  root.isAccessibilityElementOveride = NO;
  id element1 = [self newUIElementWithAccessibility:YES];
  id element2 = [self newUIElementWithAccessibility:YES];
  root.accessibilityElementsAtIndexOveride = @[element1, element2];
  NSArray *elements = @[root, element1, element2];
  [self assertGTXAccessibilityTreeWithRootElements:@[root]
                                            yields:elements];
}

#pragma mark - Private

- (void)assertGTXAccessibilityTreeWithRootElements:(NSArray *)rootElements
                                            yields:(NSArray *)expectedElements {
  NSMutableArray *actualElemets = [[NSMutableArray alloc] init];
  for (id element in [[GTXAccessibilityTree alloc] initWithRootElements:rootElements]) {
    [actualElemets addObject:element];
  }
  XCTAssertEqualObjects(expectedElements, actualElemets);
}

- (id)newTestElementWithChildren {
  UIView *leftSubTreeRoot = [self newUIElementWithAccessibility:NO];
  [leftSubTreeRoot addSubview:[self newUIElementWithAccessibility:NO]];
  [leftSubTreeRoot addSubview:[self newUIElementWithAccessibility:NO]];

  UIView *rightSubTreeRoot = [self newUIElementWithAccessibility:NO];
  [rightSubTreeRoot addSubview:[self newUIElementWithAccessibility:NO]];
  [rightSubTreeRoot addSubview:[self newUIElementWithAccessibility:NO]];

  UIView *root = [self newUIElementWithAccessibility:NO];
  [root addSubview:leftSubTreeRoot];
  [root addSubview:rightSubTreeRoot];
  return root;
}

- (id)newUIElementWithAccessibility:(BOOL)isAccessibilityElement {
  UIView *element = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
  [element setIsAccessibilityElement:isAccessibilityElement];
  return element;
}

- (NSArray *)accessibilityElementsInTree:(id)root {
  NSMutableArray *accessibilityElementsArray = [[NSMutableArray alloc] init];
  for (id element in [[GTXAccessibilityTree alloc] initWithRootElements:@[root]]) {
    [accessibilityElementsArray addObject:element];
  }
  return accessibilityElementsArray;
}

@end
