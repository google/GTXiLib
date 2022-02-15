//
// Copyright 2021 Google Inc.
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

#import "GTXObjCPPTestUtils.h"

#include <string>
#include <vector>

#import "NSString+GTXAdditions.h"

@implementation GTXObjCPPTestUtils

+ (BOOL)metadata:(const MetadataProto &)metadata contains:(const std::vector<std::string> &)keys {
  for (const auto &key : keys) {
    if (!metadata.metadata_map().contains(key)) {
      return NO;
    }
  }
  return YES;
}

+ (void)assertString:(const std::string &)str1 equalsString:(const std::string &)str2 {
  XCTAssertEqualObjects([NSString gtx_stringFromSTDString:str1],
                        [NSString gtx_stringFromSTDString:str2]);
}

@end
