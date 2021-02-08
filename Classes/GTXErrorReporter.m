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

#import "GTXErrorReporter.h"

#import "NSError+GTXAdditions.h"

@implementation GTXErrorReporter

+ (UIImage *)screenshotWithFailingElements:(NSArray *)elements {
  // Render a gray scale screen shot of the app screen. Gray scale allows the element outlines to
  //  be seen clearly.
  UIImage *image = [self gtx_takeScreenshot];
  UIImage *grayScaleScreenShot = [self gtx_grayScaleImageFromImage:image];

  // Outline the locations of elements on the gray scale screenshot.
  UIScreen *mainScreen = [UIScreen mainScreen];
  UIGraphicsBeginImageContextWithOptions(mainScreen.bounds.size, YES, mainScreen.scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  [grayScaleScreenShot drawInRect:mainScreen.bounds];

  for (id element in elements) {
    // Find the element's outline rect that needs to be marked on the screenshot.
    CGRect elementOutline = [element accessibilityFrame];
    if ([element isKindOfClass:[UIView class]]) {
      UIView *view = element;
      elementOutline = [view convertRect:view.bounds toView:nil];
      elementOutline = [[view window] convertRect:elementOutline toWindow:nil];
    }
    // Draw a rectangle indicating the outline.
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokeRect(context, elementOutline);
  }

  // Save the currently rendered image.
  image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (UIImage *)screenshotView:(UIView *)element {
  CGRect rect = CGRectStandardize(element.bounds);
  rect.origin = CGPointZero;
  UIGraphicsBeginImageContext(rect.size);
  [element drawViewHierarchyInRect:rect afterScreenUpdates:NO];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (NSString *)hierarchyDescriptionOfRootElements:(NSArray *)rootElements {
  NSMutableArray *descriptions = [[NSMutableArray alloc] init];
  for (id rootElement in rootElements) {
    [self gtx_getRecursiveHierarchyDescriptionOfRootElement:rootElement
                                                     indent:nil
                                             outDescription:descriptions];
  }
  return [descriptions componentsJoinedByString:@"\n"];
}

#pragma mark - Private

/**
 *  Traverses the view hierarchy starting from the given root @c element and fills @c description
 *  with a list of all elements descriptions.
 *
 *  @param element     The root element to start traversal from.
 *  @param indent      The indent to apply to the root element's description.
 *  @param description A mutable array to be filled with elements descriptions.
 */
+ (void)gtx_getRecursiveHierarchyDescriptionOfRootElement:(id)element
                                                   indent:(NSString *)indent
                                           outDescription:(NSMutableArray *)description {
  indent = indent ? indent : @"";
  NSMutableSet<id> *axChildren = [[NSMutableSet alloc] init];
  NSMutableSet<id> *subviews = [[NSMutableSet alloc] init];
  NSMutableSet<id> *both = [[NSMutableSet alloc] init];
  // Get all a11y children.
  NSArray *elements = [element accessibilityElements];
  NSInteger count = [element accessibilityElementCount];
  if (elements) {
    [axChildren addObjectsFromArray:elements];
  } else if (count > 0 && count != NSNotFound) {
    for (NSInteger i = 0; i < count; i++) {
      [axChildren addObject:[element accessibilityElementAtIndex:i]];
    }
  }

  // Get all subviews
  elements = [element respondsToSelector:@selector(subviews)] ? [element subviews] : nil;
  for (id element in elements) {
    if ([axChildren containsObject:element]) {
      [both addObject:element];
    } else {
      [subviews addObject:element];
    }
  }
  [axChildren minusSet:both];
  [description addObject:[self gtx_hierarchyDescriptionOfSingleElement:element indent:indent]];
  NSString *nextIndent = [indent stringByAppendingString:@" | "];
  if ([both count]) {
    [description addObject:
     [NSString stringWithFormat:@"%@Subviews and accessibility elements(%d):",
         indent,
         (int)[both count]]];
    for (id element in both) {
      [self gtx_getRecursiveHierarchyDescriptionOfRootElement:element
                                                       indent:nextIndent
                                               outDescription:description];
    }
  }
  if ([axChildren count]) {
    [description addObject:[NSString stringWithFormat:@"%@Accessibility elements(%d):",
                                                      indent,
                                                      (int)[axChildren count]]];
    for (id element in axChildren) {
      [self gtx_getRecursiveHierarchyDescriptionOfRootElement:element
                                                       indent:nextIndent
                                               outDescription:description];
    }
  }
  if ([subviews count]) {
    [description addObject:[NSString stringWithFormat:@"%@Subviews(%d):",
                                                      indent,
                                                      (int)[subviews count]]];
    for (id element in subviews) {
      [self gtx_getRecursiveHierarchyDescriptionOfRootElement:element
                                                       indent:nextIndent
                                               outDescription:description];
    }
  }
}

/**
 *  Returns a pretty printed description of various attributes the given element such as class,
 *  a11y attributes etc.
 *
 *  @param element The element whose description is needed.
 *  @param indent  The indent to apply to the root element's description.
 *
 *  @return The description of the given element prepended with the indent.
 */
+ (NSString *)gtx_hierarchyDescriptionOfSingleElement:(id)element indent:(NSString *)indent {
  NSMutableArray<NSString *> *descriptions = [[NSMutableArray alloc] init];
  [descriptions addObject:[NSString stringWithFormat:@"%@<%@:%p",
                                                     indent,
                                                     NSStringFromClass([element class]),
                                                     element]];

  // Adds a key=value pair to the description array.
  void (^AddKeyValue)(NSString *key, NSString *value) = ^(NSString *key, NSString *value) {
    [descriptions addObject:[NSString stringWithFormat:@"%@=%@",
                                                       key,
                                                       value ? value : @"<nil>"]];
  };

  // Add all the attributes needed in the description.
  AddKeyValue(@"AX", [element isAccessibilityElement] ? @"Y": @"N");
  AddKeyValue(@"AXID", [element accessibilityIdentifier]);
  NSString *stringValue = [element accessibilityLabel];
  AddKeyValue(@"AXLabel", stringValue ? [NSString stringWithFormat:@"\"%@\"", stringValue] : nil);
  stringValue = [NSString
      stringWithFormat:@"(UIAccessibilityTrait)%@",
                       [self gtx_stringValueOfUIAccessibilityTraits:[element accessibilityTraits]]];
  AddKeyValue(@"AXTraits", stringValue);
  AddKeyValue(@"AXFrame", NSStringFromCGRect([element accessibilityFrame]));
  stringValue = [element accessibilityHint];
  AddKeyValue(@"AXHint", stringValue ? [NSString stringWithFormat:@"\"%@\"", stringValue] : nil);
  return [descriptions componentsJoinedByString:@" "];
}

/**
 *  @return The UIAccessibilityTraits to NSString mapping dictionary as type
 *          NSDictionary<NSNumber *, NSString *> *.
 */
+ (NSDictionary<NSNumber *, NSString *> const *)gtx_traitsToStringDictionary {
  // Each element below is an valid accessibility traits entity.
  return @{@(UIAccessibilityTraitNone): @"None",
           @(UIAccessibilityTraitButton): @"Button",
           @(UIAccessibilityTraitLink): @"Link",
           @(UIAccessibilityTraitSearchField): @"SearchField",
           @(UIAccessibilityTraitImage): @"Image",
           @(UIAccessibilityTraitSelected): @"Selected",
           @(UIAccessibilityTraitPlaysSound): @"PlaysSound",
           @(UIAccessibilityTraitKeyboardKey): @"KeyboardKey",
           @(UIAccessibilityTraitStaticText): @"StaticText",
           @(UIAccessibilityTraitSummaryElement): @"SummaryElement",
           @(UIAccessibilityTraitNotEnabled): @"NotEnabled",
           @(UIAccessibilityTraitUpdatesFrequently): @"UpdatesFrequently",
           @(UIAccessibilityTraitStartsMediaSession): @"StartsMediaSession",
           @(UIAccessibilityTraitAdjustable): @"Adjustable",
           @(UIAccessibilityTraitAllowsDirectInteraction): @"AllowsDirectInteraction",
           @(UIAccessibilityTraitCausesPageTurn): @"CausesPageTurn",
           @(UIAccessibilityTraitHeader): @"Header"
           };
}

/**
 *  @return The NSString value of the specified accessibility traits.
 */
+ (NSString *)gtx_stringValueOfUIAccessibilityTraits:(UIAccessibilityTraits)traits {
  if (traits == UIAccessibilityTraitNone) {
    return @"None";
  }

  NSMutableArray<NSString *> *traitsStrings = [[NSMutableArray alloc] init];
  const NSDictionary<NSNumber *, NSString *> *traitsToString = [self gtx_traitsToStringDictionary];
  for (NSNumber *trait in traitsToString.allKeys) {
    if (traits & [trait unsignedLongLongValue]) {
      [traitsStrings addObject:traitsToString[trait]];
    }
  }
  return [traitsStrings componentsJoinedByString:@","];
}

/**
 *  @return an image of the current screen.
 */
+ (UIImage *)gtx_takeScreenshot {
  UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size,
                                         YES,
                                         [UIScreen mainScreen].scale);

  for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
  }
  UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return screenshot;
}

/**
 *  @return a gray scale version of the provided @c image.
 */
+ (UIImage *)gtx_grayScaleImageFromImage:(UIImage *)image {
  // Create a bitmap context with gray scale color space.
  CGColorSpaceRef grayScaleColorSpace = CGColorSpaceCreateDeviceGray();
  CGContextRef context =
      CGBitmapContextCreate(NULL, (size_t)image.size.width, (size_t)image.size.height,
                            8, 0, grayScaleColorSpace, (uint32_t)kCGImageAlphaNone);

  // Render the given image into it and create a UIImage with the current contents.
  CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height),
                     [image CGImage]);
  CGImageRef grayScaleCGImage = CGBitmapContextCreateImage(context);
  UIImage *grayScaleUIImage = [UIImage imageWithCGImage:grayScaleCGImage];

  // Release all the created CF Objects.
  CGColorSpaceRelease(grayScaleColorSpace);
  CGContextRelease(context);
  CFRelease(grayScaleCGImage);
  return grayScaleUIImage;
}

@end
