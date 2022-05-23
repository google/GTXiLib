#ifndef THIRD_PARTY_OBJECTIVE_C_GTXILIB_OOPCLASSES_PROTOS_GTX_PB_H
#define THIRD_PARTY_OBJECTIVE_C_GTXILIB_OOPCLASSES_PROTOS_GTX_PB_H

#include <map>
#include <string>
#include <stdlib.h>
#include <vector>

#include "enums.pb.h"

namespace gtxilib {
namespace oopclasses {
namespace protos {




class Point {

public:


  float x() const;
  bool has_x() const;
  void clear_x();
  void set_x(float new_x);
  float* mutable_x();

  float y() const;
  bool has_y() const;
  void clear_y();
  void set_y(float new_y);
  float* mutable_y();

private:
  float x_ = float();
  bool has_x_ = false;
  float y_ = float();
  bool has_y_ = false;
};


class Size {

public:


  float width() const;
  bool has_width() const;
  void clear_width();
  void set_width(float new_width);
  float* mutable_width();

  float height() const;
  bool has_height() const;
  void clear_height();
  void set_height(float new_height);
  float* mutable_height();

private:
  float width_ = float();
  bool has_width_ = false;
  float height_ = float();
  bool has_height_ = false;
};


class Rect {

public:


  const Point& origin() const;
  bool has_origin() const;
  void clear_origin();
  void set_origin(const Point& new_origin);
  Point* mutable_origin();

  const Size& size() const;
  bool has_size() const;
  void clear_size();
  void set_size(const Size& new_size);
  Size* mutable_size();

private:
  Point origin_ = Point();
  bool has_origin_ = false;
  Size size_ = Size();
  bool has_size_ = false;
};


class Color {

public:


  float r() const;
  bool has_r() const;
  void clear_r();
  void set_r(float new_r);
  float* mutable_r();

  float g() const;
  bool has_g() const;
  void clear_g();
  void set_g(float new_g);
  float* mutable_g();

  float b() const;
  bool has_b() const;
  void clear_b();
  void set_b(float new_b);
  float* mutable_b();

  float a() const;
  bool has_a() const;
  void clear_a();
  void set_a(float new_a);
  float* mutable_a();

private:
  float r_ = float();
  bool has_r_ = false;
  float g_ = float();
  bool has_g_ = false;
  float b_ = float();
  bool has_b_ = false;
  float a_ = float();
  bool has_a_ = false;
};


class UIElement {

public:


  int32_t id() const;
  bool has_id() const;
  void clear_id();
  void set_id(int32_t new_id);
  int32_t* mutable_id();

  int32_t parent_id() const;
  bool has_parent_id() const;
  void clear_parent_id();
  void set_parent_id(int32_t new_parent_id);
  int32_t* mutable_parent_id();

  int32_t child_ids(int index) const;
  const std::vector<int32_t>& child_ids() const;
  bool has_child_ids() const;
  void clear_child_ids();
  void set_child_ids(int index, int32_t new_child_ids);
  int32_t* mutable_child_ids(int index);
  void add_child_ids(int32_t new_child_ids);
  int child_ids_size() const;

  bool is_ax_element() const;
  bool has_is_ax_element() const;
  void clear_is_ax_element();
  void set_is_ax_element(bool new_is_ax_element);
  bool* mutable_is_ax_element();

  uint64_t ax_traits() const;
  bool has_ax_traits() const;
  void clear_ax_traits();
  void set_ax_traits(uint64_t new_ax_traits);
  uint64_t* mutable_ax_traits();

  std::string ax_label() const;
  bool has_ax_label() const;
  void clear_ax_label();
  void set_ax_label(std::string new_ax_label);
  std::string* mutable_ax_label();

  std::string ax_hint() const;
  bool has_ax_hint() const;
  void clear_ax_hint();
  void set_ax_hint(std::string new_ax_hint);
  std::string* mutable_ax_hint();

  const Rect& ax_frame() const;
  bool has_ax_frame() const;
  void clear_ax_frame();
  void set_ax_frame(const Rect& new_ax_frame);
  Rect* mutable_ax_frame();

  std::string ax_identifier() const;
  bool has_ax_identifier() const;
  void clear_ax_identifier();
  void set_ax_identifier(std::string new_ax_identifier);
  std::string* mutable_ax_identifier();

  bool hittable() const;
  bool has_hittable() const;
  void clear_hittable();
  void set_hittable(bool new_hittable);
  bool* mutable_hittable();

  bool exists() const;
  bool has_exists() const;
  void clear_exists();
  void set_exists(bool new_exists);
  bool* mutable_exists();

