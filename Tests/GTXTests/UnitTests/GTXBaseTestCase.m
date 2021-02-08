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
#import <XCTest/XCTest.h>

#import "GTXBaseTestCase.h"

NSString *const kGTXTestErrorDomain = @"kGTXTESTErrorDomain";

const NSInteger kGTXTestErrorCode = -1;

NSString *const kGTXTestAccessibilityLabelMissingCheckName = @"accessibility label missing";

NSString *const kGTXTestAccessibilityLabelMissingCheckDescription =
    @"element has no accessibility label";

GTXCheckHandlerBlock gNoOpCheckBlock = ^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
  return YES;
};

@implementation GTXBaseTestCase

- (NSObject *)newAccessibleElement {
  NSObject *element = [[NSObject alloc] init];
  element.isAccessibilityElement = YES;
  return element;
}

- (UIView *)newTestViewObject {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
  view.isAccessibilityElement = YES;
  return view;
}

- (NSObject *)newInaccessibleElement {
  NSObject *element = [[NSObject alloc] init];
  element.isAccessibilityElement = NO;
  return element;
}

- (void)createTreeFromPreOrderTraversal:(NSArray *)preOrderTraversal {
  //   A
  //  / \
  // B   C
  //    / \
  //   D   E
  // Example Traversal: A, B, C, NSNull, NSNull, D, E, NSNull, (D's children).
  NSMutableArray *queue = [[NSMutableArray alloc] init];
  NSMutableArray *children = [[NSMutableArray alloc] init];
  for (id element in preOrderTraversal) {
    if ([element isKindOfClass:[NSNull class]]) {
      // End of list has been reached.
      [[queue firstObject] setAccessibilityElements:children];
      [queue removeObjectAtIndex:0];
      children = [[NSMutableArray alloc] init];
    } else {
      if ([queue count]) {
        [children addObject:element];
      }
      [queue addObject:element];
    }
  }
}

- (UIView *)newAccessibleViewWithPropertiesSet {
  UIView *element = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
  element.isAccessibilityElement = YES;
  // Without a window, element.accessibilityFrame must be set manually.
  element.accessibilityFrame = element.frame;
  element.accessibilityLabel = @"Share";
  element.accessibilityIdentifier = @"kGTXTestShareAccessibilityIdentifier";
  return element;
}

- (void)assertElementReference:(GTXElementReference *)elementReference
               refersToElement:(UIView *)element {
  XCTAssertEqual(elementReference.elementAddress, (NSUInteger)element);
  XCTAssertEqual(elementReference.elementClass, [element class]);
  XCTAssertEqualObjects(elementReference.accessibilityLabel, element.accessibilityLabel);
  XCTAssertEqualObjects(elementReference.accessibilityIdentifier, element.accessibilityIdentifier);
  XCTAssertTrue(CGRectEqualToRect(elementReference.accessibilityFrame, element.accessibilityFrame));
}

@end
