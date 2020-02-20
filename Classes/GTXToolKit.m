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

#import "GTXToolKit.h"

#import "GTXAccessibilityTree.h"
#import "GTXAnalytics.h"
#import "GTXBlacklistBlock.h"
#import "GTXBlacklistFactory.h"
#import "GTXChecksCollection.h"
#import "GTXLogging.h"
#import "NSError+GTXAdditions.h"

#pragma mark - Extension

@interface GTXToolKit ()

- (instancetype)initDefault NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Implementation

@implementation GTXToolKit {
  NSMutableArray<id<GTXChecking>> *_checks;
  NSMutableArray<id<GTXBlacklisting>> *_blacklists;
}

+ (instancetype)defaultToolkit {
  GTXToolKit *toolkit = [[GTXToolKit alloc] initDefault];
  [toolkit registerCheck:GTXChecksCollection.checkForAXLabelPresent];
  return toolkit;
}

+ (instancetype)toolkitWithNoChecks {
  GTXToolKit *toolkit = [[GTXToolKit alloc] initDefault];
  return toolkit;
}

+ (instancetype)toolkitWithAllDefaultChecks {
  GTXToolKit *toolkit = [[GTXToolKit alloc] initDefault];
  for (id<GTXChecking> check in GTXChecksCollection.allGTXChecks) {
    [toolkit registerCheck:check];
  }
  return toolkit;
}

- (instancetype)initDefault {
  self = [super init];
  if (self) {
    _checks = [[NSMutableArray alloc] init];
    _blacklists = [[NSMutableArray alloc] init];
  }
  return self;
}

+ (id<GTXChecking>)checkWithName:(NSString *)name block:(GTXCheckHandlerBlock)block {
  return [GTXCheckBlock GTXCheckWithName:name block:block];
}

- (void)registerCheck:(id<GTXChecking>)check {
  // Verify the newly added check is unique.
  for (id<GTXChecking> existingCheck in _checks) {
    NSAssert(![[existingCheck name] isEqualToString:[check name]],
             @"Check named %@ already exists!", [check name]);
    (void)existingCheck;  // Ensures 'existingCheck' is marked as used even if NSAssert is removed.
  }
  [_checks addObject:check];
}

- (void)registerBlacklist:(id<GTXBlacklisting>)blacklist {
  [_blacklists addObject:blacklist];
}

- (BOOL)checkElement:(id)element error:(GTXErrorRefType)errorOrNil {
  return [self gtx_checkElement:element
               analyticsEnabled:YES
           outWasElementChecked:NULL
                          error:errorOrNil];
}

- (BOOL)checkAllElementsFromRootElements:(NSArray *)rootElements error:(GTXErrorRefType)errorOrNil {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    GTX_LOG(@"-checkAllElementsFromRootElements:error: has been deprecated, please use "
            @"-resultFromCheckingAllElementsFromRootElements: instead");
  });
  GTXResult *result = [self resultFromCheckingAllElementsFromRootElements:rootElements];
  if (errorOrNil) {
    *errorOrNil = [result aggregatedError];
  }
  return [result allChecksPassed];
}

- (GTXResult *)resultFromCheckingAllElementsFromRootElements:(NSArray *)rootElements {
  GTXAccessibilityTree *tree = [[GTXAccessibilityTree alloc] initWithRootElements:rootElements];
  NSMutableArray *errors;
  NSInteger elementsScanned = 0;
  // Check each element and collect all failures into the errors array.
  for (id element in tree) {
    NSError *error;
    BOOL wasElementChecked;
    if (![self gtx_checkElement:element
                analyticsEnabled:NO
            outWasElementChecked:&wasElementChecked
                           error:&error]) {
      if (!error) {
        NSString *genericErrorDescription =
            @"One or more Gtx checks failed, error description was not provided by the check.";
        error = [NSError errorWithDomain:kGTXErrorDomain
                                    code:GTXCheckErrorCodeGenericError
                                userInfo:@{
                                  kGTXErrorFailingElementKey : element,
                                  NSLocalizedDescriptionKey : genericErrorDescription
                                }];
      }
      if (!errors) {
        errors = [[NSMutableArray alloc] init];
      }
      [errors addObject:error];
    }
    if (wasElementChecked) {
      elementsScanned += 1;
    }
  }

  [GTXAnalytics invokeAnalyticsEvent:(errors ? GTXAnalyticsEventChecksFailed
                                             : GTXAnalyticsEventChecksPerformed)];

  return [[GTXResult alloc] initWithErrorsFound:errors elementsScanned:elementsScanned];
}

