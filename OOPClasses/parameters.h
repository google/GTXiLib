#ifndef GTXILIB_OOPCLASSES_PARAMETERS_H_
#define GTXILIB_OOPCLASSES_PARAMETERS_H_

#include "gtx_types.h"

namespace gtx {

// Parameters encapsulates check agnostic data such as screenshot data.
class Parameters {
 public:
  // Creates a new Parameter object.
  Parameters() {}

  // Screenshot of the entire screen.
  const Image& screenshot() const { return screenshot_; }
  void set_screenshot(const Image& screenshot) { screenshot_ = screenshot; }

  // Bounds of the device in points.
  const Rect& device_bounds() const { return device_bounds_; }
  void set_device_bounds(const Rect& device_bounds) {
    device_bounds_ = device_bounds;
  }

  Rect ConvertRectToScreenshotSpace(const Rect& device_space_rect) const;

 private:
  Image screenshot_;
  Rect device_bounds_;
};

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_PARAMETERS_H_
