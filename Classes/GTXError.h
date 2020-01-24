//
// Copyright 2019 Google Inc.
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

#import "GTXError.h"

/**
 *  Error objects processed by GTX.
 */
@interface GTXError : NSError

+ (instancetype)errorWithElement:(id)element
                       elementID:(NSString *)elementID
                       checkName:(NSString *)checkName
                      errorTitle:(NSString *)errorTitle
                errorDescription:(NSString *)errorDescription;

/**
 *  A reference to the element that this error is associated with.
 */
@property(nonatomic, readonly, weak) id element;

/**
 *  A check assigned ID that uniquely identifies the element which has errors.
 */
@property(nonatomic, readonly, copy) NSString *elementID;

/**
 *  Name of the check that detected the error.
 */
@property(nonatomic, readonly, copy) NSString *checkName;

/**
 * A title for the error that can be logged.
 */
@property(nonatomic, readonly, copy) NSString *errorTitle;

/**
 * A description of the error that can be logged.
 */
@property(nonatomic, readonly, copy) NSString *errorDescription;

/**
 * A hash of the error object as a string. Note that the hash is equal for errors with same
 * elementID and checkName and error objects with nil elementID are all considered unique and will
 * have a different hash. This behavior ensures that we do not loose actual issues as duplicates
 * when elementID is missing but can cause more duplicates to appear in reports.
 */
- (NSString *)hashString;

@end
