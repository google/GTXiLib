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
#import "GTXAssertions.h"
#import "GTXLogger.h"

#import <CommonCrypto/CommonDigest.h>

/**
 The endpoint that receives GTXiLib usage data.
 */
static NSString *const kGTXTrackingEndPoint = @"https://ssl.google-analytics.com/collect";

#pragma mark - Implementation

@implementation GTXAnalyticsUtils

+ (NSString *)clientIDForBundleID:(NSString *)bundleID {
  // Get SHA256 value of the given string.
  unsigned char sha256Value[CC_SHA256_DIGEST_LENGTH];
  const char *stringCPtr = [bundleID UTF8String];
  CC_SHA256(stringCPtr, (CC_LONG)strlen(stringCPtr), sha256Value);

  // Parse SHA256 value into individual hex values. Note that Google Analytics client ID must be
  // 128bits long, but SHA256 is 256 bits and there is no standard way to compress hashes, in our
  // case we use bitwise XOR of the two 128 bit hashes inside the 256 bit hash to produce a 128bit
  // hash.
  NSMutableString *stringWithHexValues = [[NSMutableString alloc] init];
  const NSInteger kClientIDSize = 16;
  GTX_ASSERT(kClientIDSize * 2 == CC_SHA256_DIGEST_LENGTH,
             @"CC_SHA256_DIGEST_LENGTH must be 32 it was %d", (int)CC_SHA256_DIGEST_LENGTH);
  for (int i = 0; i < kClientIDSize; i++) {
    [stringWithHexValues appendFormat:@"%02x", sha256Value[i] ^ sha256Value[kClientIDSize + i]];
  }
  return stringWithHexValues;
}

+ (NSString *)clientID {
  static NSString *clientID;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleID) {
      // If bundle ID is not available we use a placeholder.
      bundleID = @"<Missing Bundle ID>";
    }

    clientID = [self clientIDForBundleID:bundleID];
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
      [[GTXLogger defaultLogger] logWithLevel:GTXLogLevelInfo
                                       format:@"Failed to send analytics data due to: %@", error];
    }
  }] resume];
}

@end
