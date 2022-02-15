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

#import "NSError+GTXAdditions.h"

#import "GTXLogger.h"

#pragma mark - Externs

NSString *const kGTXErrorDomain = @"com.google.gtxchecker";
NSString *const kGTXErrorFailingElementKey = @"kGTXErrorFailingElementKey";
NSString *const kGTXErrorUnderlyingErrorsKey = @"kGTXErrorUnderlyingErrorsKey";
NSString *const kGTXErrorFailuresKey = @"kGTXErrorFailuresKey";
NSString *const kGTXErrorCheckNameKey = @"kGTXErrorCheckNameKey";
NSString *const kGTXErrorDescriptionKey = @"kGTXErrorDescriptionKey";

#pragma mark - Implementation

@implementation NSError (GTXAdditions)

+ (BOOL)gtx_logOrSetError:(GTXErrorRefType)errorOrNil
              description:(NSString *)description
                     code:(NSInteger)errorCode
                 userInfo:(NSDictionary *)userInfoOrNil {
  NSParameterAssert(description);
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfoOrNil];
  userInfo[NSLocalizedDescriptionKey] = description;
  userInfo[kGTXErrorDescriptionKey] = description;
  NSError *error = [NSError errorWithDomain:kGTXErrorDomain code:errorCode userInfo:userInfo];
  if (errorOrNil) {
    *errorOrNil = error;
  } else {
    [[GTXLogger defaultLogger] logWithLevel:GTXLogLevelError format:@"%@", error];
  }
  return YES;
}

+ (BOOL)gtx_logOrSetGTXCheckFailedError:(GTXErrorRefType)errorOrNil
                                element:(id)element
                                   name:(NSString *)name
                            description:(NSString *)description {
  NSParameterAssert(name);
  NSParameterAssert(element);
  NSParameterAssert(description);
  NSString *fullDescription =
      [NSString stringWithFormat:@"Check \"%@\" failed, %@", name, description];
  NSDictionary *userInfo = @{
    kGTXErrorDescriptionKey : description,
    NSLocalizedDescriptionKey : fullDescription,
    kGTXErrorFailingElementKey : element,
    kGTXErrorCheckNameKey : name
  };
  NSError *error = [NSError errorWithDomain:kGTXErrorDomain
                                       code:GTXCheckErrorCodeAccessibilityCheckFailed
                                   userInfo:userInfo];
  if (errorOrNil) {
    *errorOrNil = error;
  } else {
    [[GTXLogger defaultLogger] logWithLevel:GTXLogLevelError format:@"%@", error];
  }
  return YES;
}

@end
