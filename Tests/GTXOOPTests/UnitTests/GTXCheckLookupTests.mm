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

#include "check_lookup.h"

#import <XCTest/XCTest.h>
#include <memory>
#include <string>
#include <vector>

#include <abseil/absl/strings/str_cat.h>
#include "NSString+GTXAdditions.h"
#include "accessibility_hierarchy_searching.h"
#include "gtx.pb.h"
#include "typedefs.h"
#import "GTXObjCPPTestUtils.h"

@interface GTXCheckLookupTests : XCTestCase
@end

@implementation GTXCheckLookupTests

- (void)testChecksForVersionLatestReturnsNonemptyVector {
  XCTAssertGreaterThan(ChecksForVersion(gtx::Version::kLatest).size(), 0ul);
}

- (void)testChecksForVersionPrereleaseIncludesVersionLatest {
  auto latestChecks = ChecksForVersion(gtx::Version::kLatest);
  auto prereleaseChecks = ChecksForVersion(gtx::Version::kPrerelease);
  // Cannot use IsSupersetOf with std::unique_ptrs because the checks must be
  // matched by the result of name(), not object equality.
  for (const auto &latestCheck : latestChecks) {
    [GTXCheckLookupTests gtxtest_assertChecks:prereleaseChecks
                        containsCheckWithName:latestCheck->name()];
  }
}

- (void)testCheckForNameWithInvalidNameReturnsNullptr {
  XCTAssertEqual(gtx::CheckForName(""), nullptr);
}

- (void)testCheckForNameWithValidNameReturnsCheckWithName {
  const std::string checkName = "NoLabelCheck";
  std::unique_ptr<gtx::Check> check = gtx::CheckForName(checkName);

  // Cannot use XCTAssertNotEqual because the macro copies `check`, but check deletes its copy
  // constructor.
  XCTAssert(check != nullptr);
  [GTXObjCPPTestUtils assertString:check->name() equalsString:checkName];
}

/**
 * Asserts that there is a a check in @c checks that has name @c checkName. Fails the test if no
 * such check exists.
 *
 * @param checks An array of pointers to checks.
 * @param checkName The name that must exist in a check in @c checks.
 */
+ (void)gtxtest_assertChecks:(const std::vector<std::unique_ptr<gtx::Check>> &)checks
       containsCheckWithName:(const std::string &)checkName {
  for (const auto &check : checks) {
    if (check->name() == checkName) {
      return;
    }
  }
  XCTFail(@"could not find check with name %@", [NSString gtx_stringFromSTDString:checkName]);
}

@end
