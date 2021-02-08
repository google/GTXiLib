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
 * Configures the properties of an accessibility element for testing of the supports dynamic type
 * check.
 */
@interface GTXTestDynamicTypeCheckOptions : NSObject

/**
 * The font used by the accessibility element. If @c nil, the element's default font is used (it is
 * not changed).
 */
@property(strong, nonatomic, nullable) UIFont *font;

/**
 * The value of the element's @c adjustsFontForContentSizeCategory property.
 */
@property(assign, nonatomic) BOOL adjustsFontForContentSizeCategory;

/**
 * @c YES if the element should pass the check with the above properties, @c NO if it should fail.
 */
@property(assign, nonatomic) BOOL succeeds;

/**
 * Initializes a @c GTXTestDynamicTypeCheckOptions instance with the given properties.
 */
- (instancetype)initWithFont:(nullable UIFont *)font
    adjustsFontForContentSizeCategory:(BOOL)adjustsFontForContentSizeCategory
                             succeeds:(BOOL)succeeds;
@end

NS_ASSUME_NONNULL_END
