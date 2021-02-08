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

#include "check.h"
#include "check_result.h"
#include "gtx_types.h"
#include "localized_strings_manager.h"
#include "toolkit.h"
#include "ui_element.h"

#pragma mark - Test Checks Prototypes

namespace gtxtest {

// Test check that always reports success.
class GTXTestAlwaysPassingCheck : public gtx::Check {
 public:
  GTXTestAlwaysPassingCheck(const std::string &name) : gtx::Check(name) {}
  virtual ~GTXTestAlwaysPassingCheck() {}

  virtual bool CheckElement(const gtx::UIElement &element, const gtx::Parameters &params,
                            gtx::ErrorMessage *errorMessage) const {
    return true;
  }
};

// Test check that always reports failures.
class GTXTestAlwaysFailingCheck : public gtx::Check {
 public:
  GTXTestAlwaysFailingCheck(const std::string &name) : gtx::Check(name) {}
  virtual ~GTXTestAlwaysFailingCheck() {}

  virtual bool CheckElement(const gtx::UIElement &element, const gtx::Parameters &params,
                            gtx::ErrorMessage *errorMessage) const  {
    errorMessage->set_description_id(gtx::LocalizedStringID::kEmptyString);
    return false;
  }
};

}  // gtxtest

#pragma mark - Test Classes

@interface GTXToolkitTests : XCTestCase
@end

@implementation GTXToolkitTests {
  std::string _nonempty_label;
  gtx::Parameters _params;
  std::unique_ptr<gtx::Check> _passingCheck1, _passingCheck2;
  std::unique_ptr<gtx::Check> _failingCheck1, _failingCheck2;

  // Test Elements.
  std::unique_ptr<gtx::UIElement> _element1;
  std::unique_ptr<gtx::UIElement> _element2;
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

  _element1 = std::make_unique<gtx::UIElement>();
  _element1->set_is_ax_element(true);
  _element1->set_ax_label(_nonempty_label);
  _element2 = std::make_unique<gtx::UIElement>();
  _element2->set_is_ax_element(true);
  _element2->set_ax_label(_nonempty_label);
}

- (void)testToolkitReturnsSuccessForSinglePassingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  XCTAssertTrue(toolkit.CheckElement(*_element1, _params).empty());
}

- (void)testToolkitReturnsFailureForSingleFailingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  XCTAssertFalse(toolkit.CheckElement(*_element1, _params).empty());
}

- (void)testToolkitReturnsSuccessForNonApplicableElements {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  _element1->set_is_ax_element(false);
  XCTAssertTrue(toolkit.CheckElement(*_element1, _params).empty());
}

- (void)testToolkitReturnsSuccessForMultiplePassingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  XCTAssertTrue(toolkit.CheckElement(*_element1, _params).empty());
}

- (void)testToolkitReturnsFailureForMultipleFailingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_failingCheck2);
  XCTAssertFalse(toolkit.CheckElement(*_element1, _params).empty());
}

- (void)testToolkitReturnsFailureWhenAnyCheckFails {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  XCTAssertFalse(toolkit.CheckElement(*_element1, _params).empty());
}

- (void)testToolkitArrayAPIReturnsSuccessForSinglePassingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  std::vector<gtx::UIElement> elements;
  elements.push_back(*_element1);
  elements.push_back(*_element2);
  XCTAssertTrue(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsFailureForSingleFailingCheck {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  std::vector<gtx::UIElement> elements;
  elements.push_back(*_element1);
  elements.push_back(*_element2);
  XCTAssertFalse(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsSuccessForMultiplePassingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  std::vector<gtx::UIElement> elements;
  elements.push_back(*_element1);
  elements.push_back(*_element2);
  XCTAssertTrue(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsFailureForMultipleFailingChecks {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_failingCheck2);
  std::vector<gtx::UIElement> elements;
  elements.push_back(*_element1);
  elements.push_back(*_element2);
  XCTAssertFalse(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitArrayAPIReturnsFailureWhenAnyCheckFails {
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  std::vector<gtx::UIElement> elements;
  elements.push_back(*_element1);
  elements.push_back(*_element2);
  XCTAssertFalse(toolkit.CheckElements(elements, _params).empty());
}

- (void)testToolkitResultsObjectIncludesOnlyResultsOfFailingElements {
  std::string expected = _failingCheck1->name();
  gtx::Toolkit toolkit;
  toolkit.RegisterCheck(_passingCheck1);
  toolkit.RegisterCheck(_failingCheck1);
  toolkit.RegisterCheck(_passingCheck2);
  auto results = toolkit.CheckElement(*_element1, _params);
  XCTAssertEqual((NSInteger)results.size(), (NSInteger)1);
  XCTAssertEqual(results.front().check_name().compare(expected), 0);
}

@end
