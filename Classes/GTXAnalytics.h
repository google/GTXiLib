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

#import "GTXChecking.h"
#import "GTXCheckBlock.h"

NS_ASSUME_NONNULL_BEGIN


/**
 Enum of all possible analytics events handleed by GTXiLib.
 */
typedef NS_ENUM(NSUInteger, GTXAnalyticsEvent) {
  /**
   Enum for GTXiLib checks being invoked.
   */
  GTXAnalyticsEventChecksPerformed,

  /**
   Enum for GTXiLib checks failure detection.
   */
  GTXAnalyticsEventChecksFailed,
};


/**
 Typedef for Analytics handler.

 @param event The analytics event to be handled.
 */
typedef void(^GTXAnalyticsHandlerBlock)(GTXAnalyticsEvent event);


/**
 Class that handles all analytics in GTXiLib.
 */
@interface GTXAnalytics : NSObject

/**
 Boolean property that specifies if analytics is enabled or not.
 */
@property (class, nonatomic, assign) BOOL enabled;

/**
 Current analytics handler, users can override this for custom handling of analytics events.
 */
@property (class, nonatomic) GTXAnalyticsHandlerBlock handler;


/**
 Feeds an analytics event to be handled.

 @param event The event to be handled.
 */
+ (void)invokeAnalyticsEvent:(GTXAnalyticsEvent)event;

@end

NS_ASSUME_NONNULL_END
