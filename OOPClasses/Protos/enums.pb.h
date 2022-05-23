#ifndef THIRD_PARTY_OBJECTIVE_C_GTXILIB_OOPCLASSES_PROTOS_ENUMS_PB_H
#define THIRD_PARTY_OBJECTIVE_C_GTXILIB_OOPCLASSES_PROTOS_ENUMS_PB_H

#include <map>
#include <string>
#include <stdlib.h>
#include <vector>

namespace gtxilib {
namespace oopclasses {
namespace protos {

enum ResultType : int {
  RESULT_TYPE_UNKNOWN = 0,
  RESULT_TYPE_ERROR = 1,
  RESULT_TYPE_WARNING = 2,
  RESULT_TYPE_INFO = 3,
};


enum ElementType_ElementTypeEnum : int {
  ElementType_ElementTypeEnum_ANY = 0,
  ElementType_ElementTypeEnum_OTHER = 1,
  ElementType_ElementTypeEnum_APPLICATION = 2,
  ElementType_ElementTypeEnum_GROUP = 3,
  ElementType_ElementTypeEnum_WINDOW = 4,
  ElementType_ElementTypeEnum_SHEET = 5,
  ElementType_ElementTypeEnum_DRAWER = 6,
  ElementType_ElementTypeEnum_ALERT = 7,
  ElementType_ElementTypeEnum_DIALOG = 8,
  ElementType_ElementTypeEnum_BUTTON = 9,
  ElementType_ElementTypeEnum_RADIO_BUTTON = 10,
  ElementType_ElementTypeEnum_RADIO_GROUP = 11,
  ElementType_ElementTypeEnum_CHECK_BOX = 12,
  ElementType_ElementTypeEnum_DISCLOSURE_TRIANGLE = 13,
  ElementType_ElementTypeEnum_POP_UP_BUTTON = 14,
  ElementType_ElementTypeEnum_COMBO_BOX = 15,
  ElementType_ElementTypeEnum_MENU_BUTTON = 16,
  ElementType_ElementTypeEnum_TOOLBAR_BUTTON = 17,
  ElementType_ElementTypeEnum_POPOVER = 18,
  ElementType_ElementTypeEnum_KEYBOARD = 19,
  ElementType_ElementTypeEnum_KEY = 20,
  ElementType_ElementTypeEnum_NAVIGATION_BAR = 21,
  ElementType_ElementTypeEnum_TAB_BAR = 22,
  ElementType_ElementTypeEnum_TAB_GROUP = 23,
  ElementType_ElementTypeEnum_TOOLBAR = 24,
  ElementType_ElementTypeEnum_STATUS_BAR = 25,
  ElementType_ElementTypeEnum_TABLE = 26,
  ElementType_ElementTypeEnum_TABLE_ROW = 27,
  ElementType_ElementTypeEnum_TABLE_COLUMN = 28,
  ElementType_ElementTypeEnum_OUTLINE = 29,
  ElementType_ElementTypeEnum_OUTLINE_ROW = 30,
  ElementType_ElementTypeEnum_BROWSER = 31,
  ElementType_ElementTypeEnum_COLLECTION_VIEW = 32,
  ElementType_ElementTypeEnum_SLIDER = 33,
  ElementType_ElementTypeEnum_PAGE_INDICATOR = 34,
  ElementType_ElementTypeEnum_PROGRESS_INDICATOR = 35,
  ElementType_ElementTypeEnum_ACTIVITY_INDICATOR = 36,
  ElementType_ElementTypeEnum_SEGMENTED_CONTROL = 37,
  ElementType_ElementTypeEnum_PICKER = 38,
  ElementType_ElementTypeEnum_PICKER_WHEEL = 39,
  ElementType_ElementTypeEnum_SWITCH = 40,
  ElementType_ElementTypeEnum_TOGGLE = 41,
  ElementType_ElementTypeEnum_LINK = 42,
  ElementType_ElementTypeEnum_IMAGE = 43,
  ElementType_ElementTypeEnum_ICON = 44,
  ElementType_ElementTypeEnum_SEARCH_FIELD = 45,
  ElementType_ElementTypeEnum_SCROLL_VIEW = 46,
  ElementType_ElementTypeEnum_SCROLL_BAR = 47,
  ElementType_ElementTypeEnum_STATIC_TEXT = 48,
  ElementType_ElementTypeEnum_TEXT_FIELD = 49,
  ElementType_ElementTypeEnum_SECURE_TEXT_FIELD = 50,
  ElementType_ElementTypeEnum_DATE_PICKER = 51,
  ElementType_ElementTypeEnum_TEXT_VIEW = 52,
  ElementType_ElementTypeEnum_MENU = 53,
  ElementType_ElementTypeEnum_MENU_ITEM = 54,
  ElementType_ElementTypeEnum_MENU_BAR = 55,
  ElementType_ElementTypeEnum_MENU_BAR_ITEM = 56,
  ElementType_ElementTypeEnum_MAP = 57,
  ElementType_ElementTypeEnum_WEB_VIEW = 58,
  ElementType_ElementTypeEnum_INCREMENT_ARROW = 59,
  ElementType_ElementTypeEnum_DECREMENT_ARROW = 60,
  ElementType_ElementTypeEnum_TIMELINE = 61,
  ElementType_ElementTypeEnum_RATING_INDICATOR = 62,
  ElementType_ElementTypeEnum_VALUE_INDICATOR = 63,
  ElementType_ElementTypeEnum_SPLIT_GROUP = 64,
  ElementType_ElementTypeEnum_SPLITTER = 65,
  ElementType_ElementTypeEnum_RELEVANCE_INDICATOR = 66,
  ElementType_ElementTypeEnum_COLOR_WELL = 67,
  ElementType_ElementTypeEnum_HELP_TAG = 68,
  ElementType_ElementTypeEnum_MATTE = 69,
  ElementType_ElementTypeEnum_DOCK_ITEM = 70,
  ElementType_ElementTypeEnum_RULER = 71,
  ElementType_ElementTypeEnum_RULER_MARKER = 72,
  ElementType_ElementTypeEnum_GRID = 73,
  ElementType_ElementTypeEnum_LEVEL_INDICATOR = 74,
  ElementType_ElementTypeEnum_CELL = 75,
  ElementType_ElementTypeEnum_LAYOUT_AREA = 76,
  ElementType_ElementTypeEnum_LAYOUT_ITEM = 77,
  ElementType_ElementTypeEnum_HANDLE = 78,
  ElementType_ElementTypeEnum_STEPPER = 79,
  ElementType_ElementTypeEnum_TAB = 80,
  ElementType_ElementTypeEnum_TOUCH_BAR = 81,
  ElementType_ElementTypeEnum_STATUS_ITEM = 82,
};

class ElementType {

public:

