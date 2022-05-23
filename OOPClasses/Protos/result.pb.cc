#include <map>
#include <string>
#include <stdlib.h>
#include <vector>

#include "enums.pb.h"
#include "gtx.pb.h"
#include "result.pb.h"
namespace gtxilib {
namespace oopclasses {
namespace protos {


std::string StringListProto::values(int index) const {
  return values_[index];
}
const std::vector<std::string>& StringListProto::values() const {
  return values_;
}
bool StringListProto::has_values() const {
  return has_values_;
}
void StringListProto::clear_values() {
  values_.clear();
  has_values_ = false;
}
void StringListProto::set_values(int index, std::string new_values) {
  values_[index] = new_values;
  has_values_ = true;
}
std::string* StringListProto::mutable_values(int index) {
  has_values_ = true;
  return &values_[index];
}
void StringListProto::add_values(std::string new_values) {
  values_.push_back(new_values);
  has_values_ = true;
}
int StringListProto::values_size() const {
  return values_.size();
}


int32_t IntListProto::values(int index) const {
  return values_[index];
}
const std::vector<int32_t>& IntListProto::values() const {
  return values_;
}
bool IntListProto::has_values() const {
  return has_values_;
}
void IntListProto::clear_values() {
  values_.clear();
  has_values_ = false;
}
void IntListProto::set_values(int index, int32_t new_values) {
  values_[index] = new_values;
  has_values_ = true;
}
int32_t* IntListProto::mutable_values(int index) {
  has_values_ = true;
  return &values_[index];
}
void IntListProto::add_values(int32_t new_values) {
  values_.push_back(new_values);
  has_values_ = true;
}
int IntListProto::values_size() const {
  return values_.size();
}


void TypedValueProto::clear_value() {
  value_case_ = VALUE_NOT_SET;
  clear_boolean_value();
  clear_byte_value();
  clear_short_value();
  clear_char_value();
  clear_int_value();
  clear_float_value();
  clear_long_value();
  clear_double_value();
  clear_string_value();
  clear_string_list_value();
  clear_int_list_value();
}
TypedValueProto::ValueCase TypedValueProto::value_case() const {
  return value_case_;
}

TypedValueProto_TypeProto TypedValueProto::type() const {
  return type_;
}
bool TypedValueProto::has_type() const {
  return has_type_;
}
void TypedValueProto::clear_type() {
  type_ = TypedValueProto_TypeProto();
  has_type_ = false;
}
void TypedValueProto::set_type(TypedValueProto_TypeProto new_type) {
  type_ = new_type;
  has_type_ = true;
}
TypedValueProto_TypeProto* TypedValueProto::mutable_type() {
  has_type_ = true;
  return &type_;
}

bool TypedValueProto::boolean_value() const {
  return boolean_value_;
}
bool TypedValueProto::has_boolean_value() const {
  return has_boolean_value_;
}
void TypedValueProto::clear_boolean_value() {
  boolean_value_ = bool();
  has_boolean_value_ = false;
  if (value_case_ == kBooleanValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_boolean_value(bool new_boolean_value) {
  clear_value();
  value_case_ = kBooleanValue;
  boolean_value_ = new_boolean_value;
  has_boolean_value_ = true;
}
bool* TypedValueProto::mutable_boolean_value() {
  clear_value();
  value_case_ = kBooleanValue;
  has_boolean_value_ = true;
  return &boolean_value_;
}

std::string TypedValueProto::byte_value() const {
  return byte_value_;
}
bool TypedValueProto::has_byte_value() const {
  return has_byte_value_;
}
void TypedValueProto::clear_byte_value() {
  byte_value_ = std::string();
  has_byte_value_ = false;
  if (value_case_ == kByteValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_byte_value(std::string new_byte_value) {
  clear_value();
  value_case_ = kByteValue;
  byte_value_ = new_byte_value;
  has_byte_value_ = true;
}
std::string* TypedValueProto::mutable_byte_value() {
  clear_value();
  value_case_ = kByteValue;
  has_byte_value_ = true;
  return &byte_value_;
}

std::string TypedValueProto::short_value() const {
  return short_value_;
}
bool TypedValueProto::has_short_value() const {
  return has_short_value_;
}
void TypedValueProto::clear_short_value() {
  short_value_ = std::string();
  has_short_value_ = false;
  if (value_case_ == kShortValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_short_value(std::string new_short_value) {
  clear_value();
  value_case_ = kShortValue;
  short_value_ = new_short_value;
  has_short_value_ = true;
}
std::string* TypedValueProto::mutable_short_value() {
  clear_value();
  value_case_ = kShortValue;
  has_short_value_ = true;
  return &short_value_;
}

std::string TypedValueProto::char_value() const {
  return char_value_;
}
bool TypedValueProto::has_char_value() const {
  return has_char_value_;
}
void TypedValueProto::clear_char_value() {
  char_value_ = std::string();
  has_char_value_ = false;
  if (value_case_ == kCharValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_char_value(std::string new_char_value) {
  clear_value();
  value_case_ = kCharValue;
  char_value_ = new_char_value;
  has_char_value_ = true;
}
std::string* TypedValueProto::mutable_char_value() {
  clear_value();
  value_case_ = kCharValue;
  has_char_value_ = true;
  return &char_value_;
}

int32_t TypedValueProto::int_value() const {
  return int_value_;
}
bool TypedValueProto::has_int_value() const {
  return has_int_value_;
}
void TypedValueProto::clear_int_value() {
  int_value_ = int32_t();
  has_int_value_ = false;
  if (value_case_ == kIntValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_int_value(int32_t new_int_value) {
  clear_value();
  value_case_ = kIntValue;
  int_value_ = new_int_value;
  has_int_value_ = true;
}
int32_t* TypedValueProto::mutable_int_value() {
  clear_value();
  value_case_ = kIntValue;
  has_int_value_ = true;
  return &int_value_;
}

float TypedValueProto::float_value() const {
  return float_value_;
}
bool TypedValueProto::has_float_value() const {
  return has_float_value_;
}
void TypedValueProto::clear_float_value() {
  float_value_ = float();
  has_float_value_ = false;
  if (value_case_ == kFloatValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_float_value(float new_float_value) {
  clear_value();
  value_case_ = kFloatValue;
  float_value_ = new_float_value;
  has_float_value_ = true;
}
float* TypedValueProto::mutable_float_value() {
  clear_value();
  value_case_ = kFloatValue;
  has_float_value_ = true;
  return &float_value_;
}

int64_t TypedValueProto::long_value() const {
  return long_value_;
}
bool TypedValueProto::has_long_value() const {
  return has_long_value_;
}
void TypedValueProto::clear_long_value() {
  long_value_ = int64_t();
  has_long_value_ = false;
  if (value_case_ == kLongValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_long_value(int64_t new_long_value) {
  clear_value();
  value_case_ = kLongValue;
  long_value_ = new_long_value;
  has_long_value_ = true;
}
int64_t* TypedValueProto::mutable_long_value() {
  clear_value();
  value_case_ = kLongValue;
  has_long_value_ = true;
  return &long_value_;
}

double TypedValueProto::double_value() const {
  return double_value_;
}
bool TypedValueProto::has_double_value() const {
  return has_double_value_;
}
void TypedValueProto::clear_double_value() {
  double_value_ = double();
  has_double_value_ = false;
  if (value_case_ == kDoubleValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_double_value(double new_double_value) {
  clear_value();
  value_case_ = kDoubleValue;
  double_value_ = new_double_value;
  has_double_value_ = true;
}
double* TypedValueProto::mutable_double_value() {
  clear_value();
  value_case_ = kDoubleValue;
  has_double_value_ = true;
  return &double_value_;
}

std::string TypedValueProto::string_value() const {
  return string_value_;
}
bool TypedValueProto::has_string_value() const {
  return has_string_value_;
}
void TypedValueProto::clear_string_value() {
  string_value_ = std::string();
  has_string_value_ = false;
  if (value_case_ == kStringValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_string_value(std::string new_string_value) {
  clear_value();
  value_case_ = kStringValue;
  string_value_ = new_string_value;
  has_string_value_ = true;
}
std::string* TypedValueProto::mutable_string_value() {
  clear_value();
  value_case_ = kStringValue;
  has_string_value_ = true;
  return &string_value_;
}

const StringListProto& TypedValueProto::string_list_value() const {
  return string_list_value_;
}
bool TypedValueProto::has_string_list_value() const {
  return has_string_list_value_;
}
void TypedValueProto::clear_string_list_value() {
  string_list_value_ = StringListProto();
  has_string_list_value_ = false;
  if (value_case_ == kStringListValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_string_list_value(const StringListProto& new_string_list_value) {
  clear_value();
  value_case_ = kStringListValue;
  string_list_value_ = new_string_list_value;
  has_string_list_value_ = true;
}
StringListProto* TypedValueProto::mutable_string_list_value() {
  clear_value();
  value_case_ = kStringListValue;
  has_string_list_value_ = true;
  return &string_list_value_;
}

const IntListProto& TypedValueProto::int_list_value() const {
  return int_list_value_;
}
bool TypedValueProto::has_int_list_value() const {
  return has_int_list_value_;
}
void TypedValueProto::clear_int_list_value() {
  int_list_value_ = IntListProto();
  has_int_list_value_ = false;
  if (value_case_ == kIntListValue) {
    value_case_ = VALUE_NOT_SET;
  }
}
void TypedValueProto::set_int_list_value(const IntListProto& new_int_list_value) {
  clear_value();
  value_case_ = kIntListValue;
  int_list_value_ = new_int_list_value;
  has_int_list_value_ = true;
}
IntListProto* TypedValueProto::mutable_int_list_value() {
  clear_value();
  value_case_ = kIntListValue;
  has_int_list_value_ = true;
  return &int_list_value_;
}



std::string MetadataProto_MetadataMapEntry::key() const {
  return key_;
}
bool MetadataProto_MetadataMapEntry::has_key() const {
  return has_key_;
}
void MetadataProto_MetadataMapEntry::clear_key() {
  key_ = std::string();
  has_key_ = false;
}
void MetadataProto_MetadataMapEntry::set_key(std::string new_key) {
  key_ = new_key;
  has_key_ = true;
}
std::string* MetadataProto_MetadataMapEntry::mutable_key() {
  has_key_ = true;
  return &key_;
}

const TypedValueProto& MetadataProto_MetadataMapEntry::value() const {
  return value_;
}
bool MetadataProto_MetadataMapEntry::has_value() const {
  return has_value_;
}
void MetadataProto_MetadataMapEntry::clear_value() {
  value_ = TypedValueProto();
  has_value_ = false;
}
void MetadataProto_MetadataMapEntry::set_value(const TypedValueProto& new_value) {
  value_ = new_value;
  has_value_ = true;
}
TypedValueProto* MetadataProto_MetadataMapEntry::mutable_value() {
  has_value_ = true;
  return &value_;
}


const std::map<std::string, TypedValueProto>& MetadataProto::metadata_map() const {
  return metadata_map_;
}
bool MetadataProto::has_metadata_map() const {
  return has_metadata_map_;
}
void MetadataProto::clear_metadata_map() {
  metadata_map_ = std::map<std::string, TypedValueProto>();
  has_metadata_map_ = false;
}
void MetadataProto::set_metadata_map(const std::map<std::string, TypedValueProto>& new_metadata_map) {
  metadata_map_ = new_metadata_map;
  has_metadata_map_ = true;
}
std::map<std::string, TypedValueProto>* MetadataProto::mutable_metadata_map() {
  has_metadata_map_ = true;
  return &metadata_map_;
}


std::string CheckResultProto::source_check_class() const {
  return source_check_class_;
}
bool CheckResultProto::has_source_check_class() const {
  return has_source_check_class_;
}
void CheckResultProto::clear_source_check_class() {
  source_check_class_ = std::string();
  has_source_check_class_ = false;
}
void CheckResultProto::set_source_check_class(std::string new_source_check_class) {
  source_check_class_ = new_source_check_class;
  has_source_check_class_ = true;
}
std::string* CheckResultProto::mutable_source_check_class() {
  has_source_check_class_ = true;
  return &source_check_class_;
}

int32_t CheckResultProto::result_id() const {
  return result_id_;
}
bool CheckResultProto::has_result_id() const {
  return has_result_id_;
}
void CheckResultProto::clear_result_id() {
  result_id_ = int32_t();
  has_result_id_ = false;
}
void CheckResultProto::set_result_id(int32_t new_result_id) {
  result_id_ = new_result_id;
  has_result_id_ = true;
}
int32_t* CheckResultProto::mutable_result_id() {
  has_result_id_ = true;
  return &result_id_;
}

int64_t CheckResultProto::hierarchy_source_id() const {
  return hierarchy_source_id_;
}
bool CheckResultProto::has_hierarchy_source_id() const {
  return has_hierarchy_source_id_;
}
void CheckResultProto::clear_hierarchy_source_id() {
  hierarchy_source_id_ = int64_t();
  has_hierarchy_source_id_ = false;
}
void CheckResultProto::set_hierarchy_source_id(int64_t new_hierarchy_source_id) {
  hierarchy_source_id_ = new_hierarchy_source_id;
  has_hierarchy_source_id_ = true;
}
int64_t* CheckResultProto::mutable_hierarchy_source_id() {
  has_hierarchy_source_id_ = true;
  return &hierarchy_source_id_;
}

ResultType CheckResultProto::result_type() const {
  return result_type_;
}
bool CheckResultProto::has_result_type() const {
  return has_result_type_;
}
void CheckResultProto::clear_result_type() {
  result_type_ = ResultType();
  has_result_type_ = false;
}
void CheckResultProto::set_result_type(ResultType new_result_type) {
  result_type_ = new_result_type;
  has_result_type_ = true;
}
ResultType* CheckResultProto::mutable_result_type() {
  has_result_type_ = true;
  return &result_type_;
}

const MetadataProto& CheckResultProto::metadata() const {
  return metadata_;
}
bool CheckResultProto::has_metadata() const {
  return has_metadata_;
}
void CheckResultProto::clear_metadata() {
  metadata_ = MetadataProto();
  has_metadata_ = false;
}
void CheckResultProto::set_metadata(const MetadataProto& new_metadata) {
  metadata_ = new_metadata;
  has_metadata_ = true;
}
MetadataProto* CheckResultProto::mutable_metadata() {
  has_metadata_ = true;
  return &metadata_;
}


const AccessibilityHierarchy& AccessibilityEvaluation::hierarchy() const {
  return hierarchy_;
}
bool AccessibilityEvaluation::has_hierarchy() const {
  return has_hierarchy_;
}
void AccessibilityEvaluation::clear_hierarchy() {
  hierarchy_ = AccessibilityHierarchy();
  has_hierarchy_ = false;
}
void AccessibilityEvaluation::set_hierarchy(const AccessibilityHierarchy& new_hierarchy) {
  hierarchy_ = new_hierarchy;
  has_hierarchy_ = true;
}
AccessibilityHierarchy* AccessibilityEvaluation::mutable_hierarchy() {
  has_hierarchy_ = true;
  return &hierarchy_;
}

const CheckResultProto& AccessibilityEvaluation::results(int index) const {
  return results_[index];
}
const std::vector<CheckResultProto>& AccessibilityEvaluation::results() const {
  return results_;
}
bool AccessibilityEvaluation::has_results() const {
  return has_results_;
}
void AccessibilityEvaluation::clear_results() {
  results_.clear();
  has_results_ = false;
}
void AccessibilityEvaluation::set_results(int index, const CheckResultProto& new_results) {
  results_[index] = new_results;
  has_results_ = true;
}
CheckResultProto* AccessibilityEvaluation::mutable_results(int index) {
  has_results_ = true;
  return &results_[index];
}
CheckResultProto* AccessibilityEvaluation::add_results() {
  results_.emplace_back();
  has_results_ = true;
  return &results_.back();
}
int AccessibilityEvaluation::results_size() const {
  return results_.size();
}

}  // GTXiLib
}  // OOPClasses
}  // Protos
