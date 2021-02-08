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

#import "GTXElementReference.h"

#import "GTXAssertions.h"
#import "NSError+GTXAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GTXElementReference

- (instancetype)initWithElementAddress:(NSUInteger)elementAddress
                          elementClass:(Class)elementClass
                    accessibilityLabel:(nullable NSString *)accessibilityLabel
               accessibilityIdentifier:(nullable NSString *)accessibilityIdentifier
                    accessibilityFrame:(CGRect)accessibilityFrame
                    elementDescription:(NSString *)description {
  self = [super init];
  if (self) {
    GTX_ASSERT(elementClass, @"elementClass must be nonnull.");
    GTX_ASSERT(description, @"description must be nonnull.");
    _elementAddress = elementAddress;
    _elementClass = elementClass;
    _accessibilityLabel = [accessibilityLabel copy];
    _accessibilityIdentifier = [accessibilityIdentifier copy];
    _accessibilityFrame = accessibilityFrame;
    _elementDescription = [description copy];
  }
  return self;
}

- (instancetype)initWithElement:(id)element {
  GTX_ASSERT(element, @"element must be nonnull.");
  NSString *accessibilityLabel = nil;
  NSString *accessibilityIdentifier = nil;
  CGRect accessibilityFrame = CGRectZero;
  NSString *elementDescription = [NSString stringWithFormat:@"%@ %p", [element class], element];
  if ([element respondsToSelector:@selector(accessibilityLabel)]) {
    accessibilityLabel = [element accessibilityLabel];
  }
  if ([element respondsToSelector:@selector(accessibilityIdentifier)]) {
    accessibilityIdentifier = [element accessibilityIdentifier];
  }
  if ([element respondsToSelector:@selector(accessibilityFrame)]) {
    accessibilityFrame = [element accessibilityFrame];
  }
  return [self initWithElementAddress:(NSUInteger)element
                         elementClass:[element class]
                   accessibilityLabel:accessibilityLabel
              accessibilityIdentifier:accessibilityIdentifier
                   accessibilityFrame:accessibilityFrame
                   elementDescription:elementDescription];
}

- (instancetype)initWithError:(NSError *)error {
  GTX_ASSERT(error, @"error must be nonnull.");
  id element = error.userInfo[kGTXErrorFailingElementKey];
  GTX_ASSERT(element, @"userInfo must have value for key kGTXErrorFailingElementKey");
  return [self initWithElement:element];
}

@end

NS_ASSUME_NONNULL_END
