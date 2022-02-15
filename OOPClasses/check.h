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

#ifndef GTXILIB_OOPCLASSES_CHECK_H_
#define GTXILIB_OOPCLASSES_CHECK_H_

#include <functional>
#include <string>
#include <vector>

#include <abseil/absl/types/optional.h>
#include "metadata_map.h"
#include "typedefs.h"
#include "error_message.h"
#include "gtx_types.h"
#include "localized_strings_manager.h"
#include "parameters.h"

namespace gtx {

// The category of accessibility issue a Check is checking for.
enum class CheckCategory {
  // An unknown category that does not correspond to a check. Checks should not
  // use kUnknown. kUnknown should be returned by APIs that do not have a valid
  // check to access the category of.
  kUnknown,
  // Category for checks for elements whose whose accessibility labels are
  // missing,
  // confusing, or malformatted.
  kAccessibilityLabel,
  // Category for checks for touch targets that could cause difficulty for users
  // with motor
  // impairments.
  kTouchTargetSize,
  // Category for checks for elements that may be difficult to see due to low
  // contrast.
  kLowContrast
};

// Converts a string returned by Check::GetRichMessage to a new string.
using MessageProvider =
    std::function<std::string(std::string old_string, Locale locale,
                              int result_id, const MetadataMap &metadata,
                              const LocalizedStringsManager &string_manager)>;

// Check can be used for encapsulating checking logic. To execute a check, it
// must be registers with a @c gtx::Toolkit object and executed through it.
class Check {
 public:
  virtual ~Check() {}

  // Name of the check, must be unique in the toolkit that this check is being
  // registered into as it will be used in logs and unique names help debug
  // issues found by checks.
  virtual std::string name() const = 0;

  // The category of accessibility issue this Check is checking for.
  virtual CheckCategory Category() const = 0;

  // Performs the check, and returns a CheckResultProto describing an
  // accessibility issue of element. Returns std:nullopt if this check doesn't
  // apply to element or if element passes the check.
  virtual absl::optional<CheckResultProto> CheckElement(
      const UIElementProto &element, const Parameters &params) const = 0;

  // Returns a human readable description of a check result produced by this
  // check with the given result_id and metadata in the given locale. This
  // message may contain rich text formatting.
  std::string GetRichMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const;

  // Returns a human readable plaintext description of a check result produced
  // by this check with the given result_id and metadata in the given locale.
  std::string GetPlainMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const;

  // Returns a 1-2 sentence human readable description of a check result
  // produced by this check with the given result_id and metadata in the given
  // locale.
  virtual std::string GetRichShortMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const = 0;

  // Returns a plaintext 1-2 sentence human readable description of a check
  // result produced by this check with the given result_id and metadata in the
  // given locale.
  std::string GetPlainShortMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const;

  // Returns the title of a check result produced by this check with the given
  // result_id and metadata in the given locale.
  virtual std::string GetRichTitle(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const = 0;

  // Returns the plaintext title of a check result produced by this check with
  // the given result_id and metadata in the given locale.
  std::string GetPlainTitle(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const;

  // Registers a message provider to be called in `GetRichMessage`. This
  // provider is called after any previously registered message providers.
  void RegisterMessageProvider(MessageProvider provider);

 protected:
  // Returns a human readable description of a check result produced by this
  // check with the given result_id and metadata in the given locale.
  virtual std::string GetDefaultMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const = 0;

  // Constructs a CheckResultProto associated with this check.
  // The proto's check class is set to this instance, and its result id,
  // element id, and metadata are generated from result_id, element, and
  // metadata.
  CheckResultProto CheckResult(int result_id, const UIElementProto &element,
                               const MetadataMap &metadata) const;

 private:
  // The result of GetDefaultMessage is passed to the first element of
  // message_providers_, the result of which is passed to the second element,
  // etc, until the final message provider's result is returned.
  std::vector<MessageProvider> message_providers_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_CHECK_H_
