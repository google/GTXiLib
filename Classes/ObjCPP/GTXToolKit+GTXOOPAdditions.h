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

// Do not publicly declare C++ methods when compiling in a pure Objective-C environment.
#if __cplusplus

#import <UIKit/UIKit.h>

#import "GTXToolKit.h"
#include "check.h"

NS_ASSUME_NONNULL_BEGIN

/**
 APIs for using GTX from out of the iOS App process.
 TODO: Merge this with GTXToolKit.h eventually.
 */
@interface GTXToolKit (GTXOOPAdditions)

/**
Registers the given "out-of-process" check to be executed on all elements this instance is used on.
Note that if a check with the same name is already registered assertion will be thrown.

@param check The OOP check to be registered.
*/
- (void)registerOOPCheck:(std::unique_ptr<gtx::Check> &)check;

@end

NS_ASSUME_NONNULL_END

#endif
