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

/**
 Plugin for GTX to listen for XCTestCase's test tearDown events.
 */
@interface GTXPluginXCTestCase : NSObject

/**
 Installs XCTestCase plugin so that GTX can capture tearDown events.

 @note that this plugin references XCTestCase dynamically. This method must be invoked in the
 context of a test unless XCTest framework is also linked.
 */
+ (void)installPlugin;

@end
