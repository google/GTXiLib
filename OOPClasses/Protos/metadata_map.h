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

#ifndef GTXILIB_OOPCLASSES_PROTOS_METADATA_MAP_H_
#define GTXILIB_OOPCLASSES_PROTOS_METADATA_MAP_H_

#include <stdint.h>

#include <string>
#include <unordered_map>
#include <vector>

#include <abseil/absl/types/optional.h>
#include "typedefs.h"

namespace gtx {

// A map providing strongly typed access to key value pairs. MetadataMap can be
// converted to and from MetadataProto for ease of use.
class MetadataMap {
 private:
  std::unordered_map<std::string, TypedValueProto> map_;

 public:
  typedef char byte;
  // Constructs a MetadataMap with all entries in proto.
  static MetadataMap FromProto(const MetadataProto &proto);

  // Constructs a MetadataProto with all entries in this instance.
  MetadataProto ToProto() const;

  // Returns true if there is a value for the given key, false otherwise.
  bool Contains(const std::string &key) const;

  // Returns true if there is a value for the given key of the given type.
  // Returns false if no such key exists, or if the key exists but it is of a
  // different type.
  bool Contains(const std::string &key, TypedValueProto::ValueCase type) const;

  // All get methods return an optional containing the value at the given key,
  // if it has the expected type. If no value exists for the given key, or the
  // value has a different type, a null optional is returned.

  absl::optional<bool> GetBool(const std::string &key) const;
  void SetBool(const std::string &key, bool value);

  absl::optional<byte> GetByte(const std::string &key) const;
  void SetByte(const std::string &key, byte value);

  absl::optional<int16_t> GetShort(const std::string &key) const;
  void SetShort(const std::string &key, int16_t value);

  absl::optional<char> GetChar(const std::string &key) const;
  void SetChar(const std::string &key, char value);

  absl::optional<int> GetInt(const std::string &key) const;
  void SetInt(const std::string &key, int value);

  absl::optional<int64_t> GetLong(const std::string &key) const;
  void SetLong(const std::string &key, int64_t value);

  absl::optional<float> GetFloat(const std::string &key) const;
  void SetFloat(const std::string &key, float value);

  absl::optional<double> GetDouble(const std::string &key) const;
  void SetDouble(const std::string &key, double value);

  absl::optional<std::string> GetString(const std::string &key) const;
  void SetString(const std::string &key, std::string value);

  absl::optional<std::vector<std::string>> GetStringList(
      const std::string &key) const;
  void SetStringList(const std::string &key, std::vector<std::string> value);

  absl::optional<std::vector<int>> GetIntList(const std::string &key) const;
  void SetIntList(const std::string &key, std::vector<int> value);
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_PROTOS_METADATA_MAP_H_
