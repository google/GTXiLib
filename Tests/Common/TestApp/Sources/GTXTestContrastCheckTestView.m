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

#import "GTXTestContrastCheckTestView.h"

@implementation GTXTestContrastCheckTestView {
  GTXTestContrastCheckTestViewRenderBlock _renderBlock;
}

- (instancetype)initWithFrame:(CGRect)frame
                  renderBlock:(GTXTestContrastCheckTestViewRenderBlock)renderBlock {
  self = [super initWithFrame:frame];
  if (self) {
    _renderBlock = renderBlock;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef contextRef = UIGraphicsGetCurrentContext();
  _renderBlock(self, contextRef);
}

@end
