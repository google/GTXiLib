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

/**
 Block type that specifies @c GTXTestContrastCheckTestView's render logic.
 */
@class GTXTestContrastCheckTestView;
typedef void (^GTXTestContrastCheckTestViewRenderBlock)(GTXTestContrastCheckTestView *testView,
                                                        CGContextRef contextRef);

/**
 A view implementation for testing contrast checks.
 */
@interface GTXTestContrastCheckTestView : UIView

/**
 Unavailable initializers, use -initWithFrame:renderBlock: instead.
 */
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/**
 Initializes a new @c GTXTestContrastCheckTestView view.

 @param frame The frame for the view.
 @param renderBlock Render logic for the view.
 @return A new @c GTXTestContrastCheckTestView view.
 */
- (instancetype)initWithFrame:(CGRect)frame
                  renderBlock:(GTXTestContrastCheckTestViewRenderBlock)renderBlock;

@end
