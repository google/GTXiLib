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
#import "NSError+GTXAdditions.h"

#pragma mark - Implementation

@implementation GTXToolKit {
  NSMutableArray<id<GTXChecking>> *_checks;
  NSMutableArray<id<GTXBlacklisting>> *_blacklists;
}

- (instancetype)init {
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
    (void)existingCheck; // Ensures 'existingCheck' is marked as used even if NSAssert is removed.
  }
  [_checks addObject:check];
}

- (void)registerBlacklist:(id<GTXBlacklisting>)blacklist {
  [_blacklists addObject:blacklist];
}

- (BOOL)checkElement:(id)element error:(GTXErrorRefType)errorOrNil {
  return [self _checkElement:element analyticsEnabled:YES error:errorOrNil];
}

- (BOOL)checkAllElementsFromRootElements:(NSArray *)rootElements
                                   error:(GTXErrorRefType)errorOrNil {
  GTXAccessibilityTree *tree = [[GTXAccessibilityTree alloc] initWithRootElements:rootElements];
  NSMutableArray *errors;
  // Check each element and collect all failures into the errors array.
  for (id element in tree) {
    NSError *error;
    if (![self _checkElement:element analyticsEnabled:NO error:&error]) {
      if (!error) {
        NSString *genericErrorDescription =
        @"One or more Gtx checks failed, error description was not provided by the check.";
        error = [NSError errorWithDomain:kGTXErrorDomain
                                    code:GTXCheckErrorCodeGenericError
                                userInfo:@{ kGTXErrorFailingElementKey : element,
                                            NSLocalizedDescriptionKey : genericErrorDescription }];
      }
      if (!errors) {
        errors = [[NSMutableArray alloc] init];
      }
      [errors addObject:error];
    }
  }

  [GTXAnalytics invokeAnalyticsEvent:(errors ?
                                      GTXAnalyticsEventChecksFailed :
                                      GTXAnalyticsEventChecksPerformed)];
  if (errors) {
    // Combine the error descriptions from all the errors into the following format ('.' is an
    // indent):
    // . . Element: <element description>
    // . . . . Error: <error description>
    // . . . . Error: <error description>
    // . . Element: <element description>
    // . . . . Error: <error description>
    // . . . . Error: <error description>

    NSMutableString *errorString =
    [[NSMutableString alloc] initWithString:@"One or more elements FAILED the accessibility "
                                            @"checks:\n"];
    for (NSError *error in errors) {
      id element = [[error userInfo] objectForKey:kGTXErrorFailingElementKey];
      if (element) {
        // Add element description with an indent.
        [errorString appendFormat:@"  %@\n", element];
        for (NSError *underlyingError in
             // Add element's error description with twice the indent.
             [[error userInfo] objectForKey:kGTXErrorUnderlyingErrorsKey]) {
          [errorString appendFormat:@"    + %@\n", [underlyingError localizedDescription]];
        }
      }
    }
    NSError *error;
    [NSError gtx_logOrSetError:&error
                   description:errorString
                          code:GTXCheckErrorCodeGenericError
                      userInfo:@{ kGTXErrorUnderlyingErrorsKey : errors }];
    if (errorOrNil) {
      *errorOrNil = error;
    }
  }
  return errors == nil;
}

#pragma mark - private

/**
 Applies the registered checks on the given element while respecting blacklisted elements.

 @param element element to be checked.
 @param checkAnalyticsEnabled Boolean that indicates if analytics events are to be invoked.
 @param errorOrNil Error object to be filled with error info on check failures.
 @return @c YES if all checks passed @c NO otherwise.
 */
- (BOOL)_checkElement:(id)element
     analyticsEnabled:(BOOL)checkAnalyticsEnabled
                error:(GTXErrorRefType)errorOrNil {
  NSParameterAssert(element);
  if ([element respondsToSelector:@selector(isAccessibilityElement)] &&
      ![element isAccessibilityElement]) {
    // Currently all checks are only applicable to accessibility elements.
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
                                   @"check implementation.", [checker name]];
        error = [NSError errorWithDomain:kGTXErrorDomain
                                    code:GTXCheckErrorCodeAccessibilityCheckFailed
                                userInfo:@{ NSLocalizedDescriptionKey: errorDescription,
                                            kGTXErrorFailingElementKey: element }];
      }
      if (!failedCheckErrors) {
        failedCheckErrors = [[NSMutableArray alloc] init];
      }
      [failedCheckErrors addObject:error];
    }
  }
  if (checkAnalyticsEnabled) {
    [GTXAnalytics invokeAnalyticsEvent:(failedCheckErrors ?
                                        GTXAnalyticsEventChecksFailed :
                                        GTXAnalyticsEventChecksPerformed)];
  }
  if (!failedCheckErrors) {
    // All checks passed.
    return YES;
  }

  // We have some failures, construct an error description from all the failures and error.
  NSString *errorDescription = [self _errorDescriptionForElement:element
                                                  gtxCheckErrors:failedCheckErrors];
  NSError *error = nil;
  [NSError gtx_logOrSetError:&error
                 description:errorDescription
                        code:GTXCheckErrorCodeAccessibilityCheckFailed
                    userInfo:@{ kGTXErrorFailingElementKey : element,
                                kGTXErrorUnderlyingErrorsKey : failedCheckErrors}];

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
- (NSString *)_errorDescriptionForElement:(id)element gtxCheckErrors:(NSArray *)errors {
  NSMutableString *localizedDescription =
  [NSMutableString stringWithFormat:@"%d accessibility error(s) were found in %@:\n",
   (int)[errors count],
   element];
  for (NSUInteger index = 0; index < [errors count]; index++) {
    [localizedDescription appendString:
     [NSString stringWithFormat:@"%d. %@\n",
      (int)(index + 1),
      [errors[index] localizedDescription]]];
  }
  return localizedDescription;
}

@end

