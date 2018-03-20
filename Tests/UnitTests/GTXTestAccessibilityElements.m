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

#import "GTXTestAccessibilityElements.h"

#import <UIKit/UIKit.h>

@implementation GTXTestAccessibilityElementA

- (instancetype)init {
  self = [super init];
  if (self) {
    _isAccessibilityElementOveride = YES;
  }
  return self;
}

- (BOOL)isAccessibilityElement {
  return self.isAccessibilityElementOveride;
}

- (NSArray *)accessibilityElements {
  return self.accessibilityElementsOveride;
}

@end

@implementation GTXTestAccessibilityElementB

- (instancetype)init {
  self = [super init];
  if (self) {
    _isAccessibilityElementOveride = YES;
  }
  return self;
}

- (BOOL)isAccessibilityElement {
  return self.isAccessibilityElementOveride;
}

- (NSInteger)accessibilityElementCount {
  return (NSInteger)[self.accessibilityElementsAtIndexOveride count];
}

- (NSArray *)accessibilityElementAtIndex:(NSInteger)index {
  return [self.accessibilityElementsAtIndexOveride objectAtIndex:(NSUInteger)index];
}

@end

@implementation GTXTestAccessibilityElementFull

- (instancetype)init {
  self = [super init];
  if (self) {
    _isAccessibilityElementOveride = YES;
  }
  return self;
}

- (BOOL)isAccessibilityElement {
  return self.isAccessibilityElementOveride;
}

- (NSArray *)accessibilityElements {
  return self.accessibilityElementsOveride;
}

- (NSInteger)accessibilityElementCount {
  return (NSInteger)[self.accessibilityElementsAtIndexOveride count];
}

- (NSArray *)accessibilityElementAtIndex:(NSInteger)index {
  return [self.accessibilityElementsAtIndexOveride objectAtIndex:(NSUInteger)index];
}

@end
