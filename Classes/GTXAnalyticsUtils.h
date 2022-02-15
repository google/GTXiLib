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
 Class that provides analytics utils for GTXiLib analytics.
 */
@interface GTXAnalyticsUtils : NSObject

/**
 Util method to send an analytics event over to Google Analytics.

 @param trackingID Google Analytics account tracking ID
 @param clientID Client ID to use in the event.
 @param category Event category to use in the event.
 @param action Event action to use in the event.
 @param value Event value to use in the event.
 */
+ (void)sendEventHitWithTrackingID:(NSString *)trackingID
                           clientID:(NSString *)clientID
                           category:(NSString *)category
                             action:(NSString *)action
                              value:(NSString *)value;

/**
 @return An appropriate clientID for analytics that is based on hash of App's bundle ID.
 */
+ (NSString *)clientID;

/**
 @return An appropriate clientID for analytics that is based on hash of given @c bundleID.
 */
+ (NSString *)clientIDForBundleID:(NSString *)bundleID;

@end

NS_ASSUME_NONNULL_END
