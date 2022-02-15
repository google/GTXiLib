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
#import <XCTest/XCTest.h>

#import "GTXTestViewController.h"

/**
 * Number of bytes per RGBA colored pixel.
 * */
FOUNDATION_EXTERN const NSInteger kBytesPerPixel;

/**
 Utils for all GTXiLib functional/integration tests.
 */
@interface GTXUITestUtils : NSObject

/**
 Performs the action named @c actionName by scrolling to the appropriate action.
 */
+ (void)performTestActionNamed:(NSString *)actionName inApp:(XCUIApplication *)application;

/**
 Clears the test area.
 */
+ (void)clearTestAreaInApp:(XCUIApplication *)application;

/**
 Runs all the GTX checks on the test element.
 */
+ (BOOL)runAllGTXChecksOnTestElementInApp:(XCUIApplication *)application;

/**
 Fills the given @c rgbaBuffer of color values at the given @c rect with the given @c color.
 */
+ (void)fillRect:(CGRect)rect
       withColor:(UIColor *)color
        inBuffer:(unsigned char *)rgbaBuffer
          ofSize:(CGSize)size;

@end
