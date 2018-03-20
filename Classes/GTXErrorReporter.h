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

/**
 *  Reports GTX errors and provides utils for reporting/logging errors found by GTX.
 */
@interface GTXErrorReporter : NSObject

/**
 *  Takes a screenshot of the current screen and outlines all the provided (failing) @c elements.
 *
 *  @param elements Array of elements with accessibility issues.
 *
 *  @return an image of the current screen with failing elements marked.
 */
+ (UIImage *)screenshotWithFailingElements:(NSArray *)elements;

/**
 *  Takes a screenshot of the given @c element.
 *
 *  @param element element whose screenshot is needed.
 *
 *  @return an image of the element.
 */
+ (UIImage *)screenshotView:(UIView *)element;

/**
 *  Takes a screenshot of the given @c element.
 *
 *  @param rootElements element whose screenshot is needed.
 *
 *  @return an image of the element.
 */
+ (NSString *)hierarchyDescriptionOfRootElements:(NSArray *)rootElements;

@end
