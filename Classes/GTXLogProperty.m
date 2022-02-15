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

#import "GTXLogProperty.h"

@implementation GTXLogProperty

+ (instancetype)propertyWithName:(NSString *)name
          isDeveloperLogProperty:(BOOL)isDeveloperLogProperty
                 descriptorBlock:(GTXLogPropertyDescriptor)descriptor {
  GTXLogProperty *prop = [[GTXLogProperty alloc] init];
  prop.isDeveloperLogProperty = isDeveloperLogProperty;
  prop.name = name;
  prop.descriptor = descriptor;
  return prop;
}

- (NSString *)descriptionForObject:(NSObject *)object {
  NSString *objectDescription = _descriptor(object);
  if (objectDescription) {
    return [NSString stringWithFormat:@"%@=%@", _name, objectDescription];
  } else {
    return nil;
  }
}

@end
