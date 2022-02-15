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

#ifndef GTXILIB_OOPCLASSES_NO_LABEL_CHECK_H_
#define GTXILIB_OOPCLASSES_NO_LABEL_CHECK_H_

#include <string>

#include <abseil/absl/types/optional.h>
#include "metadata_map.h"
#include "typedefs.h"
#include "check.h"
#include "localized_strings_manager.h"
#include "parameters.h"

namespace gtx {

// Check for detecting missing accessibility labels.
class NoLabelCheck : public Check {
 public:
  static const int RESULT_ID_MISSING_ACCESSIBILITY_LABEL = 1;

  std::string name() const override;

  CheckCategory Category() const override;

  absl::optional<CheckResultProto> CheckElement(
      const UIElementProto &element, const Parameters &params) const override;

  std::string GetRichShortMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const override;

  std::string GetRichTitle(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const override;

 protected:
  std::string GetDefaultMessage(
      Locale locale, int result_id, const MetadataMap &metadata,
      const LocalizedStringsManager &string_manager) const override;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_NO_LABEL_CHECK_H_
