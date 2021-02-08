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

#include <string>

#include "error_message.h"
#include "gtx_types.h"
#include "parameters.h"

namespace gtx {

// Check can be used for encapsulating checking logic. To execute a check, it
// must be registers with a @c gtx::Toolkit object and executed through it.
class Check {
 public:
  // Creates a new check object, note that name must be unique, see comments for
  // `name` property below for more details.
  Check(const std::string &name);
  virtual ~Check() {}

  // Name of the check, must be unique in the toolkit that this check is being
  // registered into as it will be used in logs and unique names help debug
  // issues found by checks.
  const std::string& name() const { return name_; }

  virtual bool CheckElement(const UIElement &element, const Parameters &params,
                            ErrorMessage *errorMessage) const = 0;

 private:
  std::string name_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_CHECK_H_
