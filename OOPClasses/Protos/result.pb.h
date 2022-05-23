#ifndef THIRD_PARTY_OBJECTIVE_C_GTXILIB_OOPCLASSES_PROTOS_RESULT_PB_H
#define THIRD_PARTY_OBJECTIVE_C_GTXILIB_OOPCLASSES_PROTOS_RESULT_PB_H

#include <map>
#include <string>
#include <stdlib.h>
#include <vector>

#include "enums.pb.h"
#include "gtx.pb.h"

namespace gtxilib {
namespace oopclasses {
namespace protos {




class StringListProto {

public:


  std::string values(int index) const;
  const std::vector<std::string>& values() const;
  bool has_values() const;
  void clear_values();
  void set_values(int index, std::string new_values);
  std::string* mutable_values(int index);
  void add_values(std::string new_values);
  int values_size() const;

private:
  std::vector<std::string> values_ = std::vector<std::string>();
  bool has_values_ = false;
};


class IntListProto {

public:


  int32_t values(int index) const;
  const std::vector<int32_t>& values() const;
  bool has_values() const;
  void clear_values();
  void set_values(int index, int32_t new_values);
  int32_t* mutable_values(int index);
  void add_values(int32_t new_values);
  int values_size() const;

private:
  std::vector<int32_t> values_ = std::vector<int32_t>();
  bool has_values_ = false;
};

enum TypedValueProto_TypeProto : int {
  TypedValueProto_TypeProto_UNKNOWN = 0,
  TypedValueProto_TypeProto_BOOLEAN = 1,
  TypedValueProto_TypeProto_BYTE = 2,
  TypedValueProto_TypeProto_SHORT = 3,
  TypedValueProto_TypeProto_CHAR = 4,
  TypedValueProto_TypeProto_INT = 5,
  TypedValueProto_TypeProto_FLOAT = 6,
  TypedValueProto_TypeProto_LONG = 7,
  TypedValueProto_TypeProto_DOUBLE = 8,
  TypedValueProto_TypeProto_STRING = 9,
  TypedValueProto_TypeProto_STRING_LIST = 10,
  TypedValueProto_TypeProto_INT_LIST = 11,
};

class TypedValueProto {

public:

  typedef TypedValueProto_TypeProto TypeProto;
  static constexpr TypedValueProto_TypeProto UNKNOWN = TypedValueProto_TypeProto_UNKNOWN;
  static constexpr TypedValueProto_TypeProto BOOLEAN = TypedValueProto_TypeProto_BOOLEAN;
  static constexpr TypedValueProto_TypeProto BYTE = TypedValueProto_TypeProto_BYTE;
  static constexpr TypedValueProto_TypeProto SHORT = TypedValueProto_TypeProto_SHORT;
  static constexpr TypedValueProto_TypeProto CHAR = TypedValueProto_TypeProto_CHAR;
  static constexpr TypedValueProto_TypeProto INT = TypedValueProto_TypeProto_INT;
  static constexpr TypedValueProto_TypeProto FLOAT = TypedValueProto_TypeProto_FLOAT;
  static constexpr TypedValueProto_TypeProto LONG = TypedValueProto_TypeProto_LONG;
  static constexpr TypedValueProto_TypeProto DOUBLE = TypedValueProto_TypeProto_DOUBLE;
  static constexpr TypedValueProto_TypeProto STRING = TypedValueProto_TypeProto_STRING;
  static constexpr TypedValueProto_TypeProto STRING_LIST = TypedValueProto_TypeProto_STRING_LIST;
  static constexpr TypedValueProto_TypeProto INT_LIST = TypedValueProto_TypeProto_INT_LIST;
  enum ValueCase {
    kBooleanValue = 2,
    kByteValue = 3,
    kShortValue = 4,
    kCharValue = 5,
    kIntValue = 6,
    kFloatValue = 7,
    kLongValue = 8,
    kDoubleValue = 9,
    kStringValue = 10,
    kStringListValue = 11,
    kIntListValue = 12,
    VALUE_NOT_SET = 0,
  };
  void clear_value();
  ValueCase value_case() const;

  TypedValueProto_TypeProto type() const;
  bool has_type() const;
  void clear_type();
  void set_type(TypedValueProto_TypeProto new_type);
  TypedValueProto_TypeProto* mutable_type();

  bool boolean_value() const;
  bool has_boolean_value() const;
  void clear_boolean_value();
  void set_boolean_value(bool new_boolean_value);
  bool* mutable_boolean_value();

  std::string byte_value() const;
  bool has_byte_value() const;
  void clear_byte_value();
  void set_byte_value(std::string new_byte_value);
  std::string* mutable_byte_value();

  std::string short_value() const;
  bool has_short_value() const;
  void clear_short_value();
  void set_short_value(std::string new_short_value);
  std::string* mutable_short_value();

  std::string char_value() const;
  bool has_char_value() const;
  void clear_char_value();
  void set_char_value(std::string new_char_value);
  std::string* mutable_char_value();

  int32_t int_value() const;
  bool has_int_value() const;
  void clear_int_value();
  void set_int_value(int32_t new_int_value);
  int32_t* mutable_int_value();

  float float_value() const;
  bool has_float_value() const;
  void clear_float_value();
  void set_float_value(float new_float_value);
  float* mutable_float_value();