  typedef ElementType_ElementTypeEnum ElementTypeEnum;
  static constexpr ElementType_ElementTypeEnum ANY = ElementType_ElementTypeEnum_ANY;
  static constexpr ElementType_ElementTypeEnum OTHER = ElementType_ElementTypeEnum_OTHER;
  static constexpr ElementType_ElementTypeEnum APPLICATION = ElementType_ElementTypeEnum_APPLICATION;
  static constexpr ElementType_ElementTypeEnum GROUP = ElementType_ElementTypeEnum_GROUP;
  static constexpr ElementType_ElementTypeEnum WINDOW = ElementType_ElementTypeEnum_WINDOW;
  static constexpr ElementType_ElementTypeEnum SHEET = ElementType_ElementTypeEnum_SHEET;
  static constexpr ElementType_ElementTypeEnum DRAWER = ElementType_ElementTypeEnum_DRAWER;
  static constexpr ElementType_ElementTypeEnum ALERT = ElementType_ElementTypeEnum_ALERT;
  static constexpr ElementType_ElementTypeEnum DIALOG = ElementType_ElementTypeEnum_DIALOG;
  static constexpr ElementType_ElementTypeEnum BUTTON = ElementType_ElementTypeEnum_BUTTON;
  static constexpr ElementType_ElementTypeEnum RADIO_BUTTON = ElementType_ElementTypeEnum_RADIO_BUTTON;
  static constexpr ElementType_ElementTypeEnum RADIO_GROUP = ElementType_ElementTypeEnum_RADIO_GROUP;
  static constexpr ElementType_ElementTypeEnum CHECK_BOX = ElementType_ElementTypeEnum_CHECK_BOX;
  static constexpr ElementType_ElementTypeEnum DISCLOSURE_TRIANGLE = ElementType_ElementTypeEnum_DISCLOSURE_TRIANGLE;
  static constexpr ElementType_ElementTypeEnum POP_UP_BUTTON = ElementType_ElementTypeEnum_POP_UP_BUTTON;
  static constexpr ElementType_ElementTypeEnum COMBO_BOX = ElementType_ElementTypeEnum_COMBO_BOX;
  static constexpr ElementType_ElementTypeEnum MENU_BUTTON = ElementType_ElementTypeEnum_MENU_BUTTON;
  static constexpr ElementType_ElementTypeEnum TOOLBAR_BUTTON = ElementType_ElementTypeEnum_TOOLBAR_BUTTON;
  static constexpr ElementType_ElementTypeEnum POPOVER = ElementType_ElementTypeEnum_POPOVER;
  static constexpr ElementType_ElementTypeEnum KEYBOARD = ElementType_ElementTypeEnum_KEYBOARD;
  static constexpr ElementType_ElementTypeEnum KEY = ElementType_ElementTypeEnum_KEY;
  static constexpr ElementType_ElementTypeEnum NAVIGATION_BAR = ElementType_ElementTypeEnum_NAVIGATION_BAR;
  static constexpr ElementType_ElementTypeEnum TAB_BAR = ElementType_ElementTypeEnum_TAB_BAR;
  static constexpr ElementType_ElementTypeEnum TAB_GROUP = ElementType_ElementTypeEnum_TAB_GROUP;
  static constexpr ElementType_ElementTypeEnum TOOLBAR = ElementType_ElementTypeEnum_TOOLBAR;
  static constexpr ElementType_ElementTypeEnum STATUS_BAR = ElementType_ElementTypeEnum_STATUS_BAR;
  static constexpr ElementType_ElementTypeEnum TABLE = ElementType_ElementTypeEnum_TABLE;
  static constexpr ElementType_ElementTypeEnum TABLE_ROW = ElementType_ElementTypeEnum_TABLE_ROW;
  static constexpr ElementType_ElementTypeEnum TABLE_COLUMN = ElementType_ElementTypeEnum_TABLE_COLUMN;
  static constexpr ElementType_ElementTypeEnum OUTLINE = ElementType_ElementTypeEnum_OUTLINE;
  static constexpr ElementType_ElementTypeEnum OUTLINE_ROW = ElementType_ElementTypeEnum_OUTLINE_ROW;
  static constexpr ElementType_ElementTypeEnum BROWSER = ElementType_ElementTypeEnum_BROWSER;
  static constexpr ElementType_ElementTypeEnum COLLECTION_VIEW = ElementType_ElementTypeEnum_COLLECTION_VIEW;
  static constexpr ElementType_ElementTypeEnum SLIDER = ElementType_ElementTypeEnum_SLIDER;
  static constexpr ElementType_ElementTypeEnum PAGE_INDICATOR = ElementType_ElementTypeEnum_PAGE_INDICATOR;
  static constexpr ElementType_ElementTypeEnum PROGRESS_INDICATOR = ElementType_ElementTypeEnum_PROGRESS_INDICATOR;
  static constexpr ElementType_ElementTypeEnum ACTIVITY_INDICATOR = ElementType_ElementTypeEnum_ACTIVITY_INDICATOR;
  static constexpr ElementType_ElementTypeEnum SEGMENTED_CONTROL = ElementType_ElementTypeEnum_SEGMENTED_CONTROL;
  static constexpr ElementType_ElementTypeEnum PICKER = ElementType_ElementTypeEnum_PICKER;
  static constexpr ElementType_ElementTypeEnum PICKER_WHEEL = ElementType_ElementTypeEnum_PICKER_WHEEL;
  static constexpr ElementType_ElementTypeEnum SWITCH = ElementType_ElementTypeEnum_SWITCH;
  static constexpr ElementType_ElementTypeEnum TOGGLE = ElementType_ElementTypeEnum_TOGGLE;
  static constexpr ElementType_ElementTypeEnum LINK = ElementType_ElementTypeEnum_LINK;
  static constexpr ElementType_ElementTypeEnum IMAGE = ElementType_ElementTypeEnum_IMAGE;
  static constexpr ElementType_ElementTypeEnum ICON = ElementType_ElementTypeEnum_ICON;
  static constexpr ElementType_ElementTypeEnum SEARCH_FIELD = ElementType_ElementTypeEnum_SEARCH_FIELD;
  static constexpr ElementType_ElementTypeEnum SCROLL_VIEW = ElementType_ElementTypeEnum_SCROLL_VIEW;
  static constexpr ElementType_ElementTypeEnum SCROLL_BAR = ElementType_ElementTypeEnum_SCROLL_BAR;
  static constexpr ElementType_ElementTypeEnum STATIC_TEXT = ElementType_ElementTypeEnum_STATIC_TEXT;
  static constexpr ElementType_ElementTypeEnum TEXT_FIELD = ElementType_ElementTypeEnum_TEXT_FIELD;
  static constexpr ElementType_ElementTypeEnum SECURE_TEXT_FIELD = ElementType_ElementTypeEnum_SECURE_TEXT_FIELD;
  static constexpr ElementType_ElementTypeEnum DATE_PICKER = ElementType_ElementTypeEnum_DATE_PICKER;
  static constexpr ElementType_ElementTypeEnum TEXT_VIEW = ElementType_ElementTypeEnum_TEXT_VIEW;
  static constexpr ElementType_ElementTypeEnum MENU = ElementType_ElementTypeEnum_MENU;
  static constexpr ElementType_ElementTypeEnum MENU_ITEM = ElementType_ElementTypeEnum_MENU_ITEM;
  static constexpr ElementType_ElementTypeEnum MENU_BAR = ElementType_ElementTypeEnum_MENU_BAR;
  static constexpr ElementType_ElementTypeEnum MENU_BAR_ITEM = ElementType_ElementTypeEnum_MENU_BAR_ITEM;
  static constexpr ElementType_ElementTypeEnum MAP = ElementType_ElementTypeEnum_MAP;
  static constexpr ElementType_ElementTypeEnum WEB_VIEW = ElementType_ElementTypeEnum_WEB_VIEW;
  static constexpr ElementType_ElementTypeEnum INCREMENT_ARROW = ElementType_ElementTypeEnum_INCREMENT_ARROW;
  static constexpr ElementType_ElementTypeEnum DECREMENT_ARROW = ElementType_ElementTypeEnum_DECREMENT_ARROW;
  static constexpr ElementType_ElementTypeEnum TIMELINE = ElementType_ElementTypeEnum_TIMELINE;
  static constexpr ElementType_ElementTypeEnum RATING_INDICATOR = ElementType_ElementTypeEnum_RATING_INDICATOR;
  static constexpr ElementType_ElementTypeEnum VALUE_INDICATOR = ElementType_ElementTypeEnum_VALUE_INDICATOR;
  static constexpr ElementType_ElementTypeEnum SPLIT_GROUP = ElementType_ElementTypeEnum_SPLIT_GROUP;
  static constexpr ElementType_ElementTypeEnum SPLITTER = ElementType_ElementTypeEnum_SPLITTER;
  static constexpr ElementType_ElementTypeEnum RELEVANCE_INDICATOR = ElementType_ElementTypeEnum_RELEVANCE_INDICATOR;
  static constexpr ElementType_ElementTypeEnum COLOR_WELL = ElementType_ElementTypeEnum_COLOR_WELL;
  static constexpr ElementType_ElementTypeEnum HELP_TAG = ElementType_ElementTypeEnum_HELP_TAG;
  static constexpr ElementType_ElementTypeEnum MATTE = ElementType_ElementTypeEnum_MATTE;
  static constexpr ElementType_ElementTypeEnum DOCK_ITEM = ElementType_ElementTypeEnum_DOCK_ITEM;
  static constexpr ElementType_ElementTypeEnum RULER = ElementType_ElementTypeEnum_RULER;
  static constexpr ElementType_ElementTypeEnum RULER_MARKER = ElementType_ElementTypeEnum_RULER_MARKER;
  static constexpr ElementType_ElementTypeEnum GRID = ElementType_ElementTypeEnum_GRID;
  static constexpr ElementType_ElementTypeEnum LEVEL_INDICATOR = ElementType_ElementTypeEnum_LEVEL_INDICATOR;
  static constexpr ElementType_ElementTypeEnum CELL = ElementType_ElementTypeEnum_CELL;
  static constexpr ElementType_ElementTypeEnum LAYOUT_AREA = ElementType_ElementTypeEnum_LAYOUT_AREA;
  static constexpr ElementType_ElementTypeEnum LAYOUT_ITEM = ElementType_ElementTypeEnum_LAYOUT_ITEM;
  static constexpr ElementType_ElementTypeEnum HANDLE = ElementType_ElementTypeEnum_HANDLE;
  static constexpr ElementType_ElementTypeEnum STEPPER = ElementType_ElementTypeEnum_STEPPER;
  static constexpr ElementType_ElementTypeEnum TAB = ElementType_ElementTypeEnum_TAB;
  static constexpr ElementType_ElementTypeEnum TOUCH_BAR = ElementType_ElementTypeEnum_TOUCH_BAR;
  static constexpr ElementType_ElementTypeEnum STATUS_ITEM = ElementType_ElementTypeEnum_STATUS_ITEM;

private:
};

}  // GTXiLib
}  // OOPClasses
}  // Protos

#endif
