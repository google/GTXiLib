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

#import "GTXCheckBlock.h"
#import "GTXElementReference.h"

/**
 * A dummy domain used to construct @c NSError objects in tests.
 */
FOUNDATION_EXTERN NSString *const kGTXTestErrorDomain;

/**
 * A dummy code used to construct @c NSError objects in tests.
 */
FOUNDATION_EXTERN const NSInteger kGTXTestErrorCode;

/**
 * The name of a check determining if an element has an accessibility label.
 */
FOUNDATION_EXTERN NSString *const kGTXTestAccessibilityLabelMissingCheckName;

/**
 * The description of a check determining if an element has an accessibility label.
 */
FOUNDATION_EXTERN NSString *const kGTXTestAccessibilityLabelMissingCheckDescription;

extern GTXCheckHandlerBlock gNoOpCheckBlock;

@interface GTXBaseTestCase : XCTestCase

- (NSObject *)newAccessibleElement;
- (NSObject *)newInaccessibleElement;
- (UIView *)newTestViewObject;
- (void)createTreeFromPreOrderTraversal:(NSArray *)preOrderTraversal;

/**
 * @return A @c UIView instance with @c isAccessibilityElement set to @c YES and all accessibility
 * properties used by @c GTXElementReference set.
 */
- (UIView *)newAccessibleViewWithPropertiesSet;

/**
 * Asserts that @c elementReference represents @c element, defined as containing the same
 * properties. Fails the test if the properties are not equal.
 *
 * @param elementReference Represents @c element without maintaining a pointer to it.
 * @param element The element represented by @c elementReference.
 */
- (void)assertElementReference:(GTXElementReference *)elementReference
               refersToElement:(UIView *)element;

@end
