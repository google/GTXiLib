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

#import <Foundation/Foundation.h>

#import "GTXCommon.h"

/**
 *  A class for setting up environment (devices, simulators) etc that GTX runs on.
 */
@interface GTXTestEnvironment : NSObject

/**
 *  Sets up the environment for use by GTX.
 *
 *  @param[out] errorOrNil A pointer to an NSError object to populate if there is an error, or nil
 *                         if errors are not being handled.
 *  @return YES if the environment was set up successfully, NO otherwise, If NO and @c errorOrNil
 *              is not nil, @c errorOrNil is populated with a description of the error.
 */
+ (BOOL)setupEnvironmentWithError:(GTXErrorRefType)errorOrNil;
/**
 *  Sets up the environment for use by GTX. If the environment cannot be setup, then an exception
 *  is raised.
 */
+ (void)setupEnvironment;

@end
