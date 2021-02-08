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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes a @c UIView or @c UIAccessibilityElement without referencing the original object. The
 * entry point for comparing if two elements refer to the same conceptual element (which may not be
 * literally the same element. For example, table views might use different reusable cells for the
 * same cell at different times, but both refer to the same element).
 */
@interface GTXElementReference : NSObject

/**
 * The address of the object. Not an actual reference to avoid retain cycles are automatically being
 * set to nil.
 */
@property(assign, nonatomic, readonly) NSUInteger elementAddress;

/**
 * The class of the element.
 */
@property(strong, nonatomic, readonly) Class elementClass;

/**
 * The accessibility label of the element, if exists.
 */
@property(copy, nonatomic, nullable, readonly) NSString *accessibilityLabel;

/**
 * The accessibility identifier of the element, if exists.
 */
@property(copy, nonatomic, nullable, readonly) NSString *accessibilityIdentifier;

/**
 * The accessibility frame of the element.
 */
@property(assign, nonatomic, readonly) CGRect accessibilityFrame;

/**
 * A human readable description of the element.
 */
@property(copy, nonatomic, readonly) NSString *elementDescription;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes this instance with the given properties describing a @c UIView or
 * @c UIAccessibilityElement.
 *
 * @param elementAddress The original element's memory address as an integer.
 * @param elementClass The original element's class.
 * @param accessibilityLabel Optional. The original element's accessibility label.
 * @param accessibilityIdentifier Optional. The original element's accessibility identifier.
 * @param accessibilityFrame The original element's accessibility frame.
 * @param elementDescription A concise, human readable description of the element.
 * @return An initialized @c GTXElementReference instance.
 */
- (instancetype)initWithElementAddress:(NSUInteger)elementAddress
                          elementClass:(Class)elementClass
                    accessibilityLabel:(nullable NSString *)accessibilityLabel
               accessibilityIdentifier:(nullable NSString *)accessibilityIdentifier
                    accessibilityFrame:(CGRect)accessibilityFrame
                    elementDescription:(NSString *)elementDescription NS_DESIGNATED_INITIALIZER;

/**
 * Initializes this element with the properties in @c element.
 *
 * @param element The element this instance should reference, based on its accessibility properties.
 * @return An initialized @c GTXElementReference instance.
 */
- (instancetype)initWithElement:(id)element;

/**
 * Constructs a @c GTXElementReference object from an error produced by a @c GTXChecking instance.
 *
 * @param error An error produced by a @c GTXChecking instance. Fails with an assertion if
 * @c error.userInfo does not contain the key @c kGTXErrorFailingElementKey.
 */
- (instancetype)initWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