  bool xc_selected() const;
  bool has_xc_selected() const;
  void clear_xc_selected();
  void set_xc_selected(bool new_xc_selected);
  bool* mutable_xc_selected();

  bool xc_enabled() const;
  bool has_xc_enabled() const;
  void clear_xc_enabled();
  void set_xc_enabled(bool new_xc_enabled);
  bool* mutable_xc_enabled();

  ElementType_ElementTypeEnum element_type() const;
  bool has_element_type() const;
  void clear_element_type();
  void set_element_type(ElementType_ElementTypeEnum new_element_type);
  ElementType_ElementTypeEnum* mutable_element_type();

  std::string class_names_hierarchy(int index) const;
  const std::vector<std::string>& class_names_hierarchy() const;
  bool has_class_names_hierarchy() const;
  void clear_class_names_hierarchy();
  void set_class_names_hierarchy(int index, std::string new_class_names_hierarchy);
  std::string* mutable_class_names_hierarchy(int index);
  void add_class_names_hierarchy(std::string new_class_names_hierarchy);
  int class_names_hierarchy_size() const;

  const Color& background_color() const;
  bool has_background_color() const;
  void clear_background_color();
  void set_background_color(const Color& new_background_color);
  Color* mutable_background_color();

  bool hidden() const;
  bool has_hidden() const;
  void clear_hidden();
  void set_hidden(bool new_hidden);
  bool* mutable_hidden();

  float alpha() const;
  bool has_alpha() const;
  void clear_alpha();
  void set_alpha(float new_alpha);
  float* mutable_alpha();

  bool opaque() const;
  bool has_opaque() const;
  void clear_opaque();
  void set_opaque(bool new_opaque);
  bool* mutable_opaque();

  const Color& tint_color() const;
  bool has_tint_color() const;
  void clear_tint_color();
  void set_tint_color(const Color& new_tint_color);
  Color* mutable_tint_color();

  bool clips_to_bounds() const;
  bool has_clips_to_bounds() const;
  void clear_clips_to_bounds();
  void set_clips_to_bounds(bool new_clips_to_bounds);
  bool* mutable_clips_to_bounds();

  bool user_interaction_enabled() const;
  bool has_user_interaction_enabled() const;
  void clear_user_interaction_enabled();
  void set_user_interaction_enabled(bool new_user_interaction_enabled);
  bool* mutable_user_interaction_enabled();

  bool multiple_touch_enabled() const;
  bool has_multiple_touch_enabled() const;
  void clear_multiple_touch_enabled();
  void set_multiple_touch_enabled(bool new_multiple_touch_enabled);
  bool* mutable_multiple_touch_enabled();

  bool exclusive_touch() const;
  bool has_exclusive_touch() const;
  void clear_exclusive_touch();
  void set_exclusive_touch(bool new_exclusive_touch);
  bool* mutable_exclusive_touch();

  const Rect& frame() const;
  bool has_frame() const;
  void clear_frame();
  void set_frame(const Rect& new_frame);
  Rect* mutable_frame();

  const Rect& bounds() const;
  bool has_bounds() const;
  void clear_bounds();
  void set_bounds(const Rect& new_bounds);
  Rect* mutable_bounds();

  uint64_t control_state() const;
  bool has_control_state() const;
  void clear_control_state();
  void set_control_state(uint64_t new_control_state);
  uint64_t* mutable_control_state();

  bool enabled() const;
  bool has_enabled() const;
  void clear_enabled();
  void set_enabled(bool new_enabled);
  bool* mutable_enabled();

  bool selected() const;
  bool has_selected() const;
  void clear_selected();
  void set_selected(bool new_selected);
  bool* mutable_selected();

  bool highlighted() const;
  bool has_highlighted() const;
  void clear_highlighted();
  void set_highlighted(bool new_highlighted);
  bool* mutable_highlighted();

  std::string title() const;
  bool has_title() const;
  void clear_title();
  void set_title(std::string new_title);
  std::string* mutable_title();

  std::string text() const;
  bool has_text() const;
  void clear_text();
  void set_text(std::string new_text);
  std::string* mutable_text();

  bool on() const;
  bool has_on() const;
  void clear_on();
  void set_on(bool new_on);
  bool* mutable_on();

