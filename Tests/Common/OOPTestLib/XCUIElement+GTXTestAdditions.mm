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

#import "XCUIElement+GTXTestAdditions.h"

#import "NSString+GTXAdditions.h"

@implementation XCUIElement (GTXTestAdditions)

// TODO: Update this code to accurately capture the hierarchy, sometimes we seem to be
// getting duplicate entries.
- (UIAccessibilityElement *)gtxtest_accessibilityElementWithContainer:(id)container {
  UIAccessibilityElement *element =
      [[UIAccessibilityElement alloc] initWithAccessibilityContainer:container];
  element.accessibilityLabel = [self label];
  element.accessibilityFrame = [self frame];
  element.accessibilityIdentifier = [self identifier];
  element.accessibilityTraits = [self gtxtest_accessibilityTraits];
  NSMutableArray<UIAccessibilityElement *> *children;
  NSArray<XCUIElement *> *decendents =
      [[self descendantsMatchingType:XCUIElementTypeAny] allElementsBoundByIndex];
  for (XCUIElement *element in decendents) {
    if (!children) {
      children = [[NSMutableArray alloc] init];
    }
    UIAccessibilityElement *child = [element gtxtest_accessibilityElementWithContainer:element];
    [children addObject:child];
  }
  element.accessibilityElements = children;
  element.isAccessibilityElement = children.count ? NO : YES;
  return element;
}

- (UIAccessibilityTraits)gtxtest_accessibilityTraits {
  UIAccessibilityTraits traits = 0;
  if (self.elementType == XCUIElementTypeStaticText) {
    traits |= UIAccessibilityTraitStaticText;
  }
  if (self.elementType == XCUIElementTypeButton) {
    traits |= UIAccessibilityTraitButton;
  }
  return traits;
}

- (std::unique_ptr<gtx::UIElement>)gtxtest_UIElement {
  BOOL hasChildren = [[self childrenMatchingType:XCUIElementTypeAny] count];
  auto element = std::make_unique<gtx::UIElement>();
  element->set_is_ax_element(hasChildren ? true : false);
  element->set_ax_label([[self label] gtx_stdString]);
  gtx::RectData rectData;
  rectData.mutable_size()->set_width(self.frame.size.width);
  rectData.mutable_size()->set_height(self.frame.size.height);
  rectData.mutable_origin()->set_x(self.frame.origin.x);
  rectData.mutable_origin()->set_y(self.frame.origin.y);
  element->set_ax_frame(rectData);
  element->set_element_type([XCUIElement gtxtest_elementTypeFromXCUIElementType:self.elementType]);
  return element;
}

