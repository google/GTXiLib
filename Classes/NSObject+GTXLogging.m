//
// Copyright 2021 Google Inc.
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

#import "NSObject+GTXLogging.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "GTXLogProperty.h"

@implementation NSObject (GTXLogging)

- (NSArray<GTXLogProperty *> *)gtx_logProperties {
  return @[
    [GTXLogProperty propertyWithName:@"isAXElement"
              isDeveloperLogProperty:NO
                     descriptorBlock:^(NSObject *object) {
                       BOOL isAccessibilityElement =
                           [object respondsToSelector:@selector(isAccessibilityElement)]
                               ? [object isAccessibilityElement]
                               : NO;
                       return isAccessibilityElement ? @"YES" : @"NO";
                     }],
    [GTXLogProperty propertyWithName:@"AXID"
              isDeveloperLogProperty:NO
                     descriptorBlock:^(NSObject *object) {
                       return [object respondsToSelector:@selector(accessibilityIdentifier)]
                                  ? [object performSelector:@selector(accessibilityIdentifier)]
                                  : nil;
                     }],
    [GTXLogProperty propertyWithName:@"AXLabel"
              isDeveloperLogProperty:YES
                     descriptorBlock:^(NSObject *object) {
                       return [object respondsToSelector:@selector(accessibilityLabel)]
                                  ? [object accessibilityLabel]
                                  : nil;
                     }],
    [GTXLogProperty propertyWithName:@"AXFrame"
              isDeveloperLogProperty:NO
                     descriptorBlock:^(NSObject *object) {
                       if ([object respondsToSelector:@selector(accessibilityFrame)]) {
                         return NSStringFromCGRect([object accessibilityFrame]);
                       }
                       return (NSString *)nil;
                     }],
  ];
}

@end
