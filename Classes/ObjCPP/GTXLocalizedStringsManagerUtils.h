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

// Do not publicly declare C++ methods when compiling in a pure Objective-C environment.
#if __cplusplus

#import <Foundation/Foundation.h>
#include <memory>

#include "localized_strings_manager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Exposes @c gtx::LocalizedStringsManager construction as Obj-C APIs.
 */
@interface GTXLocalizedStringsManagerUtils : NSObject

/**
 * @return A @c LocalizedStringsManager with the default locales.
 */
+ (std::unique_ptr<gtx::LocalizedStringsManager>)defaultLocalizedStringsManager;

@end

NS_ASSUME_NONNULL_END

#endif
