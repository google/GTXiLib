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

#include "metadata_map.h"

#include <stdint.h>

#include <string>
#include <unordered_map>
#include <vector>

#include <abseil/absl/types/optional.h>
#include "typedefs.h"

namespace gtx {

namespace {
const int kBitsPerByte = 8;
const uint8_t kLeastSignificantByteMask = 0b11111111;
}  // namespace

MetadataMap MetadataMap::FromProto(const MetadataProto &proto) {
  MetadataMap map;
  for (const auto &iter : proto.metadata_map()) {
    map.map_[iter.first] = iter.second;
  }
  return map;
}

MetadataProto MetadataMap::ToProto() const {
  MetadataProto proto;
  for (const auto &iter : map_) {
    (*proto.mutable_metadata_map())[iter.first] = iter.second;
  }
  return proto;
}

bool MetadataMap::Contains(const std::string &key) const {
  return map_.count(key) > 0;
}

bool MetadataMap::Contains(const std::string &key,
                           TypedValueProto::ValueCase type) const {
  return Contains(key) && map_.at(key).value_case() == type;
}

absl::optional<bool> MetadataMap::GetBool(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kBooleanValue)) {
    return absl::nullopt;
  }
  return map_.at(key).boolean_value();
}

void MetadataMap::SetBool(const std::string &key, bool value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_boolean_value(value);
}

absl::optional<MetadataMap::byte> MetadataMap::GetByte(
    const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kByteValue)) {
    return absl::nullopt;
  }
  return map_.at(key).byte_value()[0];
}

void MetadataMap::SetByte(const std::string &key, MetadataMap::byte value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  // Construct a string representing a byte array with an initializer list
  // containing one char.
  proto_value.set_byte_value({value});
}

absl::optional<int16_t> MetadataMap::GetShort(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kShortValue)) {
    return absl::nullopt;
  }
  // A short is 2 bytes, represented as the characters in a string.
  std::string bytes = map_.at(key).short_value();
  return (bytes[1] << kBitsPerByte) | bytes[0];
}

void MetadataMap::SetShort(const std::string &key, int16_t value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  char firstByte = value & kLeastSignificantByteMask;
  char secondByte = (value >> kBitsPerByte) & kLeastSignificantByteMask;
  proto_value.set_short_value({firstByte, secondByte});
}

absl::optional<char> MetadataMap::GetChar(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kCharValue)) {
    return absl::nullopt;
  }
  return map_.at(key).char_value()[0];
}

void MetadataMap::SetChar(const std::string &key, char value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_char_value({value});
}

absl::optional<int> MetadataMap::GetInt(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kIntValue)) {
    return absl::nullopt;
  }
  return map_.at(key).int_value();
}

void MetadataMap::SetInt(const std::string &key, int value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_int_value(value);
}

absl::optional<int64_t> MetadataMap::GetLong(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kLongValue)) {
    return absl::nullopt;
  }
  return map_.at(key).long_value();
}

void MetadataMap::SetLong(const std::string &key, int64_t value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_long_value(value);
}

absl::optional<float> MetadataMap::GetFloat(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kFloatValue)) {
    return absl::nullopt;
  }
  return map_.at(key).float_value();
}

void MetadataMap::SetFloat(const std::string &key, float value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_float_value(value);
}

absl::optional<double> MetadataMap::GetDouble(const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kDoubleValue)) {
    return absl::nullopt;
  }
  return map_.at(key).double_value();
}

void MetadataMap::SetDouble(const std::string &key, double value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_double_value(value);
}

absl::optional<std::string> MetadataMap::GetString(
    const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kStringValue)) {
    return absl::nullopt;
  }
  return map_.at(key).string_value();
}

void MetadataMap::SetString(const std::string &key, std::string value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  proto_value.set_string_value(value);
}

absl::optional<std::vector<std::string>> MetadataMap::GetStringList(
    const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kStringListValue)) {
    return absl::nullopt;
  }
  const auto &string_list = map_.at(key).string_list_value();
  return std::vector<std::string>(string_list.values().cbegin(),
                                  string_list.values().cend());
}

void MetadataMap::SetStringList(const std::string &key,
                                std::vector<std::string> value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  auto &string_list = *proto_value.mutable_string_list_value();
  for (const std::string &str : value) {
    string_list.add_values(str);
  }
}

absl::optional<std::vector<int>> MetadataMap::GetIntList(
    const std::string &key) const {
  if (!Contains(key, TypedValueProto::ValueCase::kIntListValue)) {
    return absl::nullopt;
  }
  const auto &int_list = map_.at(key).int_list_value();
  return std::vector<int>(int_list.values().cbegin(), int_list.values().cend());
}

void MetadataMap::SetIntList(const std::string &key, std::vector<int> value) {
  auto &proto_value = map_[key];
  proto_value.clear_value();
  auto &int_list = *proto_value.mutable_int_list_value();
  for (const int &x : value) {
    int_list.add_values(x);
  }
}

}  // namespace gtx
