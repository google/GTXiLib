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

#import "GTXCheckBlock.h"

#import "NSError+GTXAdditions.h"

@implementation GTXCheckBlock {
  NSString *_name;
  GTXCheckHandlerBlock _block;
}

+ (id<GTXChecking>)GTXCheckWithName:(NSString *)name
                              block:(GTXCheckHandlerBlock)block {
  return [[GTXCheckBlock alloc] initWithName:name block:block];
}

- (instancetype)initWithName:(NSString *)name
                       block:(GTXCheckHandlerBlock)block {
  NSParameterAssert(name);
  NSParameterAssert(block);

  self = [super init];
  if (self) {
    _name = [name copy];
    _block = [block copy];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ %p: %@", [self class], self, _name];
}

#pragma mark - GTXCheck

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  return _block(element, errorOrNil);
}

- (NSString *)name {
  return _name;
}

@end
