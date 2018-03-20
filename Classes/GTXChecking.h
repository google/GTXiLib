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

#import <UIKit/UIKit.h>

#import "GTXCommon.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol for performing accessibility checks.
 */
@protocol GTXChecking<NSObject>

/**
 *  Performs the check on the given @c element.
 *
 *  @param      element    The target element on which GTX check is to be performed.
 *  @param[out] errorOrNil The error set on failure. The error returned can be @c nil, signifying
 *                         that the check succeeded.
 *
 *  @return @c YES if the check performed succeeded without any errors, else @c NO.
 */
- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil;

/**
 *  @return A name of this GTXCheck, this will be used in the logs and or reports and so must
 *          uniquely identify the check.
 */
- (NSString *)name;

@end

NS_ASSUME_NONNULL_END
