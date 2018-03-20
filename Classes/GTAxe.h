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

/**
 *  Umbrella header for public GTX APIs.
 */
#import <UIKit/UIKit.h>

//! Project version number for GTAxe.
FOUNDATION_EXPORT double GTAxeVersionNumber;

//! Project version string for GTAxe.
FOUNDATION_EXPORT const unsigned char GTAxeVersionString[];

#import <GTAxe/GTXAccessibilityTree.h>
#import <GTAxe/GTXAnalytics.h>
#import <GTAxe/GTXAnalyticsUtils.h>
#import <GTAxe/GTXAssertions.h>
#import <GTAxe/GTXAxeCore.h>
#import <GTAxe/GTXCheckBlock.h>
#import <GTAxe/GTXChecksCollection.h>
#import <GTAxe/GTXCommon.h>
#import <GTAxe/GTXElementBlacklist.h>
#import <GTAxe/GTXErrorReporter.h>
#import <GTAxe/GTXImageRGBAData.h>
#import <GTAxe/GTXImageAndColorUtils.h>
#import <GTAxe/GTXLogging.h>
#import <GTAxe/GTXPluginXCTestCase.h>
#import <GTAxe/GTXToolKit.h>
#import <GTAxe/GTXTestSuite.h>
#import <GTAxe/NSError+GTXAdditions.h>
