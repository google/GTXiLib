//
// Copyright 2020 Google Inc.
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

#import "NSString+GTXAdditions.h"

@implementation NSString (GTXAdditions)

+ (NSString *)gtx_stringFromSTDString:(const std::string &)string {
  return [NSString stringWithCString:string.c_str() encoding:NSUTF8StringEncoding];
}

- (std::string)gtx_stdString {
  return std::string([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