  float value() const;
  bool has_value() const;
  void clear_value();
  void set_value(float new_value);
  float* mutable_value();

private:
  int32_t id_ = int32_t();
  bool has_id_ = false;
  int32_t parent_id_ = int32_t();
  bool has_parent_id_ = false;
  std::vector<int32_t> child_ids_ = std::vector<int32_t>();
  bool has_child_ids_ = false;
  bool is_ax_element_ = bool();
  bool has_is_ax_element_ = false;
  uint64_t ax_traits_ = uint64_t();
  bool has_ax_traits_ = false;
  std::string ax_label_ = std::string();
  bool has_ax_label_ = false;
  std::string ax_hint_ = std::string();
  bool has_ax_hint_ = false;
  Rect ax_frame_ = Rect();
  bool has_ax_frame_ = false;
  std::string ax_identifier_ = std::string();
  bool has_ax_identifier_ = false;
  bool hittable_ = bool();
  bool has_hittable_ = false;
  bool exists_ = bool();
  bool has_exists_ = false;
  bool xc_selected_ = bool();
  bool has_xc_selected_ = false;
  bool xc_enabled_ = bool();
  bool has_xc_enabled_ = false;
  ElementType_ElementTypeEnum element_type_ = ElementType_ElementTypeEnum();
  bool has_element_type_ = false;
  std::vector<std::string> class_names_hierarchy_ = std::vector<std::string>();
  bool has_class_names_hierarchy_ = false;
  Color background_color_ = Color();
  bool has_background_color_ = false;
  bool hidden_ = bool();
  bool has_hidden_ = false;
  float alpha_ = float();
  bool has_alpha_ = false;
  bool opaque_ = bool();
  bool has_opaque_ = false;
  Color tint_color_ = Color();
  bool has_tint_color_ = false;
  bool clips_to_bounds_ = bool();
  bool has_clips_to_bounds_ = false;
  bool user_interaction_enabled_ = bool();
  bool has_user_interaction_enabled_ = false;
  bool multiple_touch_enabled_ = bool();
  bool has_multiple_touch_enabled_ = false;
  bool exclusive_touch_ = bool();
  bool has_exclusive_touch_ = false;
  Rect frame_ = Rect();
  bool has_frame_ = false;
  Rect bounds_ = Rect();
  bool has_bounds_ = false;
  uint64_t control_state_ = uint64_t();
  bool has_control_state_ = false;
  bool enabled_ = bool();
  bool has_enabled_ = false;
  bool selected_ = bool();
  bool has_selected_ = false;
  bool highlighted_ = bool();
  bool has_highlighted_ = false;
  std::string title_ = std::string();
  bool has_title_ = false;
  std::string text_ = std::string();
  bool has_text_ = false;
  bool on_ = bool();
  bool has_on_ = false;
  float value_ = float();
  bool has_value_ = false;
};


class DisplayMetrics {

public:


  int32_t screen_width() const;
  bool has_screen_width() const;
  void clear_screen_width();
  void set_screen_width(int32_t new_screen_width);
  int32_t* mutable_screen_width();

  int32_t screen_height() const;
  bool has_screen_height() const;
  void clear_screen_height();
  void set_screen_height(int32_t new_screen_height);
  int32_t* mutable_screen_height();

  float screen_scale() const;
  bool has_screen_scale() const;
  void clear_screen_scale();
  void set_screen_scale(float new_screen_scale);
  float* mutable_screen_scale();

private:
  int32_t screen_width_ = int32_t();
  bool has_screen_width_ = false;
  int32_t screen_height_ = int32_t();
  bool has_screen_height_ = false;
  float screen_scale_ = float();
  bool has_screen_scale_ = false;
};


class DeviceState {

public:


  const DisplayMetrics& display_metrics() const;
  bool has_display_metrics() const;
  void clear_display_metrics();
  void set_display_metrics(const DisplayMetrics& new_display_metrics);
  DisplayMetrics* mutable_display_metrics();

  std::string ios_version() const;
  bool has_ios_version() const;
  void clear_ios_version();
  void set_ios_version(std::string new_ios_version);
  std::string* mutable_ios_version();

private:
  DisplayMetrics display_metrics_ = DisplayMetrics();
  bool has_display_metrics_ = false;
  std::string ios_version_ = std::string();
  bool has_ios_version_ = false;
};


class AccessibilityHierarchy {

public:


  const DeviceState& device_state() const;
  bool has_device_state() const;
  void clear_device_state();
  void set_device_state(const DeviceState& new_device_state);
  DeviceState* mutable_device_state();

  const UIElement& elements(int index) const;
  const std::vector<UIElement>& elements() const;
  bool has_elements() const;
  void clear_elements();
  void set_elements(int index, const UIElement& new_elements);
  UIElement* mutable_elements(int index);
  UIElement* add_elements();
  int elements_size() const;

private:
  DeviceState device_state_ = DeviceState();
  bool has_device_state_ = false;
  std::vector<UIElement> elements_ = std::vector<UIElement>();
  bool has_elements_ = false;
};

}  // GTXiLib
}  // OOPClasses
}  // Protos

#endif
