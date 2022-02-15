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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#include "metadata_map.h"
#include "typedefs.h"
#include "check.h"
#include "gtx_types.h"
#include "localized_strings_manager.h"
#include "toolkit.h"
#include "gtxtest_always_failing_check.h"
#include "gtxtest_always_passing_check.h"

#pragma mark - Test Classes

@interface GTXToolkitTests : XCTestCase
@end

@implementation GTXToolkitTests {
  std::string _nonempty_label;
  gtx::Parameters _params;
  std::unique_ptr<gtx::Check> _passingCheck1, _passingCheck2;
  std::unique_ptr<gtx::Check> _failingCheck1, _failingCheck2;

  // Test Elements.
  UIElementProto _element1;
  UIElementProto _element2;
}

- (void)setUp {
  [super setUp];

  _nonempty_label = std::string("foo");
  _passingCheck1 =
      std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("alwaysPassing1"));
  _passingCheck2 =
      std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(std::string("alwaysPassing2"));
  _failingCheck1 =
      std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("alwaysFailing1"));
  _failingCheck2 =
      std::make_unique<gtxtest::GTXTestAlwaysFailingCheck>(std::string("alwaysFailing2"));

  _element1.set_is_ax_element(true);
  _element1.set_ax_label(_nonempty_label);
  _element2.set_is_ax_element(true);
  _element2.set_ax_label(_nonempty_label);
}

- (void)testToolkitReturnsSuccessForSinglePassingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  XCTAssertTrue(toolkit.CheckElement(_element1, _params).empty());
}

- (void)testToolkitReturnsFailureForSingleFailingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  XCTAssertFalse(toolkit.CheckElement(_element1, _params).empty());
}

- (void)testToolkitReturnsSuccessForNonApplicableElements {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  _element1.set_is_ax_element(false);
  XCTAssertTrue(toolkit.CheckElement(_element1, _params).empty());
}

- (void)testToolkitReturnsSuccessForMultiplePassingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  XCTAssertTrue(toolkit.CheckElement(_element1, _params).empty());
}

- (void)testToolkitReturnsFailureForMultipleFailingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_failingCheck2);
  XCTAssertFalse(toolkit.CheckElement(_element1, _params).empty());
}

- (void)testToolkitReturnsFailureWhenAnyCheckFails {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  XCTAssertFalse(toolkit.CheckElement(_element1, _params).empty());
}

- (void)testToolkitArrayAPIReturnsSuccessForSinglePassingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  AccessibilityHierarchyProto elements;
  *elements.add_elements() = _element1;
  *elements.add_elements() = _element2;
  XCTAssertTrue(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsFailureForSingleFailingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  AccessibilityHierarchyProto elements;
  *elements.add_elements() = _element1;
  *elements.add_elements() = _element2;
  XCTAssertFalse(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsSuccessForMultiplePassingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  AccessibilityHierarchyProto elements;
  *elements.add_elements() = _element1;
  *elements.add_elements() = _element2;
  XCTAssertTrue(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsFailureForMultipleFailingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_failingCheck2);
  AccessibilityHierarchyProto elements;
  *elements.add_elements() = _element1;
  *elements.add_elements() = _element2;
  XCTAssertFalse(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsFailureWhenAnyCheckFails {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  AccessibilityHierarchyProto elements;
  *elements.add_elements() = _element1;
  *elements.add_elements() = _element2;
  XCTAssertFalse(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitResultsObjectIncludesOnlyResultsOfFailingElements {
  std::string expected = _failingCheck1->name();
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  auto results = toolkit.CheckElement(_element1, _params);
  XCTAssertEqual((NSInteger)results.size(), (NSInteger)1);
  XCTAssertEqual(results.front().source_check_class(), expected);
}

- (void)testRegisterCheckWithEqualCheckNamesReturnsFalse {
  gtx::Toolkit toolkit;
  // Toolkit takes ownership of Checks, so the same instance can't be used. Construct a new instance
  // with an identical name.
  std::unique_ptr<gtx::Check> duplicatePassingCheck1 =
      std::make_unique<gtxtest::GTXTestAlwaysPassingCheck>(_passingCheck1->name());
  XCTAssertEqual(toolkit.RegisterCheck(_passingCheck1), true);
  XCTAssertEqual(toolkit.RegisterCheck(duplicatePassingCheck1), false);
}

@end
