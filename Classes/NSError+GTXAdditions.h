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

#import "GTXCommon.h"

/**
 *  The error domain for all errors related to GTX.
 */
FOUNDATION_EXTERN NSString *const kGTXErrorDomain;

/**
 *  The key to the value in NSError's @c userInfo object containing the failing element.
 */
FOUNDATION_EXTERN NSString *const kGTXErrorFailingElementKey;

/**
 *  The key to the value in NSError's @c userInfo object containing an array of NSError objects
 *  each representing a separate underlying error that occurred.
 */
FOUNDATION_EXTERN NSString *const kGTXErrorUnderlyingErrorsKey;

/**
 *  The key to the value in NSError's @c userInfo object containing the name of the failing
 *  GTXCheck.
 */
FOUNDATION_EXTERN NSString *const kGTXErrorCheckNameKey;

/**
 *  The key to the value in NSError's @c userInfo object containing the description of the failing
 *  GTXCheck. The value at this key is also contained in the value at key NSLocalizedDescription.
 *  The raw error message exists at @c kGTXErrorDescriptionKey. The formatted error message exists
 *  at @c NSLocalizedDescription.
 */
FOUNDATION_EXTERN NSString *const kGTXErrorDescriptionKey;

/**
 *  Error codes for various errors that can occur when GTXChecks are performed.
 */
typedef NS_ENUM(NSInteger, GTXCheckErrorCode) {
  /**
   *  The GTXSystem has been configured to skip all checks.
   */
  GTXCheckErrorCodeSkippedAllChecks,
  /**
   *  The element provided for accessibility checking failed a particular check. Error details
   *  provided in the NSError's description field will indicate the specific check that was failed.
   */
  GTXCheckErrorCodeAccessibilityCheckFailed,
  /**
   *  The element provided for accessibility checking cannot be focused by VoiceOver.
   */
  GTXCheckErrorCodeNotFocusableElement,
  /**
   *  The test environment could not be set up before tests are run.
   */
  GTXCheckErrorCodeInvalidTestEnvironment,
  /**
   *  An error code for all errors not related to the above.
   */
  GTXCheckErrorCodeGenericError,
};

/**
 *  Additions to NSError to make it easy to create error objects for GTXSystem.
 */
@interface NSError (GTXAdditions)

/**
 *  Creates an NSError object describing the failure or logs the error if @c errorOrNil is @c nil.
 *
 *  @param[out] errorOrNil    The error object created.
 *  @param      description   The descripton of the error.
 *  @param      errorCode     The error code for the error.
 *  @param      userInfoOrNil An optional userInfo object to be added to the error.
 *
 *  @return @c YES if the error object was created, @c NO otherwise.
 */
+ (BOOL)gtx_logOrSetError:(GTXErrorRefType)errorOrNil
              description:(NSString *)description
                     code:(NSInteger)errorCode
                 userInfo:(NSDictionary *)userInfoOrNil;

/**
 *  Creates an NSError object describing an GTXCheck failure or logs the error if @c errorOrNil is
 *  nil.
 *
 *  @param[out] errorOrNil  The error object created.
 *  @param      element     The target element on which GTX check is to be performed.
 *  @param      name        The name of the GTXCheck
 *  @param      description A description of the error along with instructions on fixing it.
 *
 *  @return @c YES if the error object was created, @c NO otherwise.
 */
+ (BOOL)gtx_logOrSetGTXCheckFailedError:(GTXErrorRefType)errorOrNil
                                element:(id)element
                                   name:(NSString *)name
                            description:(NSString *)description;
@end