#pragma mark - Private

/**
 Applies the registered checks on the given element while respecting blacklisted elements.

 @param element element to be checked.
 @param checkAnalyticsEnabled Boolean that indicates if analytics events are to be invoked.
 @param[out] outWasElementChecked Optional reference to a boolean that will be set to @c YES if
 element was checked, @c NO otherwise.
 @param errorOrNil Error object to be filled with error info on check failures.
 @return @c YES if all checks passed @c NO otherwise.
 */
- (BOOL)gtx_checkElement:(id)element
        analyticsEnabled:(BOOL)checkAnalyticsEnabled
    outWasElementChecked:(nullable BOOL *)outWasElementChecked
                   error:(GTXErrorRefType)errorOrNil {
  NSParameterAssert(element);
  if (outWasElementChecked) {
    *outWasElementChecked = NO;
  }
  if ([element respondsToSelector:@selector(isAccessibilityElement)] &&
      ![element isAccessibilityElement]) {
    // Currently all checks are only applicable to accessibility elements.
    return YES;
  }
  if ([element respondsToSelector:@selector(window)] && [element window] == nil) {
    // Elements without a window are not actually part of the view hierarchy and should not be
    // checked.
    return YES;
  }

  NSMutableArray *failedCheckErrors;
  for (id<GTXChecking> checker in _checks) {
    BOOL shouldSkipThisCheck = NO;
    for (id<GTXBlacklisting> blacklist in _blacklists) {
      if ([blacklist shouldIgnoreElement:element forCheckNamed:[checker name]]) {
        shouldSkipThisCheck = YES;
        break;
      }
    }
    if (shouldSkipThisCheck) {
      continue;
    }

    NSError *error = nil;
    if (![checker check:element error:&error]) {
      if (!error) {
        // Check failed but an error description was not provided, generate a generic description.
        NSString *errorDescription =
            [NSString stringWithFormat:@"Check \"%@\" failed, no description was provided by the "
                                       @"check implementation.",
                                       [checker name]];
        error = [NSError errorWithDomain:kGTXErrorDomain
                                    code:GTXCheckErrorCodeAccessibilityCheckFailed
                                userInfo:@{
                                  NSLocalizedDescriptionKey : errorDescription,
                                  kGTXErrorFailingElementKey : element
                                }];
      }
      if (!failedCheckErrors) {
        failedCheckErrors = [[NSMutableArray alloc] init];
      }
      [failedCheckErrors addObject:error];
    }
    if (outWasElementChecked) {
      *outWasElementChecked = YES;
    }
  }
  if (checkAnalyticsEnabled) {
    [GTXAnalytics invokeAnalyticsEvent:(failedCheckErrors ? GTXAnalyticsEventChecksFailed
                                                          : GTXAnalyticsEventChecksPerformed)];
  }
  if (!failedCheckErrors) {
    // All checks passed.
    return YES;
  }

  // We have some failures, construct an error description from all the failures and error.
  NSString *errorDescription = [self gtx_errorDescriptionForElement:element
                                                     gtxCheckErrors:failedCheckErrors];
  NSError *error = nil;
  [NSError gtx_logOrSetError:&error
                 description:errorDescription
                        code:GTXCheckErrorCodeAccessibilityCheckFailed
                    userInfo:@{
                      kGTXErrorFailingElementKey : element,
                      kGTXErrorUnderlyingErrorsKey : failedCheckErrors
                    }];

  if (errorOrNil) {
    *errorOrNil = error;
  }
  return NO;
}

/**
 Creates an error description from an array of errors.

 @param element Failing element for which description is to be created.
 @param errors An array of errors that the element has.
 @return The created error description.
 */
- (NSString *)gtx_errorDescriptionForElement:(id)element gtxCheckErrors:(NSArray *)errors {
  NSMutableString *localizedDescription =
      [NSMutableString stringWithFormat:@"%d accessibility error(s) were found in %@:\n",
                                        (int)[errors count], element];
  for (NSUInteger index = 0; index < [errors count]; index++) {
    [localizedDescription
        appendString:[NSString stringWithFormat:@"%d. %@\n", (int)(index + 1),
                                                [errors[index] localizedDescription]]];
  }
  return localizedDescription;
}

@end
