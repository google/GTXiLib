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

#ifndef GTXILIB_OOPCLASSES_TOOLKIT_H_
#define GTXILIB_OOPCLASSES_TOOLKIT_H_

#include <memory>
#include <string>
#include <vector>

#include "typedefs.h"
#include "check.h"
#include "parameters.h"

namespace gtx {

// Toolkit can be used for custom implementation of a checking mechanism, @class
// GTXiLib uses Toolkit for performing the checks on provided elements.
class Toolkit {
 public:
  Toolkit() {}

  // Creates a new toolkit object with all the default checks registered.
  static std::unique_ptr<Toolkit> ToolkitWithAllDefaultChecks();

  // Registers the given check to be executed on all elements this instance is
  // used on, unless a check with the new check's name already exists. Returns
  // true if the check is registered successfully, false otherwise.
  bool RegisterCheck(std::unique_ptr<Check> &check);

  // Returns a const reference to check that has been registered under the given
  // @c name, behavior is undefined if no such check exists.
  const gtx::Check &GetRegisteredCheckNamed(
      const std::string &check_name) const;

  // Applies all the registered checks on the given element and returns a vector
  // of CheckResultProtos for each accessibility issue found. If none were
  // found, returns an empty vector.
  std::vector<CheckResultProto> CheckElement(const UIElementProto &element,
                                             const Parameters &params);

  // Applies all the registered checks on the accessibility hierarchy with root
  // root_element. Returns a vector of CheckResultProtos, one for each
  // accessibility issue on each element found. A single element may be
  // associated with multiple CheckResultProtos if it fails multiple checks.
  // Elements failing no checks will have no corresponding CheckResultProtos. If
  // no accessibility issues are found, returns an empty vector.
  std::vector<CheckResultProto> CheckElements(
      const AccessibilityHierarchyProto &root_element,
      const Parameters &params);

 private:
  // Collection of all the registered checks.
  std::vector<std::unique_ptr<Check>> registered_checks_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_TOOLKIT_H_
