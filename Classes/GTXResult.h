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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 GTXResult encapsulates results (and any other associated info) of a single pass of accessibility
 checks.
 */
@interface GTXResult : NSObject

/**
 An array of all the errors encountered during the accessibility check(s).
*/
@property(nonatomic, strong, readonly) NSArray<NSError *> *errorsFound;

/**
 Total number of elements that passed through accessibilty check(s).
*/
@property(nonatomic, assign, readonly) NSInteger elementsScanned;

/**
 Use -initWithErrorsFound:elementsScanned:
*/
- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes a new GTXResult object.

 @param errorsFound Array of errors found.
 @param elementsScanned Total number of elements scanned.
 @return A newly created GTXResult object.
*/
- (instancetype)initWithErrorsFound:(NSArray<NSError *> *)errorsFound
                    elementsScanned:(NSInteger)elementsScanned;

/**
 @return @YES if none of the checks failed, @NO otherwise.
*/
- (BOOL)allChecksPassed;

/**
 @return The aggregated error of all the errors in this result, or @c nil if no errors were found.
*/
- (NSError *)aggregatedError;

@end

NS_ASSUME_NONNULL_END
