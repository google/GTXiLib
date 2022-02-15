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

#import <UIKit/UIKit.h>

#import "GTXLogProperty.h"

/**
 *  Additions to NSObject to make it easy to log instance descriptions. This is a an informal
 *  protocol implemented by @c NSObject, other view classes can implement methods in this protocol
 *  to improve the data logged by GTXiLib.
 */
@interface NSObject (GTXLogging)

/**
 *  @return An array of @c GTXLogProperty objects representing a list of all loggable properties
 *          for this object. When implemented in a subclass append the properties of the superclass
 *          to the returned array unless it is required to replace existing properties.
 */
- (NSArray<GTXLogProperty *> *)gtx_logProperties;

@end
