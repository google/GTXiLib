//
// Copyright 2018 Google Inc.
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

#import "GTXTestCustomTraitElement.h"

@implementation GTXTestCustomTraitElement

- (void)drawRect:(CGRect)rect {
  // Render the "X" into the element bounds.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
  CGContextFillRect(context, rect);
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
  CGContextStrokeRect(context, rect);
  [@"X" drawInRect:rect
      withAttributes:@{
        NSForegroundColorAttributeName : [UIColor redColor],
        NSFontAttributeName : [UIFont systemFontOfSize:35]
      }];
}

- (void)addCustomTrait:(UIAccessibilityTraits)newTrait {
  self.accessibilityTraits |= newTrait;
}

@end
