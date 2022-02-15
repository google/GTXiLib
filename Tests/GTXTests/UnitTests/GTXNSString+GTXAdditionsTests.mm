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

#import "NSString+GTXAdditions.h"

#import <XCTest/XCTest.h>

@interface GTXNSStringGTXAdditionsTests : XCTestCase {
  /**
   * An Objective-C string containing non-ASCII characters. Not declared
   * as a constant for consistency with @c _cppString. Equivalent to
   * @c _cppString.
   */
  NSString *_objectiveCString;

  /**
   * A C++ string containing non-ASCII characters. Not declared
   * as a constant because C++ strings cannot be declared as static
   * contstants as they have non-trivial destructors. Equivalent to
   * @c _objectiveCString.
   */
  std::string _cppString;
}

@end

@implementation GTXNSStringGTXAdditionsTests

- (void)setUp {
  [super setUp];
  _objectiveCString = @"This label contains non-ASCII characters such as “, ™, and 🙂";
  _cppString = "This label contains non-ASCII characters such as “, ™, and 🙂";
}

- (void)testgtx_stdStringWithNonAsciiCharacters {
  std::string expected = _cppString;
  std::string actual = [_objectiveCString gtx_stdString];
  XCTAssertEqual(actual, expected);
}

- (void)testgtx_stringFromSTDStringWithNonAsciiCharacters {
  NSString *expected = _objectiveCString;
  NSString *actual = [NSString gtx_stringFromSTDString:_cppString];
  XCTAssertEqualObjects(actual, expected);
}

- (void)testgtx_stdStringCanConvertToOriginalNSString {
  NSString *expected = _objectiveCString;
  NSString *actual = [NSString gtx_stringFromSTDString:[expected gtx_stdString]];
  XCTAssertEqualObjects(actual, expected);
}

@end
