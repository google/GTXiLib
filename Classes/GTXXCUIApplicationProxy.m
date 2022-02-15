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

#import "GTXXCUIApplicationProxy.h"

#import "GTXAssertions.h"
#import "GTXSwizzler.h"
#import "GTXXCUIElementProxy.h"

/**
 Reference to XCUIApplication class which will be dynamically set when needed, this allows for tests
 as well as apps (which dont link to XCTest) use GTX.
 */
static Class gXCUIApplicationClass;

/**
 Weak reference to the last known XCUIApplication instance.
 */
static __weak GTXXCUIApplicationProxy *gLastKnownApplicationWeakRef;

/**
 Reference to the last known XCUIApplication instance.
 */
static GTXXCUIApplicationProxy *gLastKnownApplication;

/**
 Category to expose the methods on XCUIApplication that this class uses.
 */
@interface GTXXCUIApplicationProxy (XCUIApplication)

/**
 @return Query object that fetches all the child elements of this application.
 */
- (GTXXCUIElementQueryProxy *)childrenMatchingType:(NSInteger)unused;

@end

@implementation GTXXCUIApplicationProxy

+ (void)load {
  gXCUIApplicationClass = NSClassFromString(@"XCUIApplication");
  if (gXCUIApplicationClass) {
    [GTXSwizzler addInstanceMethod:@selector(initGTXXCUIApplication)
                         fromClass:self
                           toClass:gXCUIApplicationClass];
    [GTXSwizzler swizzleInstanceMethod:@selector(init)
                            withMethod:@selector(initGTXXCUIApplication)
                               inClass:gXCUIApplicationClass];
    [GTXSwizzler addInstanceMethod:@selector(gtx_onScreenAccessibilityElements)
                         fromClass:self
                           toClass:gXCUIApplicationClass];
  }
}

+ (GTXXCUIApplicationProxy *)lastKnownApplicationProxy {
  return gLastKnownApplication ?: gLastKnownApplicationWeakRef;
}

+ (void)didFinishTestTeardown {
  // Save gLastKnownApplication in a weak reference, this allows the application object to be freed
  // if needed or if the tests are also holding on to the reference we can still access it.
  gLastKnownApplicationWeakRef = gLastKnownApplication;
  gLastKnownApplication = nil;
}

- (id)initGTXXCUIApplication {
  NSAssert(gXCUIApplicationClass,
           @"XCUIApplication class was not found, either XCTest framework is "
           @"not being linked or not loaded yet.");
  self = [self initGTXXCUIApplication];
  gLastKnownApplication = self;
  NSAssert([gLastKnownApplication isKindOfClass:gXCUIApplicationClass], @"%@ was not of class %@",
           gLastKnownApplication, gXCUIApplicationClass);
  // TODO: Invoking this in +load is failing since Objective-C runtime is not loading
  // XCUIElement class by that time, fix that issue andd move this code into +load.
  [GTXXCUIElementProxy installPlugin];
  return self;
}

- (NSArray<UIAccessibilityElement *> *)gtx_onScreenAccessibilityElements {
  NSArray<GTXXCUIElementProxy *> *proxies = [[self childrenMatchingType:0] allElementsBoundByIndex];
  NSMutableArray<UIAccessibilityElement *> *elements = [[NSMutableArray alloc] init];
  for (GTXXCUIElementProxy *proxy in proxies) {
    [elements addObject:[proxy gtx_accessibilityElementWithContainer:self]];
  }
  return elements;
}

@end
