#include <map>
#include <string>
#include <stdlib.h>
#include <vector>

#include "enums.pb.h"
#include "gtx.pb.h"
namespace gtxilib {
namespace oopclasses {
namespace protos {


float Point::x() const {
  return x_;
}
bool Point::has_x() const {
  return has_x_;
}
void Point::clear_x() {
  x_ = float();
  has_x_ = false;
}
void Point::set_x(float new_x) {
  x_ = new_x;
  has_x_ = true;
}
float* Point::mutable_x() {
  has_x_ = true;
  return &x_;
}

float Point::y() const {
  return y_;
}
bool Point::has_y() const {
  return has_y_;
}
void Point::clear_y() {
  y_ = float();
  has_y_ = false;
}
void Point::set_y(float new_y) {
  y_ = new_y;
  has_y_ = true;
}
float* Point::mutable_y() {
  has_y_ = true;
  return &y_;
}


float Size::width() const {
  return width_;
}
bool Size::has_width() const {
  return has_width_;
}
void Size::clear_width() {
  width_ = float();
  has_width_ = false;
}
void Size::set_width(float new_width) {
  width_ = new_width;
  has_width_ = true;
}
float* Size::mutable_width() {
  has_width_ = true;
  return &width_;
}

float Size::height() const {
  return height_;
}
bool Size::has_height() const {
  return has_height_;
}
void Size::clear_height() {
  height_ = float();
  has_height_ = false;
}
void Size::set_height(float new_height) {
  height_ = new_height;
  has_height_ = true;
}
float* Size::mutable_height() {
  has_height_ = true;
  return &height_;
}


const Point& Rect::origin() const {
  return origin_;
}
bool Rect::has_origin() const {
  return has_origin_;
}
void Rect::clear_origin() {
  origin_ = Point();
  has_origin_ = false;
}
void Rect::set_origin(const Point& new_origin) {
  origin_ = new_origin;
  has_origin_ = true;
}
Point* Rect::mutable_origin() {
  has_origin_ = true;
  return &origin_;
}

const Size& Rect::size() const {
  return size_;
}
bool Rect::has_size() const {
  return has_size_;
}
void Rect::clear_size() {
  size_ = Size();
  has_size_ = false;
}
void Rect::set_size(const Size& new_size) {
  size_ = new_size;
  has_size_ = true;
}
Size* Rect::mutable_size() {
  has_size_ = true;
  return &size_;
}


float Color::r() const {
  return r_;
}
bool Color::has_r() const {
  return has_r_;
}
void Color::clear_r() {
  r_ = float();
  has_r_ = false;
}
void Color::set_r(float new_r) {
  r_ = new_r;
  has_r_ = true;
}
float* Color::mutable_r() {
  has_r_ = true;
  return &r_;
}

float Color::g() const {
  return g_;
}
bool Color::has_g() const {
  return has_g_;
}
void Color::clear_g() {
  g_ = float();
  has_g_ = false;
}
void Color::set_g(float new_g) {
  g_ = new_g;
  has_g_ = true;
}
float* Color::mutable_g() {
  has_g_ = true;
  return &g_;
}

float Color::b() const {
  return b_;
}
bool Color::has_b() const {
  return has_b_;
}
void Color::clear_b() {
  b_ = float();
  has_b_ = false;
}
void Color::set_b(float new_b) {
  b_ = new_b;
  has_b_ = true;
}
float* Color::mutable_b() {
  has_b_ = true;
  return &b_;
}

float Color::a() const {
  return a_;
}
bool Color::has_a() const {
  return has_a_;
}
void Color::clear_a() {
  a_ = float();
  has_a_ = false;
}
void Color::set_a(float new_a) {
  a_ = new_a;
  has_a_ = true;
}
float* Color::mutable_a() {
  has_a_ = true;
  return &a_;
}


int32_t UIElement::id() const {
  return id_;
}
bool UIElement::has_id() const {
  return has_id_;
}
void UIElement::clear_id() {
  id_ = int32_t();
  has_id_ = false;
}
void UIElement::set_id(int32_t new_id) {
  id_ = new_id;
  has_id_ = true;
}
int32_t* UIElement::mutable_id() {
  has_id_ = true;
  return &id_;
}

int32_t UIElement::parent_id() const {
  return parent_id_;
}
bool UIElement::has_parent_id() const {
  return has_parent_id_;
}
void UIElement::clear_parent_id() {
  parent_id_ = int32_t();
  has_parent_id_ = false;
}
void UIElement::set_parent_id(int32_t new_parent_id) {
  parent_id_ = new_parent_id;
  has_parent_id_ = true;
}
int32_t* UIElement::mutable_parent_id() {
  has_parent_id_ = true;
  return &parent_id_;
}

int32_t UIElement::child_ids(int index) const {
  return child_ids_[index];
}
const std::vector<int32_t>& UIElement::child_ids() const {
  return child_ids_;
}
bool UIElement::has_child_ids() const {
  return has_child_ids_;
}
void UIElement::clear_child_ids() {
  child_ids_.clear();
  has_child_ids_ = false;
}
void UIElement::set_child_ids(int index, int32_t new_child_ids) {
  child_ids_[index] = new_child_ids;
  has_child_ids_ = true;
}
int32_t* UIElement::mutable_child_ids(int index) {
  has_child_ids_ = true;
  return &child_ids_[index];
}
void UIElement::add_child_ids(int32_t new_child_ids) {
  child_ids_.push_back(new_child_ids);
  has_child_ids_ = true;
}
int UIElement::child_ids_size() const {
  return child_ids_.size();
}

bool UIElement::is_ax_element() const {
  return is_ax_element_;
}
bool UIElement::has_is_ax_element() const {
  return has_is_ax_element_;
}
void UIElement::clear_is_ax_element() {
  is_ax_element_ = bool();
  has_is_ax_element_ = false;
}
void UIElement::set_is_ax_element(bool new_is_ax_element) {
  is_ax_element_ = new_is_ax_element;
  has_is_ax_element_ = true;
}
bool* UIElement::mutable_is_ax_element() {
  has_is_ax_element_ = true;
  return &is_ax_element_;
}

uint64_t UIElement::ax_traits() const {
  return ax_traits_;
}
bool UIElement::has_ax_traits() const {
  return has_ax_traits_;
}
void UIElement::clear_ax_traits() {
  ax_traits_ = uint64_t();
  has_ax_traits_ = false;
}
void UIElement::set_ax_traits(uint64_t new_ax_traits) {
  ax_traits_ = new_ax_traits;
  has_ax_traits_ = true;
}
uint64_t* UIElement::mutable_ax_traits() {
  has_ax_traits_ = true;
  return &ax_traits_;
}

std::string UIElement::ax_label() const {
  return ax_label_;
}
bool UIElement::has_ax_label() const {
  return has_ax_label_;
}
void UIElement::clear_ax_label() {
  ax_label_ = std::string();
  has_ax_label_ = false;
}
void UIElement::set_ax_label(std::string new_ax_label) {
  ax_label_ = new_ax_label;
  has_ax_label_ = true;
}
std::string* UIElement::mutable_ax_label() {
  has_ax_label_ = true;
  return &ax_label_;
}

std::string UIElement::ax_hint() const {
  return ax_hint_;
}
bool UIElement::has_ax_hint() const {
  return has_ax_hint_;
}
void UIElement::clear_ax_hint() {
  ax_hint_ = std::string();
  has_ax_hint_ = false;
}
void UIElement::set_ax_hint(std::string new_ax_hint) {
  ax_hint_ = new_ax_hint;
  has_ax_hint_ = true;
}
std::string* UIElement::mutable_ax_hint() {
  has_ax_hint_ = true;
  return &ax_hint_;
}

const Rect& UIElement::ax_frame() const {
  return ax_frame_;
}
bool UIElement::has_ax_frame() const {
  return has_ax_frame_;
}
void UIElement::clear_ax_frame() {
  ax_frame_ = Rect();
  has_ax_frame_ = false;
}
void UIElement::set_ax_frame(const Rect& new_ax_frame) {
  ax_frame_ = new_ax_frame;
  has_ax_frame_ = true;
}
Rect* UIElement::mutable_ax_frame() {
  has_ax_frame_ = true;
  return &ax_frame_;
}

std::string UIElement::ax_identifier() const {
  return ax_identifier_;
}
bool UIElement::has_ax_identifier() const {
  return has_ax_identifier_;
}
void UIElement::clear_ax_identifier() {
  ax_identifier_ = std::string();
  has_ax_identifier_ = false;
}
void UIElement::set_ax_identifier(std::string new_ax_identifier) {
  ax_identifier_ = new_ax_identifier;
  has_ax_identifier_ = true;
}
std::string* UIElement::mutable_ax_identifier() {
  has_ax_identifier_ = true;
  return &ax_identifier_;
}

bool UIElement::hittable() const {
  return hittable_;
}
bool UIElement::has_hittable() const {
  return has_hittable_;
}
void UIElement::clear_hittable() {
  hittable_ = bool();
  has_hittable_ = false;
}
void UIElement::set_hittable(bool new_hittable) {
  hittable_ = new_hittable;
  has_hittable_ = true;
}
bool* UIElement::mutable_hittable() {
  has_hittable_ = true;
  return &hittable_;
}

bool UIElement::exists() const {
  return exists_;
}
bool UIElement::has_exists() const {
  return has_exists_;
}
void UIElement::clear_exists() {
  exists_ = bool();
  has_exists_ = false;
}
void UIElement::set_exists(bool new_exists) {
  exists_ = new_exists;
  has_exists_ = true;
}
bool* UIElement::mutable_exists() {
  has_exists_ = true;
  return &exists_;
}

bool UIElement::xc_selected() const {
  return xc_selected_;
}
bool UIElement::has_xc_selected() const {
  return has_xc_selected_;
}
void UIElement::clear_xc_selected() {
  xc_selected_ = bool();
  has_xc_selected_ = false;
}
void UIElement::set_xc_selected(bool new_xc_selected) {
  xc_selected_ = new_xc_selected;
  has_xc_selected_ = true;
}
bool* UIElement::mutable_xc_selected() {
  has_xc_selected_ = true;
  return &xc_selected_;
}

bool UIElement::xc_enabled() const {
  return xc_enabled_;
}
bool UIElement::has_xc_enabled() const {
  return has_xc_enabled_;
}
void UIElement::clear_xc_enabled() {
  xc_enabled_ = bool();
  has_xc_enabled_ = false;
}
void UIElement::set_xc_enabled(bool new_xc_enabled) {
  xc_enabled_ = new_xc_enabled;
  has_xc_enabled_ = true;
}
bool* UIElement::mutable_xc_enabled() {
  has_xc_enabled_ = true;
  return &xc_enabled_;
}

ElementType_ElementTypeEnum UIElement::element_type() const {
  return element_type_;
}
bool UIElement::has_element_type() const {
  return has_element_type_;
}
void UIElement::clear_element_type() {
  element_type_ = ElementType_ElementTypeEnum();
  has_element_type_ = false;
}
void UIElement::set_element_type(ElementType_ElementTypeEnum new_element_type) {
  element_type_ = new_element_type;
  has_element_type_ = true;
}
ElementType_ElementTypeEnum* UIElement::mutable_element_type() {
  has_element_type_ = true;
  return &element_type_;
}

std::string UIElement::class_names_hierarchy(int index) const {
  return class_names_hierarchy_[index];
}
const std::vector<std::string>& UIElement::class_names_hierarchy() const {
  return class_names_hierarchy_;
}
bool UIElement::has_class_names_hierarchy() const {
  return has_class_names_hierarchy_;
}
void UIElement::clear_class_names_hierarchy() {
  class_names_hierarchy_.clear();
  has_class_names_hierarchy_ = false;
}
void UIElement::set_class_names_hierarchy(int index, std::string new_class_names_hierarchy) {
  class_names_hierarchy_[index] = new_class_names_hierarchy;
  has_class_names_hierarchy_ = true;
}
std::string* UIElement::mutable_class_names_hierarchy(int index) {
  has_class_names_hierarchy_ = true;
  return &class_names_hierarchy_[index];
}
void UIElement::add_class_names_hierarchy(std::string new_class_names_hierarchy) {
  class_names_hierarchy_.push_back(new_class_names_hierarchy);
  has_class_names_hierarchy_ = true;
}
int UIElement::class_names_hierarchy_size() const {
  return class_names_hierarchy_.size();
}

const Color& UIElement::background_color() const {
  return background_color_;
}
bool UIElement::has_background_color() const {
  return has_background_color_;
}
void UIElement::clear_background_color() {
  background_color_ = Color();
  has_background_color_ = false;
}
void UIElement::set_background_color(const Color& new_background_color) {
  background_color_ = new_background_color;
  has_background_color_ = true;
}
Color* UIElement::mutable_background_color() {
  has_background_color_ = true;
  return &background_color_;
}

bool UIElement::hidden() const {
  return hidden_;
}
bool UIElement::has_hidden() const {
  return has_hidden_;
}
void UIElement::clear_hidden() {
  hidden_ = bool();
  has_hidden_ = false;
}
void UIElement::set_hidden(bool new_hidden) {
  hidden_ = new_hidden;
  has_hidden_ = true;
}
bool* UIElement::mutable_hidden() {
  has_hidden_ = true;
  return &hidden_;
}

float UIElement::alpha() const {
  return alpha_;
}
bool UIElement::has_alpha() const {
  return has_alpha_;
}
void UIElement::clear_alpha() {
  alpha_ = float();
  has_alpha_ = false;
}
void UIElement::set_alpha(float new_alpha) {
  alpha_ = new_alpha;
  has_alpha_ = true;
}
float* UIElement::mutable_alpha() {
  has_alpha_ = true;
  return &alpha_;
}

bool UIElement::opaque() const {
  return opaque_;
}
bool UIElement::has_opaque() const {
  return has_opaque_;
}
void UIElement::clear_opaque() {
  opaque_ = bool();
  has_opaque_ = false;
}
void UIElement::set_opaque(bool new_opaque) {
  opaque_ = new_opaque;
  has_opaque_ = true;
}
bool* UIElement::mutable_opaque() {
  has_opaque_ = true;
  return &opaque_;
}

const Color& UIElement::tint_color() const {
  return tint_color_;
}
bool UIElement::has_tint_color() const {
  return has_tint_color_;
}
void UIElement::clear_tint_color() {
  tint_color_ = Color();
  has_tint_color_ = false;
}
void UIElement::set_tint_color(const Color& new_tint_color) {
  tint_color_ = new_tint_color;
  has_tint_color_ = true;
}
Color* UIElement::mutable_tint_color() {
  has_tint_color_ = true;
  return &tint_color_;
}

bool UIElement::clips_to_bounds() const {
  return clips_to_bounds_;
}
bool UIElement::has_clips_to_bounds() const {
  return has_clips_to_bounds_;
}
void UIElement::clear_clips_to_bounds() {
  clips_to_bounds_ = bool();
  has_clips_to_bounds_ = false;
}
void UIElement::set_clips_to_bounds(bool new_clips_to_bounds) {
  clips_to_bounds_ = new_clips_to_bounds;
  has_clips_to_bounds_ = true;
}
bool* UIElement::mutable_clips_to_bounds() {
  has_clips_to_bounds_ = true;
  return &clips_to_bounds_;
}

bool UIElement::user_interaction_enabled() const {
  return user_interaction_enabled_;
}
bool UIElement::has_user_interaction_enabled() const {
  return has_user_interaction_enabled_;
}
void UIElement::clear_user_interaction_enabled() {
  user_interaction_enabled_ = bool();
  has_user_interaction_enabled_ = false;
}
void UIElement::set_user_interaction_enabled(bool new_user_interaction_enabled) {
  user_interaction_enabled_ = new_user_interaction_enabled;
  has_user_interaction_enabled_ = true;
}
bool* UIElement::mutable_user_interaction_enabled() {
  has_user_interaction_enabled_ = true;
  return &user_interaction_enabled_;
}

bool UIElement::multiple_touch_enabled() const {
  return multiple_touch_enabled_;
}
bool UIElement::has_multiple_touch_enabled() const {
  return has_multiple_touch_enabled_;
}
void UIElement::clear_multiple_touch_enabled() {
  multiple_touch_enabled_ = bool();
  has_multiple_touch_enabled_ = false;
}
void UIElement::set_multiple_touch_enabled(bool new_multiple_touch_enabled) {
  multiple_touch_enabled_ = new_multiple_touch_enabled;
  has_multiple_touch_enabled_ = true;
}
bool* UIElement::mutable_multiple_touch_enabled() {
  has_multiple_touch_enabled_ = true;
  return &multiple_touch_enabled_;
}

bool UIElement::exclusive_touch() const {
  return exclusive_touch_;
}
bool UIElement::has_exclusive_touch() const {
  return has_exclusive_touch_;
}
void UIElement::clear_exclusive_touch() {
  exclusive_touch_ = bool();
  has_exclusive_touch_ = false;
}
void UIElement::set_exclusive_touch(bool new_exclusive_touch) {
  exclusive_touch_ = new_exclusive_touch;
  has_exclusive_touch_ = true;
}
bool* UIElement::mutable_exclusive_touch() {
  has_exclusive_touch_ = true;
  return &exclusive_touch_;
}

const Rect& UIElement::frame() const {
  return frame_;
}
bool UIElement::has_frame() const {
  return has_frame_;
}
void UIElement::clear_frame() {
  frame_ = Rect();
  has_frame_ = false;
}
void UIElement::set_frame(const Rect& new_frame) {
  frame_ = new_frame;
  has_frame_ = true;
}
Rect* UIElement::mutable_frame() {
  has_frame_ = true;
  return &frame_;
}

const Rect& UIElement::bounds() const {
  return bounds_;
}
bool UIElement::has_bounds() const {
  return has_bounds_;
}
void UIElement::clear_bounds() {
  bounds_ = Rect();
  has_bounds_ = false;
}
void UIElement::set_bounds(const Rect& new_bounds) {
  bounds_ = new_bounds;
  has_bounds_ = true;
}
Rect* UIElement::mutable_bounds() {
  has_bounds_ = true;
  return &bounds_;
}

uint64_t UIElement::control_state() const {
  return control_state_;
}
bool UIElement::has_control_state() const {
  return has_control_state_;
}
void UIElement::clear_control_state() {
  control_state_ = uint64_t();
  has_control_state_ = false;
}
void UIElement::set_control_state(uint64_t new_control_state) {
  control_state_ = new_control_state;
  has_control_state_ = true;
}
uint64_t* UIElement::mutable_control_state() {
  has_control_state_ = true;
  return &control_state_;
}

bool UIElement::enabled() const {
  return enabled_;
}
bool UIElement::has_enabled() const {
  return has_enabled_;
}
void UIElement::clear_enabled() {
  enabled_ = bool();
  has_enabled_ = false;
}
void UIElement::set_enabled(bool new_enabled) {
  enabled_ = new_enabled;
  has_enabled_ = true;
}
bool* UIElement::mutable_enabled() {
  has_enabled_ = true;
  return &enabled_;
}

bool UIElement::selected() const {
  return selected_;
}
bool UIElement::has_selected() const {
  return has_selected_;
}
void UIElement::clear_selected() {
  selected_ = bool();
  has_selected_ = false;
}
void UIElement::set_selected(bool new_selected) {
  selected_ = new_selected;
  has_selected_ = true;
}
bool* UIElement::mutable_selected() {
  has_selected_ = true;
  return &selected_;
}

bool UIElement::highlighted() const {
  return highlighted_;
}
bool UIElement::has_highlighted() const {
  return has_highlighted_;
}
void UIElement::clear_highlighted() {
  highlighted_ = bool();
  has_highlighted_ = false;
}
void UIElement::set_highlighted(bool new_highlighted) {
  highlighted_ = new_highlighted;
  has_highlighted_ = true;
}
bool* UIElement::mutable_highlighted() {
  has_highlighted_ = true;
  return &highlighted_;
}

std::string UIElement::title() const {
  return title_;
}
bool UIElement::has_title() const {
  return has_title_;
}
void UIElement::clear_title() {
  title_ = std::string();
  has_title_ = false;
}
void UIElement::set_title(std::string new_title) {
  title_ = new_title;
  has_title_ = true;
}
std::string* UIElement::mutable_title() {
  has_title_ = true;
  return &title_;
}

std::string UIElement::text() const {
  return text_;
}
bool UIElement::has_text() const {
  return has_text_;
}
void UIElement::clear_text() {
  text_ = std::string();
  has_text_ = false;
}
void UIElement::set_text(std::string new_text) {
  text_ = new_text;
  has_text_ = true;
}
std::string* UIElement::mutable_text() {
  has_text_ = true;
  return &text_;
}

bool UIElement::on() const {
  return on_;
}
bool UIElement::has_on() const {
  return has_on_;
}
void UIElement::clear_on() {
  on_ = bool();
  has_on_ = false;
}
void UIElement::set_on(bool new_on) {
  on_ = new_on;
  has_on_ = true;
}
bool* UIElement::mutable_on() {
  has_on_ = true;
  return &on_;
}

float UIElement::value() const {
  return value_;
}
bool UIElement::has_value() const {
  return has_value_;
}
void UIElement::clear_value() {
  value_ = float();
  has_value_ = false;
}
void UIElement::set_value(float new_value) {
  value_ = new_value;
  has_value_ = true;
}
float* UIElement::mutable_value() {
  has_value_ = true;
  return &value_;
}


int32_t DisplayMetrics::screen_width() const {
  return screen_width_;
}
bool DisplayMetrics::has_screen_width() const {
  return has_screen_width_;
}
void DisplayMetrics::clear_screen_width() {
  screen_width_ = int32_t();
  has_screen_width_ = false;
}
void DisplayMetrics::set_screen_width(int32_t new_screen_width) {
  screen_width_ = new_screen_width;
  has_screen_width_ = true;
}
int32_t* DisplayMetrics::mutable_screen_width() {
  has_screen_width_ = true;
  return &screen_width_;
}

int32_t DisplayMetrics::screen_height() const {
  return screen_height_;
}
bool DisplayMetrics::has_screen_height() const {
  return has_screen_height_;
}
void DisplayMetrics::clear_screen_height() {
  screen_height_ = int32_t();
  has_screen_height_ = false;
}
void DisplayMetrics::set_screen_height(int32_t new_screen_height) {
  screen_height_ = new_screen_height;
  has_screen_height_ = true;
}
int32_t* DisplayMetrics::mutable_screen_height() {
  has_screen_height_ = true;
  return &screen_height_;
}

float DisplayMetrics::screen_scale() const {
  return screen_scale_;
}
bool DisplayMetrics::has_screen_scale() const {
  return has_screen_scale_;
}
void DisplayMetrics::clear_screen_scale() {
  screen_scale_ = float();
  has_screen_scale_ = false;
}
void DisplayMetrics::set_screen_scale(float new_screen_scale) {
  screen_scale_ = new_screen_scale;
  has_screen_scale_ = true;
}
float* DisplayMetrics::mutable_screen_scale() {
  has_screen_scale_ = true;
  return &screen_scale_;
}


const DisplayMetrics& DeviceState::display_metrics() const {
  return display_metrics_;
}
bool DeviceState::has_display_metrics() const {
  return has_display_metrics_;
}
void DeviceState::clear_display_metrics() {
  display_metrics_ = DisplayMetrics();
  has_display_metrics_ = false;
}
void DeviceState::set_display_metrics(const DisplayMetrics& new_display_metrics) {
  display_metrics_ = new_display_metrics;
  has_display_metrics_ = true;
}
DisplayMetrics* DeviceState::mutable_display_metrics() {
  has_display_metrics_ = true;
  return &display_metrics_;
}

std::string DeviceState::ios_version() const {
  return ios_version_;
}
bool DeviceState::has_ios_version() const {
  return has_ios_version_;
}
void DeviceState::clear_ios_version() {
  ios_version_ = std::string();
  has_ios_version_ = false;
}
void DeviceState::set_ios_version(std::string new_ios_version) {
  ios_version_ = new_ios_version;
  has_ios_version_ = true;
}
std::string* DeviceState::mutable_ios_version() {
  has_ios_version_ = true;
  return &ios_version_;
}


const DeviceState& AccessibilityHierarchy::device_state() const {
  return device_state_;
}
bool AccessibilityHierarchy::has_device_state() const {
  return has_device_state_;
}
void AccessibilityHierarchy::clear_device_state() {
  device_state_ = DeviceState();
  has_device_state_ = false;
}
void AccessibilityHierarchy::set_device_state(const DeviceState& new_device_state) {
  device_state_ = new_device_state;
  has_device_state_ = true;
}
DeviceState* AccessibilityHierarchy::mutable_device_state() {
  has_device_state_ = true;
  return &device_state_;
}

const UIElement& AccessibilityHierarchy::elements(int index) const {
  return elements_[index];
}
const std::vector<UIElement>& AccessibilityHierarchy::elements() const {
  return elements_;
}
bool AccessibilityHierarchy::has_elements() const {
  return has_elements_;
}
void AccessibilityHierarchy::clear_elements() {
  elements_.clear();
  has_elements_ = false;
}
void AccessibilityHierarchy::set_elements(int index, const UIElement& new_elements) {
  elements_[index] = new_elements;
  has_elements_ = true;
}
UIElement* AccessibilityHierarchy::mutable_elements(int index) {
  has_elements_ = true;
  return &elements_[index];
}
UIElement* AccessibilityHierarchy::add_elements() {
  elements_.emplace_back();
  has_elements_ = true;
  return &elements_.back();
}
int AccessibilityHierarchy::elements_size() const {
  return elements_.size();
}

}  // GTXiLib
}  // OOPClasses
}  // Protos
