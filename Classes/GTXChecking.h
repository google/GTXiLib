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

#import "GTXArtifactImplementing.h"
#import "GTXCommon.h"
#import "GTXReport.h"
#import "GTXSnapshotContainer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol for performing accessibility checks.
 */
@protocol GTXChecking <NSObject>

/**
 *  Performs the check on the given @c element.
 *
 *  @param      element    The target element on which GTX check is to be performed.
 *  @param[out] errorOrNil The error set on failure. The error returned can be @c nil, signifying
 *                         that the check succeeded.
 *
 *  @return @c YES if the check performed succeeded without any errors, else @c NO.
 */
- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil;

/**
 *  @return A name of this GTXCheck, this will be used in the logs and or reports and so must
 *          uniquely identify the check.
 */
- (NSString *)name;

@optional

/**
 *  @return An array of classes whose snapshots are required by this check for performing the check
 *          verification.
 */
- (NSArray<Class<GTXArtifactImplementing>> *)requiredArtifactClasses;

/**
 *  Performs the check on the given snapshot.
 *
 *  @param      snapshots The target snapshot on which this check needs to be performed.
 *  @param[out] report    The report to be populated with issues detected by the check.
 *
 *  @return @c YES if the check succeeded (no issues were detected and report is unchanged), else @c
 *          NO.
 */
- (BOOL)performCheckOnSnapshot:(GTXSnapshotContainer *)snapshots
          addingErrorsToReport:(GTXReport *)report;

@end

NS_ASSUME_NONNULL_END