+ (gtx::ElementType::ElementTypeEnum)gtxtest_elementTypeFromXCUIElementType:
    (XCUIElementType)elementType {
  if (elementType == XCUIElementTypeAny) {
    return gtx::ElementType::ANY;
  } else if (elementType == XCUIElementTypeOther) {
    return gtx::ElementType::OTHER;
  } else if (elementType == XCUIElementTypeApplication) {
    return gtx::ElementType::APPLICATION;
  } else if (elementType == XCUIElementTypeGroup) {
    return gtx::ElementType::GROUP;
  } else if (elementType == XCUIElementTypeWindow) {
    return gtx::ElementType::WINDOW;
  } else if (elementType == XCUIElementTypeSheet) {
    return gtx::ElementType::SHEET;
  } else if (elementType == XCUIElementTypeDrawer) {
    return gtx::ElementType::DRAWER;
  } else if (elementType == XCUIElementTypeAlert) {
    return gtx::ElementType::ALERT;
  } else if (elementType == XCUIElementTypeDialog) {
    return gtx::ElementType::DIALOG;
  } else if (elementType == XCUIElementTypeButton) {
    return gtx::ElementType::BUTTON;
  } else if (elementType == XCUIElementTypeRadioButton) {
    return gtx::ElementType::RADIO_BUTTON;
  } else if (elementType == XCUIElementTypeRadioGroup) {
    return gtx::ElementType::RADIO_GROUP;
  } else if (elementType == XCUIElementTypeCheckBox) {
    return gtx::ElementType::CHECK_BOX;
  } else if (elementType == XCUIElementTypeDisclosureTriangle) {
    return gtx::ElementType::DISCLOSURE_TRIANGLE;
  } else if (elementType == XCUIElementTypePopUpButton) {
    return gtx::ElementType::POP_UP_BUTTON;
  } else if (elementType == XCUIElementTypeComboBox) {
    return gtx::ElementType::COMBO_BOX;
  } else if (elementType == XCUIElementTypeMenuButton) {
    return gtx::ElementType::MENU_BUTTON;
  } else if (elementType == XCUIElementTypeToolbarButton) {
    return gtx::ElementType::TOOLBAR_BUTTON;
  } else if (elementType == XCUIElementTypePopover) {
    return gtx::ElementType::POPOVER;
  } else if (elementType == XCUIElementTypeKeyboard) {
    return gtx::ElementType::KEYBOARD;
  } else if (elementType == XCUIElementTypeKey) {
    return gtx::ElementType::KEY;
  } else if (elementType == XCUIElementTypeNavigationBar) {
    return gtx::ElementType::NAVIGATION_BAR;
  } else if (elementType == XCUIElementTypeTabBar) {
    return gtx::ElementType::TAB_BAR;
  } else if (elementType == XCUIElementTypeTabGroup) {
    return gtx::ElementType::TAB_GROUP;
  } else if (elementType == XCUIElementTypeToolbar) {
    return gtx::ElementType::TOOLBAR;
  } else if (elementType == XCUIElementTypeStatusBar) {
    return gtx::ElementType::STATUS_BAR;
  } else if (elementType == XCUIElementTypeTable) {
    return gtx::ElementType::TABLE;
  } else if (elementType == XCUIElementTypeTableRow) {
    return gtx::ElementType::TABLE_ROW;
  } else if (elementType == XCUIElementTypeTableColumn) {
    return gtx::ElementType::TABLE_COLUMN;
  } else if (elementType == XCUIElementTypeOutline) {
    return gtx::ElementType::OUTLINE;
  } else if (elementType == XCUIElementTypeOutlineRow) {
    return gtx::ElementType::OUTLINE_ROW;
  } else if (elementType == XCUIElementTypeBrowser) {
    return gtx::ElementType::BROWSER;
  } else if (elementType == XCUIElementTypeCollectionView) {
    return gtx::ElementType::COLLECTION_VIEW;
  } else if (elementType == XCUIElementTypeSlider) {
    return gtx::ElementType::SLIDER;
  } else if (elementType == XCUIElementTypePageIndicator) {
    return gtx::ElementType::PAGE_INDICATOR;
  } else if (elementType == XCUIElementTypeProgressIndicator) {
    return gtx::ElementType::PROGRESS_INDICATOR;
  } else if (elementType == XCUIElementTypeActivityIndicator) {
    return gtx::ElementType::ACTIVITY_INDICATOR;
  } else if (elementType == XCUIElementTypeSegmentedControl) {
    return gtx::ElementType::SEGMENTED_CONTROL;
  } else if (elementType == XCUIElementTypePicker) {
    return gtx::ElementType::PICKER;
  } else if (elementType == XCUIElementTypePickerWheel) {
    return gtx::ElementType::PICKER_WHEEL;
  } else if (elementType == XCUIElementTypeSwitch) {
    return gtx::ElementType::SWITCH;
  } else if (elementType == XCUIElementTypeToggle) {
    return gtx::ElementType::TOGGLE;
  } else if (elementType == XCUIElementTypeLink) {
    return gtx::ElementType::LINK;
  } else if (elementType == XCUIElementTypeImage) {
    return gtx::ElementType::IMAGE;
  } else if (elementType == XCUIElementTypeIcon) {
    return gtx::ElementType::ICON;
  } else if (elementType == XCUIElementTypeSearchField) {
    return gtx::ElementType::SEARCH_FIELD;
  } else if (elementType == XCUIElementTypeScrollView) {
    return gtx::ElementType::SCROLL_VIEW;
  } else if (elementType == XCUIElementTypeScrollBar) {
    return gtx::ElementType::SCROLL_BAR;
  } else if (elementType == XCUIElementTypeStaticText) {
    return gtx::ElementType::STATIC_TEXT;
  } else if (elementType == XCUIElementTypeTextField) {
    return gtx::ElementType::TEXT_FIELD;
  } else if (elementType == XCUIElementTypeSecureTextField) {
    return gtx::ElementType::SECURE_TEXT_FIELD;
  } else if (elementType == XCUIElementTypeDatePicker) {
    return gtx::ElementType::DATE_PICKER;
  } else if (elementType == XCUIElementTypeTextView) {
    return gtx::ElementType::TEXT_VIEW;
  } else if (elementType == XCUIElementTypeMenu) {
    return gtx::ElementType::MENU;
  } else if (elementType == XCUIElementTypeMenuItem) {
    return gtx::ElementType::MENU_ITEM;
  } else if (elementType == XCUIElementTypeMenuBar) {
    return gtx::ElementType::MENU_BAR;
  } else if (elementType == XCUIElementTypeMenuBarItem) {
    return gtx::ElementType::MENU_BAR_ITEM;
  } else if (elementType == XCUIElementTypeMap) {
    return gtx::ElementType::MAP;
  } else if (elementType == XCUIElementTypeWebView) {
    return gtx::ElementType::WEB_VIEW;
  } else if (elementType == XCUIElementTypeIncrementArrow) {
    return gtx::ElementType::INCREMENT_ARROW;
  } else if (elementType == XCUIElementTypeDecrementArrow) {
    return gtx::ElementType::DECREMENT_ARROW;
  } else if (elementType == XCUIElementTypeTimeline) {
    return gtx::ElementType::TIMELINE;
  } else if (elementType == XCUIElementTypeRatingIndicator) {
    return gtx::ElementType::RATING_INDICATOR;
  } else if (elementType == XCUIElementTypeValueIndicator) {
    return gtx::ElementType::VALUE_INDICATOR;
  } else if (elementType == XCUIElementTypeSplitGroup) {
    return gtx::ElementType::SPLIT_GROUP;
  } else if (elementType == XCUIElementTypeSplitter) {
    return gtx::ElementType::SPLITTER;
  } else if (elementType == XCUIElementTypeRelevanceIndicator) {
    return gtx::ElementType::RELEVANCE_INDICATOR;
  } else if (elementType == XCUIElementTypeColorWell) {
    return gtx::ElementType::COLOR_WELL;
  } else if (elementType == XCUIElementTypeHelpTag) {
    return gtx::ElementType::HELP_TAG;
  } else if (elementType == XCUIElementTypeMatte) {
    return gtx::ElementType::MATTE;
  } else if (elementType == XCUIElementTypeDockItem) {
    return gtx::ElementType::DOCK_ITEM;
  } else if (elementType == XCUIElementTypeRuler) {
    return gtx::ElementType::RULER;
  } else if (elementType == XCUIElementTypeRulerMarker) {
    return gtx::ElementType::RULER_MARKER;
  } else if (elementType == XCUIElementTypeGrid) {
    return gtx::ElementType::GRID;
  } else if (elementType == XCUIElementTypeLevelIndicator) {
    return gtx::ElementType::LEVEL_INDICATOR;
  } else if (elementType == XCUIElementTypeCell) {
    return gtx::ElementType::CELL;
  } else if (elementType == XCUIElementTypeLayoutArea) {
    return gtx::ElementType::LAYOUT_AREA;
  } else if (elementType == XCUIElementTypeLayoutItem) {
    return gtx::ElementType::LAYOUT_ITEM;
  } else if (elementType == XCUIElementTypeHandle) {
    return gtx::ElementType::HANDLE;
  } else if (elementType == XCUIElementTypeStepper) {
    return gtx::ElementType::STEPPER;
  } else if (elementType == XCUIElementTypeTab) {
    return gtx::ElementType::TAB;
  } else if (elementType == XCUIElementTypeTouchBar) {
    return gtx::ElementType::TOUCH_BAR;
  } else if (elementType == XCUIElementTypeStatusItem) {
    return gtx::ElementType::STATUS_ITEM;
  }
  NSAssert(NO, @"Invalid XCUIElementType: %lu", (unsigned long)elementType);
  return gtx::ElementType::ANY;
}

@end