  int64_t long_value() const;
  bool has_long_value() const;
  void clear_long_value();
  void set_long_value(int64_t new_long_value);
  int64_t* mutable_long_value();

  double double_value() const;
  bool has_double_value() const;
  void clear_double_value();
  void set_double_value(double new_double_value);
  double* mutable_double_value();

  std::string string_value() const;
  bool has_string_value() const;
  void clear_string_value();
  void set_string_value(std::string new_string_value);
  std::string* mutable_string_value();

  const StringListProto& string_list_value() const;
  bool has_string_list_value() const;
  void clear_string_list_value();
  void set_string_list_value(const StringListProto& new_string_list_value);
  StringListProto* mutable_string_list_value();

  const IntListProto& int_list_value() const;
  bool has_int_list_value() const;
  void clear_int_list_value();
  void set_int_list_value(const IntListProto& new_int_list_value);
  IntListProto* mutable_int_list_value();

private:
  ValueCase value_case_;
  TypedValueProto_TypeProto type_ = TypedValueProto_TypeProto();
  bool has_type_ = false;
  bool boolean_value_ = bool();
  bool has_boolean_value_ = false;
  std::string byte_value_ = std::string();
  bool has_byte_value_ = false;
  std::string short_value_ = std::string();
  bool has_short_value_ = false;
  std::string char_value_ = std::string();
  bool has_char_value_ = false;
  int32_t int_value_ = int32_t();
  bool has_int_value_ = false;
  float float_value_ = float();
  bool has_float_value_ = false;
  int64_t long_value_ = int64_t();
  bool has_long_value_ = false;
  double double_value_ = double();
  bool has_double_value_ = false;
  std::string string_value_ = std::string();
  bool has_string_value_ = false;
  StringListProto string_list_value_ = StringListProto();
  bool has_string_list_value_ = false;
  IntListProto int_list_value_ = IntListProto();
  bool has_int_list_value_ = false;
};



class MetadataProto_MetadataMapEntry {

public:


  std::string key() const;
  bool has_key() const;
  void clear_key();
  void set_key(std::string new_key);
  std::string* mutable_key();

  const TypedValueProto& value() const;
  bool has_value() const;
  void clear_value();
  void set_value(const TypedValueProto& new_value);
  TypedValueProto* mutable_value();

private:
  std::string key_ = std::string();
  bool has_key_ = false;
  TypedValueProto value_ = TypedValueProto();
  bool has_value_ = false;
};

class MetadataProto {

public:

  typedef MetadataProto_MetadataMapEntry MetadataMapEntry;

  const std::map<std::string, TypedValueProto>& metadata_map() const;
  bool has_metadata_map() const;
  void clear_metadata_map();
  void set_metadata_map(const std::map<std::string, TypedValueProto>& new_metadata_map);
  std::map<std::string, TypedValueProto>* mutable_metadata_map();

private:
  std::map<std::string, TypedValueProto> metadata_map_ = std::map<std::string, TypedValueProto>();
  bool has_metadata_map_ = false;
};


class CheckResultProto {

public:


  std::string source_check_class() const;
  bool has_source_check_class() const;
  void clear_source_check_class();
  void set_source_check_class(std::string new_source_check_class);
  std::string* mutable_source_check_class();

  int32_t result_id() const;
  bool has_result_id() const;
  void clear_result_id();
  void set_result_id(int32_t new_result_id);
  int32_t* mutable_result_id();

  int64_t hierarchy_source_id() const;
  bool has_hierarchy_source_id() const;
  void clear_hierarchy_source_id();
  void set_hierarchy_source_id(int64_t new_hierarchy_source_id);
  int64_t* mutable_hierarchy_source_id();

  ResultType result_type() const;
  bool has_result_type() const;
  void clear_result_type();
  void set_result_type(ResultType new_result_type);
  ResultType* mutable_result_type();

  const MetadataProto& metadata() const;
  bool has_metadata() const;
  void clear_metadata();
  void set_metadata(const MetadataProto& new_metadata);
  MetadataProto* mutable_metadata();

private:
  std::string source_check_class_ = std::string();
  bool has_source_check_class_ = false;
  int32_t result_id_ = int32_t();
  bool has_result_id_ = false;
  int64_t hierarchy_source_id_ = int64_t();
  bool has_hierarchy_source_id_ = false;
  ResultType result_type_ = ResultType();
  bool has_result_type_ = false;
  MetadataProto metadata_ = MetadataProto();
  bool has_metadata_ = false;
};


class AccessibilityEvaluation {

public:


  const AccessibilityHierarchy& hierarchy() const;
  bool has_hierarchy() const;
  void clear_hierarchy();
  void set_hierarchy(const AccessibilityHierarchy& new_hierarchy);
  AccessibilityHierarchy* mutable_hierarchy();

  const CheckResultProto& results(int index) const;
  const std::vector<CheckResultProto>& results() const;
  bool has_results() const;
  void clear_results();
  void set_results(int index, const CheckResultProto& new_results);
  CheckResultProto* mutable_results(int index);
  CheckResultProto* add_results();
  int results_size() const;

private:
  AccessibilityHierarchy hierarchy_ = AccessibilityHierarchy();
  bool has_hierarchy_ = false;
  std::vector<CheckResultProto> results_ = std::vector<CheckResultProto>();
  bool has_results_ = false;
};

}  // GTXiLib
}  // OOPClasses
}  // Protos

#endif
