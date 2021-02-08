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

#import "GTXXCUIElementProxy.h"

#import "GTXSwizzler.h"
#import "GTXXCUIElementQueryProxy.h"

/**
 Proxy for XCUIElementType enum, since XCUIElementType is only available in XCTest framework.
 */
// TODO: Figure out a better way to keep these values in sync with XCUIElementType enum.
typedef NS_ENUM(NSUInteger, XCUIProxyElementType) {
  XCUIProxyElementTypeButton = 9,
  XCUIProxyElementTypeStaticText = 48,
};

/**
 Category to expose the methods on XCUIElement that this class uses.
 */
@interface GTXXCUIElementProxy (XCUIElement)

- (CGRect)frame;
- (NSString *)label;
- (NSString *)identifier;
- (GTXXCUIElementQueryProxy *)childrenMatchingType:(NSInteger)unused;
- (XCUIProxyElementType)elementType;

@end

#pragma mark - Implementation

@implementation GTXXCUIElementProxy

+ (void)installPlugin {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class XCUIElementClass = NSClassFromString(@"XCUIElement");
    if (XCUIElementClass) {
      [GTXSwizzler addInstanceMethod:@selector(gtx_accessibilityElementWithContainer:)
                           fromClass:self
                             toClass:XCUIElementClass];
      [GTXSwizzler addInstanceMethod:@selector(gtx_accessibilityTraits)
                           fromClass:self
                             toClass:XCUIElementClass];
    }
  });
}

// TODO: Update this code to accurately capture the hierarchy, sometimes we seem to be
// getting duplicate entries.
- (UIAccessibilityElement *)gtx_accessibilityElementWithContainer:(id)container {
  UIAccessibilityElement *element =
      [[UIAccessibilityElement alloc] initWithAccessibilityContainer:container];
  element.accessibilityLabel = [self label];
  element.accessibilityFrame = [self frame];
  element.accessibilityIdentifier = [self identifier];
  element.accessibilityTraits = [self gtx_accessibilityTraits];
  NSMutableArray<UIAccessibilityElement *> *children;
  NSArray<GTXXCUIElementProxy *> *decendents =
      [[self childrenMatchingType:0] allElementsBoundByIndex];
  for (GTXXCUIElementProxy *element in decendents) {
    if (!children) {
      children = [[NSMutableArray alloc] init];
    }
    UIAccessibilityElement *child = [element gtx_accessibilityElementWithContainer:element];
    [children addObject:child];
  }
  element.accessibilityElements = children;
  element.isAccessibilityElement = children.count ? NO : YES;
  return element;
}

- (UIAccessibilityTraits)gtx_accessibilityTraits {
  UIAccessibilityTraits traits = 0;
  if (self.elementType == XCUIProxyElementTypeStaticText) {
    traits |= UIAccessibilityTraitStaticText;
  }
  if (self.elementType == XCUIProxyElementTypeButton) {
    traits |= UIAccessibilityTraitButton;
  }
  return traits;
}

@end
