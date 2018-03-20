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

#import "GTXAnalyticsUtils.h"
#import "GTXLogging.h"

#import <CommonCrypto/CommonDigest.h>

/**
 The endpoint that receives GTXiLib usage data.
 */
static NSString *const kGTXTrackingEndPoint = @"https://ssl.google-analytics.com/collect";

#pragma mark - Implementation

@implementation GTXAnalyticsUtils

/**
 @return The clientID to be used by GTXiLib analytics, this is a hash of App's bundle ID.
 */
+ (NSString *)clientID {
  static NSString *clientID;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *bundleIDMD5 = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleIDMD5) {
      // If bundle ID is not available we use a placeholder.
      bundleIDMD5 = @"<Missing Bundle ID>";
    }

    // Get MD5 value of the given string.
    unsigned char md5Value[CC_MD5_DIGEST_LENGTH];
    const char *stringCPtr = [bundleIDMD5 UTF8String];
    CC_MD5(stringCPtr, (CC_LONG)strlen(stringCPtr), md5Value);

    // Parse MD5 value into individual hex values.
    NSMutableString *stringWithHexMd5Values = [[NSMutableString alloc] init];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
      [stringWithHexMd5Values appendFormat:@"%02x", md5Value[i]];
    }
    clientID = [stringWithHexMd5Values copy];
  });

  return clientID;
}

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
                             value:(NSString *)value {
  // Initialize the payload with version(=1), tracking ID, client ID, category, action, and value.
  NSMutableString *payload = [[NSMutableString alloc] initWithFormat:@"v=1"
                                                                     @"&t=event"
                                                                     @"&tid=%@"
                                                                     @"&cid=%@"
                                                                     @"&ec=%@"
                                                                     @"&ea=%@"
                                                                     @"&ev=%@",
                                                                     trackingID,
                                                                     clientID,
                                                                     category,
                                                                     action,
                                                                     value];

  NSURLComponents *components = [[NSURLComponents alloc] initWithString:kGTXTrackingEndPoint];
  [components setQuery:payload];
  NSURL *url = [components URL];

  [[[NSURLSession sharedSession] dataTaskWithURL:url
                               completionHandler:^(NSData *data,
                                                   NSURLResponse *response,
                                                   NSError *error) {
    if (error) {
      // Failed to send analytics data, but since the test might be running in a sandboxed
      // environment it's not a good idea to freeze or throw assertions, let's just log and
      // move on.
      GTX_LOG(@"Failed to send analytics data due to: %@", error);
    }
  }] resume];
}

@end
