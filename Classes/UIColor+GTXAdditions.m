#import "UIColor+GTXAdditions.h"

@implementation UIColor (GTXAdditions)

- (NSString *)gtx_description {
  CGFloat redValue, greenValue, blueValue;
  [self getRed:&redValue green:&greenValue blue:&blueValue alpha:NULL];

  // Get the RGB values in [0, 255] range as well.
  NSInteger red = (NSInteger)(redValue * 255.0);
  NSInteger green = (NSInteger)(greenValue * 255.0);
  NSInteger blue = (NSInteger)(blueValue * 255.0);
  return
      [NSString stringWithFormat:@"RGB #%02X%02X%02X (%f, %f, %f)", (int)red, (int)green, (int)blue,
                                 (float)redValue, (float)greenValue, (float)blueValue];
}

@end
