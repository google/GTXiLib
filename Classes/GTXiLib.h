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

//! Project version number for GTXiLib.
FOUNDATION_EXPORT double gGTXiLibVersionNumber;

//! Project version string for GTXiLib.
FOUNDATION_EXPORT const unsigned char GTXiLibVersionString[];

#import <GTXiLib/GTXAccessibilityTree.h>
#import <GTXiLib/GTXAnalytics.h>
#import <GTXiLib/GTXAnalyticsUtils.h>
#import <GTXiLib/GTXAssertions.h>
#import <GTXiLib/GTXCheckBlock.h>
#import <GTXiLib/GTXCheckResult.h>
#import <GTXiLib/GTXChecking.h>
#import <GTXiLib/GTXChecksCollection.h>
#import <GTXiLib/GTXCommon.h>
#import <GTXiLib/GTXElementReference.h>
#import <GTXiLib/GTXElementResultCollection.h>
#import <GTXiLib/GTXError.h>
#import <GTXiLib/GTXErrorReporter.h>
#import <GTXiLib/GTXExcludeListBlock.h>
#import <GTXiLib/GTXExcludeListFactory.h>
#import <GTXiLib/GTXExcludeListing.h>
#import <GTXiLib/GTXHierarchyResultCollection.h>
#import <GTXiLib/GTXImageAndColorUtils.h>
#import <GTXiLib/GTXImageRGBAData.h>
#import <GTXiLib/GTXLogProperty.h>
#import <GTXiLib/GTXLogger.h>
#import <GTXiLib/GTXOCRContrastCheck.h>
#import <GTXiLib/GTXPluginXCTestCase.h>
#import <GTXiLib/GTXReport.h>
#import <GTXiLib/GTXResult.h>
#import <GTXiLib/GTXSwizzler.h>
#import <GTXiLib/GTXTestCase.h>
#import <GTXiLib/GTXTestEnvironment.h>
#import <GTXiLib/GTXTestSuite.h>
#import <GTXiLib/GTXToolKit.h>
#import <GTXiLib/GTXTreeIteratorContext.h>
#import <GTXiLib/GTXTreeIteratorElement.h>
#import <GTXiLib/GTXXCUIApplicationProxy.h>
#import <GTXiLib/GTXXCUIElementProxy.h>
#import <GTXiLib/GTXXCUIElementQueryProxy.h>
#import <GTXiLib/GTXiLibCore.h>
#import <GTXiLib/NSError+GTXAdditions.h>
#import <GTXiLib/NSObject+GTXLogging.h>
#import <GTXiLib/UIColor+GTXAdditions.h>
