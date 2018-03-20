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

/**
 *  Interfaces to create various test accessibility elements.
 */
#import <UIKit/UIKit.h>

/**
 *  Interface for an UI element that provides child accessibility elements via
 *  @selector(accessibilityElements).
 */
@interface GTXTestAccessibilityElementA : NSObject
@property(nonatomic, assign) BOOL isAccessibilityElementOveride;
@property(nonatomic, strong) NSArray *accessibilityElementsOveride;
@end

/**
 *  Interface for an UI element that provides child accessibility elements via
 *  @selector(accessibilityElementAtIndex:).
 */
@interface GTXTestAccessibilityElementB : NSObject
@property(nonatomic, assign) BOOL isAccessibilityElementOveride;
@property(nonatomic, strong) NSArray *accessibilityElementsAtIndexOveride;
@end

/**
 *  Interface for an UI element that provides child accessibility elements via
 *  @selector(accessibilityElementAtIndex:) and @selector(accessibilityElements).
 */
@interface GTXTestAccessibilityElementFull : NSObject
@property(nonatomic, assign) BOOL isAccessibilityElementOveride;
@property(nonatomic, strong) NSArray *accessibilityElementsOveride;
@property(nonatomic, strong) NSArray *accessibilityElementsAtIndexOveride;
@end
