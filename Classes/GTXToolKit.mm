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
#import "GTXChecksCollection.h"
#import "GTXExcludeListBlock.h"
#import "GTXExcludeListFactory.h"
#import "GTXLogger.h"
#import "NSError+GTXAdditions.h"
#import "NSObject+GTXLogging.h"
#import "GTXLocalizedStringsManagerUtils.h"
#import "NSObject+GTXAdditions.h"
#import "NSString+GTXAdditions.h"
#include "typedefs.h"
#include "check.h"
#include "error_message.h"
#include "localized_strings_manager.h"
#include "toolkit.h"

#pragma mark - Extension

@interface GTXToolKit ()

- (instancetype)initDefault NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Implementation

@implementation GTXToolKit {
  NSMutableArray<id<GTXChecking>> *_checks;
  NSMutableArray<id<GTXExcludeListing>> *_excludeLists;
  std::unique_ptr<gtx::LocalizedStringsManager> _stringManager;
  std::unique_ptr<gtx::Toolkit> _outOfProcessToolkit;
  gtx::Parameters _parameters;
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
  for (id<GTXChecking> check in [GTXChecksCollection allGTXChecksForVersion:GTXVersionLatest]) {
    [toolkit registerCheck:check];
  }
  return toolkit;
}

- (instancetype)initDefault {
  self = [super init];
  if (self) {
    _checks = [[NSMutableArray alloc] init];
    _excludeLists = [[NSMutableArray alloc] init];
    _stringManager = [GTXLocalizedStringsManagerUtils defaultLocalizedStringsManager];
    _outOfProcessToolkit = std::make_unique<gtx::Toolkit>();
  }
  return self;
}

+ (id<GTXChecking>)checkWithName:(NSString *)name block:(GTXCheckHandlerBlock)block {
  return [GTXCheckBlock GTXCheckWithName:name block:block];
}

+ (id<GTXChecking>)checkWithName:(NSString *)name
                  requiresWindow:(BOOL)requiresWindow
                           block:(GTXCheckHandlerBlock)block {
  return [GTXCheckBlock GTXCheckWithName:name requiresWindow:requiresWindow block:block];
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

- (void)registerOOPCheck:(std::unique_ptr<gtx::Check> &)check {
  NSString *name = [NSString gtx_stringFromSTDString:check->name()];
  _outOfProcessToolkit->RegisterCheck(check);
  __weak typeof(self) weakSelf = self;
  id<GTXChecking> wrappedCheck = [GTXToolKit
      checkWithName:name
              block:^BOOL(id _Nonnull element, GTXErrorRefType errorOrNil) {
                return [weakSelf gtx_invokeRegisteredOOPCheckNamed:
                                     std::string([name cStringUsingEncoding:NSASCIIStringEncoding])
                                                         onElement:element
                                                             error:errorOrNil];
              }];
  [self registerCheck:wrappedCheck];
}

- (void)registerExcludeList:(id<GTXExcludeListing>)excludeList {
  [_excludeLists addObject:excludeList];
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
    [GTXLogger
        logInfoWithFormat:@"-checkAllElementsFromRootElements:error: has been deprecated, please "
                          @"use -resultFromCheckingAllElementsFromRootElements: instead"];
  });
  GTXResult *result = [self resultFromCheckingAllElementsFromRootElements:rootElements];
  if (errorOrNil) {
    *errorOrNil = [result aggregatedError];
  }
  return [result allChecksPassed];
}

- (GTXResult *)resultFromCheckingAllElementsFromRootElements:(NSArray *)rootElements {
  for (id rootElement in rootElements) {
    [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelDeveloper
                                        prefix:@"Check from root "
                           descriptionOfObject:rootElement];
  }
  GTXAccessibilityTree *tree = [[GTXAccessibilityTree alloc] initWithRootElements:rootElements];
  NSMutableArray *errors;
  NSInteger elementsScanned = 0;
  // Check each element and collect all failures into the errors array.
  for (id element in tree) {
    NSError *error;
    BOOL wasElementChecked;
    [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelDeveloper
                                        prefix:@"Evaluating "
                           descriptionOfObject:element];
    if (![self gtx_checkElement:element
                analyticsEnabled:NO
            outWasElementChecked:&wasElementChecked
                           error:&error]) {
      [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelDeveloper
                                          prefix:@"Checked "
                             descriptionOfObject:element];
      if (!error) {
        [[GTXLogger defaultLogger] logWithLevel:GTXLogLevelWarning
                                         format:@"Failing check did not provide error description"];
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
    } else {
      [[GTXLogger defaultLogger] logWithMaxLevel:GTXLogLevelDeveloper
                                          prefix:@"Skipped "
                             descriptionOfObject:element];
    }
  }

  [GTXAnalytics invokeAnalyticsEvent:(errors ? GTXAnalyticsEventChecksFailed
                                             : GTXAnalyticsEventChecksPerformed)];

  return [[GTXResult alloc] initWithErrorsFound:errors elementsScanned:elementsScanned];
}

#pragma mark - Private

/**
Invokes the check registered on the given name.

@param name       Name of the check to be invoked.
@param element    element to be checked.
@param errorOrNil Error object to be filled with error info on check failures.
@return @c YES if all check passed @c NO otherwise.
*/
- (BOOL)gtx_invokeRegisteredOOPCheckNamed:(const std::string &)name
                                onElement:(id)element
                                    error:(GTXErrorRefType)errorOrNil {
  UIElementProto elementInfo = [element gtx_toProto];
  const gtx::Check &check = _outOfProcessToolkit->GetRegisteredCheckNamed(name);
  absl::optional<CheckResultProto> result = check.CheckElement(elementInfo, _parameters);
  BOOL success = !result.has_value();
  if (!success) {
    gtx::MetadataMap metadata = gtx::MetadataMap::FromProto(result->metadata());
    std::string errorMessage =
        check.GetPlainMessage(gtx::kLocaleEnglish, result->result_id(), metadata, *_stringManager);
    NSString *errorDescription = [NSString gtx_stringFromSTDString:errorMessage];
    [NSError gtx_logOrSetGTXCheckFailedError:errorOrNil
                                     element:element
                                        name:[NSString gtx_stringFromSTDString:name]
                                 description:errorDescription];
  }
  return success;
}

/**
 Applies the registered checks on the given element while respecting excluded elements.

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

  NSMutableArray *failedCheckErrors;
  for (id<GTXChecking> checker in _checks) {
    BOOL shouldSkipThisCheck = NO;
    for (id<GTXExcludeListing> excludeList in _excludeLists) {
      if ([excludeList shouldIgnoreElement:element forCheckNamed:[checker name]]) {
        shouldSkipThisCheck = YES;
        break;
      }
    }
    if (shouldSkipThisCheck) {
      continue;
    }

    NSError *error = nil;
    if ([checker respondsToSelector:@selector(requiresWindowBeforeChecking)] &&
        [checker requiresWindowBeforeChecking] && [element respondsToSelector:@selector(window)] &&
        [element window] == nil) {
      // Elements without a window are not actually part of the view hierarchy and should not be
      // checked if [checker requiresWindowBeforeChecking] is @c YES.
      continue;
    }
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
                                        static_cast<int>([errors count]), element];
  for (NSUInteger index = 0; index < [errors count]; index++) {
    [localizedDescription
        appendString:[NSString stringWithFormat:@"%d. %@\n", static_cast<int>(index + 1),
                                                [errors[index] localizedDescription]]];
  }
  return localizedDescription;
}

@end
