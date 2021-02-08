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

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol for excluding certain types of UI elements in accessibility checks.
 */
@protocol GTXExcludeListing <NSObject>

/**
 *  Determines if the given @c check should not be run on the given @c element.
 *
 *  @param      element    The target element on which the GTX check is to be performed.
 *  @param[out] checkName  The name of the check being run.
 *
 *  @return @c YES if the check should NOT be performed on the given element, NO otherwise.
 */
- (BOOL)shouldIgnoreElement:(id)element forCheckNamed:(NSString *)checkName;

@end

NS_ASSUME_NONNULL_END
