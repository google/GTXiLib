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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#include <abseil/absl/types/optional.h>

/**
 * A key used to enter values into a MetadataMap.
 */
static const std::string kGTXMapKey = "key";

/**
 * Error margin used for floating point comparisons.
 */
static const CGFloat kGTXTestAccuracy = 0.001f;

// Constants used in tests.
static const bool kGTXTestBool = true;
static const gtx::MetadataMap::byte kGTXTestByte = 2;
static const int16 kGTXTestShort = 257;
static const char kGTXTestChar = 'A';
static const int kGTXTestInt = 65536;
static const int64 kGTXTestLong = 4294967296;
static const float kGTXTestFloat = 2.0f;
static const double kGTXTestDouble = 3.0;
static const std::string kGTXTestString = "test";
static const std::vector<std::string> kGTXTestStringList({"test 1", "test 2", "test 3"});
static const std::vector<int> kGTXTestIntList({1, 2, 3});

@interface GTXMetadataMapTests : XCTestCase
@end

@implementation GTXMetadataMapTests

- (void)testSetBool {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetBool(kGTXMapKey, kGTXTestBool);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetBool {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetBool(kGTXMapKey), absl::nullopt);
  map.SetBool(kGTXMapKey, kGTXTestBool);
  XCTAssertEqual(map.GetBool(kGTXMapKey), kGTXTestBool);
}

- (void)testSetByte {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetByte(kGTXMapKey, kGTXTestByte);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetByte {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetByte(kGTXMapKey), absl::nullopt);
  map.SetByte(kGTXMapKey, kGTXTestByte);
  XCTAssertEqual(map.GetByte(kGTXMapKey), kGTXTestByte);
}

- (void)testSetShort {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetShort(kGTXMapKey, kGTXTestShort);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetShort {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetShort(kGTXMapKey), absl::nullopt);
  map.SetShort(kGTXMapKey, kGTXTestShort);
  XCTAssertEqual(map.GetShort(kGTXMapKey), kGTXTestShort);
}

- (void)testSetChar {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetChar(kGTXMapKey, kGTXTestChar);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetChar {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetChar(kGTXMapKey), absl::nullopt);
  map.SetChar(kGTXMapKey, kGTXTestChar);
  XCTAssertEqual(map.GetChar(kGTXMapKey), kGTXTestChar);
}

- (void)testSetInt {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetInt(kGTXMapKey, kGTXTestInt);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetInt {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetInt(kGTXMapKey), absl::nullopt);
  map.SetInt(kGTXMapKey, kGTXTestInt);
  XCTAssertEqual(map.GetInt(kGTXMapKey), kGTXTestInt);
}

- (void)testSetLong {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetLong(kGTXMapKey, kGTXTestLong);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetLong {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetLong(kGTXMapKey), absl::nullopt);
  map.SetLong(kGTXMapKey, kGTXTestLong);
  XCTAssertEqual(map.GetLong(kGTXMapKey), kGTXTestLong);
}

- (void)testSetFloat {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetFloat(kGTXMapKey, kGTXTestFloat);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetFloat {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetFloat(kGTXMapKey), absl::nullopt);
  map.SetFloat(kGTXMapKey, kGTXTestFloat);
  absl::optional<float> value = map.GetFloat(kGTXMapKey);
  XCTAssert(value.has_value());
  float floatValue = *value;
  XCTAssertEqualWithAccuracy(floatValue, kGTXTestFloat, kGTXTestAccuracy);
}

- (void)testSetDouble {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetDouble(kGTXMapKey, kGTXTestDouble);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetDouble {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetDouble(kGTXMapKey), absl::nullopt);
  map.SetDouble(kGTXMapKey, kGTXTestDouble);
  absl::optional<double> value = map.GetDouble(kGTXMapKey);
  XCTAssert(value.has_value());
  double doubleValue = *value;
  XCTAssertEqualWithAccuracy(doubleValue, kGTXTestDouble, kGTXTestAccuracy);
}

- (void)testSetString {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetString(kGTXMapKey, kGTXTestString);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetString {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetString(kGTXMapKey), absl::nullopt);
  map.SetString(kGTXMapKey, kGTXTestString);
  XCTAssertEqual(map.GetString(kGTXMapKey), kGTXTestString);
}

- (void)testSetStringList {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetStringList(kGTXMapKey, kGTXTestStringList);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetStringList {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetStringList(kGTXMapKey), absl::nullopt);
  map.SetStringList(kGTXMapKey, kGTXTestStringList);
  XCTAssertEqual(map.GetStringList(kGTXMapKey), kGTXTestStringList);
}

- (void)testSetIntList {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetIntList(kGTXMapKey, kGTXTestIntList);
  XCTAssertTrue(map.Contains(kGTXMapKey));
}

- (void)testGetIntList {
  gtx::MetadataMap map;
  XCTAssertEqual(map.GetIntList(kGTXMapKey), absl::nullopt);
  map.SetIntList(kGTXMapKey, kGTXTestIntList);
  XCTAssertEqual(map.GetIntList(kGTXMapKey), kGTXTestIntList);
}

- (void)testSettingSameKeyOverridesOldKey {
  gtx::MetadataMap map;
  XCTAssertFalse(map.Contains(kGTXMapKey));
  map.SetInt(kGTXMapKey, kGTXTestInt);
  XCTAssertTrue(map.Contains(kGTXMapKey));
  XCTAssertEqual(map.GetInt(kGTXMapKey), kGTXTestInt);
  map.SetLong(kGTXMapKey, kGTXTestLong);
  XCTAssertEqual(map.GetInt(kGTXMapKey), absl::nullopt);
  XCTAssertEqual(map.GetLong(kGTXMapKey), kGTXTestLong);
}

- (void)testToProto {
  gtx::MetadataMap map;
  map.SetInt(kGTXMapKey, kGTXTestInt);
  MetadataProto proto = map.ToProto();
  XCTAssert(proto.metadata_map().contains(kGTXMapKey));
  XCTAssert(proto.metadata_map().at(kGTXMapKey).has_int_value());
  XCTAssertEqual(proto.metadata_map().at(kGTXMapKey).int_value(), kGTXTestInt);
}

- (void)testFromProto {
  MetadataProto proto;
  TypedValueProto typedValueProto;
  typedValueProto.set_int_value(kGTXTestInt);
  (*proto.mutable_metadata_map())[kGTXMapKey] = typedValueProto;
  gtx::MetadataMap map = gtx::MetadataMap::FromProto(proto);
  XCTAssert(map.Contains(kGTXMapKey));
  XCTAssertEqual(map.GetInt(kGTXMapKey), kGTXTestInt);
}

@end
