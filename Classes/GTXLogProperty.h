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

#import <Foundation/Foundation.h>

/**
 *  Block type that returns the description of a property in the given object or @c nil if the
 *  property cannot be obtained.
 */
typedef NSString * (^GTXLogPropertyDescriptor)(NSObject *object);

/**
 *  An interface for a loggable property, used for extracting and outputting object properties in
 *  debug logs.
 */
@interface GTXLogProperty : NSObject

/**
 *  A @c BOOL that indicates if this property is a "developer log" property. Developer log
 *  properties are only logged when log level is @c GTXLogLevelDeveloper or higher since developer
 *  logs can contain information from the app which may include user data such as user input.
 */
@property(nonatomic, assign) BOOL isDeveloperLogProperty;

/**
 *  Name of this property.
 */
@property(nonatomic, copy) NSString *name;

/**
 *  Descriptor block which returns the value of this log property.
 */
@property(nonatomic, copy) GTXLogPropertyDescriptor descriptor;

/**
 *  A convenience creator method for @c GTXLogProperty
 *
 *  @param name Name of the property.
 *  @param isDeveloperLogProperty @c YES if this is a property for developer logs, @c NO otherwise.
 *  @param descriptor @c GTXLogPropertyDescriptor block that returns the value of the property for
 *                    logging.
 *
 *  @return A new @c GTXLogProperty object with the given args.
 */
+ (instancetype)propertyWithName:(NSString *)name
          isDeveloperLogProperty:(BOOL)isDeveloperLogProperty
                 descriptorBlock:(GTXLogPropertyDescriptor)descriptor;

/**
 *  @return A description of this property for the given @c object or @c nil if the value of this
 *          property cannot be obtained.
 */
- (NSString *)descriptionForObject:(NSObject *)object;

@end
