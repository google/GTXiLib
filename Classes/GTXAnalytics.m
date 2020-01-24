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

#import "GTXAnalytics.h"
#import "GTXAnalyticsUtils.h"
#import "GTXAssertions.h"

/**
 Storage for GTXAnalytics.enabled property.
 */
static BOOL gEnabled = YES;

/**
 Storage for GTXAnalytics.handler property.
 */
static GTXAnalyticsHandlerBlock gHandler;

/**
 The Analytics tracking ID that receives GTXiLib usage data.
 */
static NSString *const kGTXAnalyticsTrackingID = @"UA-113761703-1";

#pragma mark - Implementation

@implementation GTXAnalytics

+ (void)load {
  gHandler = ^(GTXAnalyticsEvent event) {
    GTX_ASSERT(gEnabled, @"Invoking default handler when analytics is enabled!");
    [GTXAnalyticsUtils sendEventHitWithTrackingID:kGTXAnalyticsTrackingID
                                         clientID:[GTXAnalyticsUtils clientID]
                                         category:@"GTXiLibLib"
                                           action:[self gtx_NSStringFromAnalyticsEvent:event]
                                            value:@"1"];
  };
}

+ (void)setHandler:(GTXAnalyticsHandlerBlock)handler {
  NSParameterAssert(handler);
  gHandler = handler;
}

+ (GTXAnalyticsHandlerBlock)handler {
  return gHandler;
}

+ (void)setEnabled:(BOOL)enabled {
  gEnabled = enabled;
}

+ (BOOL)enabled {
  return gEnabled;
}

+ (void)invokeAnalyticsEvent:(GTXAnalyticsEvent)event {
  if (self.enabled) {
    self.handler(event);
  }
}

#pragma mark - Private

/**
 Appropriate NSString value for the given GTXAnalyticsEvent.

 @param event The event whose string value is needed.
 @return String value for the given GTXAnalyticsEvent.
 */
+ (NSString *)gtx_NSStringFromAnalyticsEvent:(GTXAnalyticsEvent)event {
  switch (event) {
    case GTXAnalyticsEventChecksPerformed: return @"checkRan";
    case GTXAnalyticsEventChecksFailed: return @"checkFailed";
  }
}

@end

