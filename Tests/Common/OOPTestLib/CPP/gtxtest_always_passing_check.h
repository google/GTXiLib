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

#ifndef THIRD_PARTY_OBJECTIVE_C_GTXILIB_TESTS_COMMON_OOPTESTLIB_CPP_GTXTEST_ALWAYS_PASSING_CHECK_H_
#define THIRD_PARTY_OBJECTIVE_C_GTXILIB_TESTS_COMMON_OOPTESTLIB_CPP_GTXTEST_ALWAYS_PASSING_CHECK_H_

#include <abseil/absl/types/optional.h>
#include "check.h"
#include "error_message.h"
#include "gtx_types.h"
#include "localized_strings_manager.h"

namespace gtxtest {

// Test check that always reports success.
class GTXTestAlwaysPassingCheck : public gtx::Check {
 public:
  GTXTestAlwaysPassingCheck(const std::string &name);
  virtual ~GTXTestAlwaysPassingCheck() {}

  std::string name() const override;

  gtx::CheckCategory Category() const override;

  absl::optional<CheckResultProto> CheckElement(
      const UIElementProto &element,
      const gtx::Parameters &params) const override;

  std::string GetRichTitle(
      gtx::Locale locale, int result_id, const gtx::MetadataMap &metadata,
      const gtx::LocalizedStringsManager &string_manager) const override;

  std::string GetRichShortMessage(
      gtx::Locale locale, int result_id, const gtx::MetadataMap &metadata,
      const gtx::LocalizedStringsManager &string_manager) const override;

  std::string GetDefaultMessage(
      gtx::Locale locale, int result_id, const gtx::MetadataMap &metadata,
      const gtx::LocalizedStringsManager &string_manager) const override;

 private:
  std::string name_;
};

}  // namespace gtxtest

#endif  // THIRD_PARTY_OBJECTIVE_C_GTXILIB_TESTS_COMMON_OOPTESTLIB_CPP_GTXTEST_ALWAYS_PASSING_CHECK_H_
