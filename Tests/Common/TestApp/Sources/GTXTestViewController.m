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

#import "GTXTestViewController.h"

#import "GTXTestContrastCheckTestView.h"
#import "GTXTestCustomTraitElement.h"
#import "GTXTestStepperButton.h"

NSString *const kAddNoLabelElementActionName = @"Add no-label Element";
NSString *const kAddNonpunctuatedLabelElementActionName = @"Add non-punctuated-label Element";
NSString *const kAddPunctuatedLabelElementActionName = @"Add punctuated-label Element";
NSString *const kAddConcatenatedLabelElementActionName = @"Add concatenated-label Element";
NSString *const kShowKeyboardActionName = @"Show Keyboard";
NSString *const kHideKeyboardActionName = @"Hide Keyboard";
NSString *const kAddInaccessibleButton = @"Add InAccessible button";
NSString *const kAddAccessibleButtonInContainer = @"Add Accessible button in subview";
NSString *const kAddTinyTappableElement = @"Add tiny element";
NSString *const kAddVeryHighContrastLabel = @"Add very high contrast label";
NSString *const kAddVeryLowContrastLabel = @"Add very low contrast label";
NSString *const kAddBarelyHighContrastLabel = @"Add barely High contrast label";
NSString *const kAddBarelyLowContrastLabel = @"Add barely Low contrast label";
NSString *const kAddNoContrastLabel = @"Add no contrast label";
NSString *const kAddTransparentHighContrastLabel = @"Add transparent high contrast label";
NSString *const kAddTransparentLowContrastLabel = @"Add transparent low contrast label";
NSString *const kAddLowContrastTextView = @"Add low contrast text view";
NSString *const kAddStandardUIKitTextView = @"Add standard UIKit text view";
NSString *const kAddLabelWithFontWithName = @"Add label with fontWithName";
NSString *const kAddLabelWithPreferredFontForTextStyle =
    @"Add label with preferredFontForTextStyle";
NSString *const kAddLabelWithFontMetrics = @"Add label with metricsWithTextStyle";
NSString *const kAddTextViewWithFontWithName = @"Add text view with fontWithName";
NSString *const kAddTextViewWithPreferredFontForTextStyle =
    @"Add text view with preferredFontForTextStyle";
NSString *const kAddTextViewWithFontMetrics = @"Add text view with metricsWithTextStyle";
NSString *const kAddLowContrastBackground = @"Add Low contrast background";
NSString *const kAddHighContrastBackground = @"Add High contrast backgorund";
NSString *const kAddMultipleElementsWithChildren = @"Add multiple elements with children";
NSString *const kAddCustomTraitsTestElement = @"Add custom traits element";
NSString *const kAddButtonTraitToCustomTraitsElement = @"Add button trait to the test element";
NSString *const kAddPlaysSoundTraitToCustomTraitsElement =
    @"Add 'plays sound' trait to the test element";
NSString *const kAddContrastCheckTestViewWithNoText = @"Add no-text ContrastCheck view";
NSString *const kAddContrastCheckTestViewWithSingleWord = @"Add one word ContrastCheck view";
NSString *const kAddContrastCheckTestViewWithMultipleWords = @"Add many words ContrastCheck view";
NSString *const kAddContrastCheckTestViewWithLowContrastSingleWord =
    @"Add one word low contrast ContrastCheck view";
NSString *const kAddContrastCheckTestViewWithLowContrastMultipleWords =
    @"Add low contrast multiple words ContrastCheck view";
NSString *const kAddContrastCheckTestViewWithLargeColorBlocks =
    @"Add ContrastCheck view with color blocks";

#pragma mark - Accessibility Identifiers

NSString *const kGTXTestAppClearTestAreaID = @"kGTXTestAppClearTestAreaID";
NSString *const kGTXTestAppScrollToTopID = @"kGTXTestAppScrollToTopID";
NSString *const kGTXTestAppActionsContainerID = @"kGTXTestAppActionsContainerID";
NSString *const kGTXTestTestingAreaID = @"kGTXTestTestingAreaID";
NSString *const kGTXTestTestingElementID = @"kGTXTestTestingElementID";
const NSInteger kGTXTestMultipleTestingElementIDsCount = 4;
NSString *const kGTXTestMultipleTestingElementsIDs[4] = {
    kGTXTestTestingElementID, @"kGTXTestMultipleTestingElementsIDs1",
    @"kGTXTestMultipleTestingElementsIDs2", @"kGTXTestMultipleTestingElementsIDs3"};

/**
 *  The minimum size required to make UIElements accessible.
 */
static const CGFloat kMinimumElementSize = 48.0;

/**
 *  The margin used in the test app.
 */
static const CGFloat kMargin = 10.0;

/**
 *  The red component to get a red color thats barely (low contrast) distinguishable from complete
 *  red color.
 */
static const CGFloat kAlmostRedColorValue = 0.5;

/**
 *  The font name for fonts constructed with @c fontWithName.
 */
static NSString *const kDefaultFontName = @"Arial";

/**
 *  The font size for fonts constructed with @c fontWithName.
 */
static const CGFloat kDefaultFontSize = 48.0;

static __weak GTXTestViewController *gViewController;

typedef void (^ActionHandler)(GTXTestViewController *sSelf);

@interface GTXTestViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UIScrollView *actionsContainerView;
@property(weak, nonatomic) IBOutlet UIView *testArea;

@end

@implementation GTXTestViewController {
  NSMutableDictionary *_actionsToHandlers;
  __weak GTXTestCustomTraitElement *_customTraitsElement;
}

- (instancetype)init {
  self = [super initWithNibName:@"GTXTestViewController" bundle:nil];
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  gViewController = self;
  self.testArea.accessibilityIdentifier = kGTXTestTestingAreaID;
  self.actionsContainerView.accessibilityIdentifier = kGTXTestAppActionsContainerID;
  _actionsToHandlers = [[NSMutableDictionary alloc] init];
  [self.navigationController setNavigationBarHidden:YES animated:NO];

  [self gtxtest_addActionNamed:kAddNoLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addElementWithLabel:@""];
                       }];
  [self gtxtest_addActionNamed:kAddNonpunctuatedLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addElementWithLabel:@"Foo"];
                       }];
  [self gtxtest_addActionNamed:kAddPunctuatedLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addElementWithLabel:@"Foo."];
                       }];
  [self gtxtest_addActionNamed:kAddConcatenatedLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
                         // Add an element with concatenated labels: foo and bar.
                         [sSelf gtxtest_addElementWithLabel:@"foo,bar."];
                       }];
  [self gtxtest_addActionNamed:kShowKeyboardActionName
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addShowKeyboard];
                       }];
  [self gtxtest_addActionNamed:kHideKeyboardActionName
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf.testArea.subviews[0] resignFirstResponder];
                       }];
  [self gtxtest_addActionNamed:kAddInaccessibleButton
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addInaccessibleButton];
                       }];
  [self gtxtest_addActionNamed:kAddAccessibleButtonInContainer
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addInaccessibleButtonInSubview];
                       }];
  [self gtxtest_addActionNamed:kAddTinyTappableElement
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addTinyTappableElement];
                       }];
  [self gtxtest_addActionNamed:kAddVeryHighContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a high contrast label: black text on white background.
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor blackColor]
                                                   backgroundColor:[UIColor whiteColor]
                                                              font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddVeryLowContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a low contrast label: black text on very dark grey background.
                         UIColor *veryDarkGreyColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor blackColor]
                                                   backgroundColor:veryDarkGreyColor
                                                              font:nil];
                       }];

  UIColor *kAlmostRed = [UIColor colorWithRed:kAlmostRedColorValue green:0 blue:0 alpha:1];
  UIColor *kAlmostRedButDarker = [UIColor colorWithRed:kAlmostRedColorValue - 0.15f
                                                 green:0
                                                  blue:0
                                                 alpha:1];
  [self gtxtest_addActionNamed:kAddBarelyLowContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:kAlmostRed
                                                              font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddBarelyHighContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:kAlmostRedButDarker
                                                              font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddNoContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:[UIColor redColor]
                                                              font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddTransparentHighContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor colorWithWhite:1.0
                                                                                     alpha:0.5]
                                                   backgroundColor:[UIColor blackColor]
                                                              font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddTransparentLowContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor colorWithWhite:0.0
                                                                                     alpha:0.5]
                                                   backgroundColor:[UIColor redColor]
                                                              font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddLabelWithFontWithName
                       handler:^(GTXTestViewController *sSelf) {
                         UIFont *font = [UIFont fontWithName:kDefaultFontName
                                                        size:kDefaultFontSize];
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor blackColor]
                                                   backgroundColor:[UIColor whiteColor]
                                                              font:font];
                       }];
  [self gtxtest_addActionNamed:kAddLabelWithPreferredFontForTextStyle
                       handler:^(GTXTestViewController *sSelf) {
                         UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor blackColor]
                                                   backgroundColor:[UIColor whiteColor]
                                                              font:font];
                       }];
  [self gtxtest_addActionNamed:kAddLabelWithFontMetrics
                       handler:^(GTXTestViewController *sSelf) {
                         // UIFontMetrics did not exist before iOS 11 so the event is a no-op.
                         if (@available(iOS 11.0, *)) {
                           UIFont *nonscalingFont = [UIFont fontWithName:kDefaultFontName
                                                                    size:kDefaultFontSize];
                           UIFont *font = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody]
                               scaledFontForFont:nonscalingFont];
                           [sSelf gtxtest_addTextViewWithForgroundColor:[UIColor blackColor]
                                                        backgroundColor:[UIColor whiteColor]
                                                                   font:font];
                         }
                       }];
  [self gtxtest_addActionNamed:kAddTextViewWithFontWithName
                       handler:^(GTXTestViewController *sSelf) {
                         UIFont *font = [UIFont fontWithName:kDefaultFontName
                                                        size:kDefaultFontSize];
                         [sSelf gtxtest_addTextViewWithForgroundColor:[UIColor blackColor]
                                                      backgroundColor:[UIColor whiteColor]
                                                                 font:font];
                       }];
  [self gtxtest_addActionNamed:kAddTextViewWithPreferredFontForTextStyle
                       handler:^(GTXTestViewController *sSelf) {
                         UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
                         [sSelf gtxtest_addTextViewWithForgroundColor:[UIColor blackColor]
                                                      backgroundColor:[UIColor whiteColor]
                                                                 font:font];
                       }];
  [self gtxtest_addActionNamed:kAddTextViewWithFontMetrics
                       handler:^(GTXTestViewController *sSelf) {
                         // UIFontMetrics did not exist before iOS 11 so the event is a no-op.
                         if (@available(iOS 11.0, *)) {
                           UIFont *nonscalingFont = [UIFont fontWithName:kDefaultFontName
                                                                    size:kDefaultFontSize];
                           UIFont *font = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody]
                               scaledFontForFont:nonscalingFont];
                           [sSelf gtxtest_addTextViewWithForgroundColor:[UIColor blackColor]
                                                        backgroundColor:[UIColor whiteColor]
                                                                   font:font];
                         }
                       }];
  [self gtxtest_addActionNamed:kAddLowContrastBackground
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a low contrast background with respect to text added on top of it.
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:[UIColor clearColor]
                                                              font:nil];
                         [sSelf.testArea setBackgroundColor:kAlmostRed];
                       }];
  [self gtxtest_addActionNamed:kAddHighContrastBackground
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a high contrast background with respect to text added on top of it.
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:[UIColor clearColor]
                                                              font:nil];
                         [sSelf.testArea setBackgroundColor:kAlmostRedButDarker];
                       }];
  [self gtxtest_addActionNamed:kAddStandardUIKitTextView
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a standard contrast text view: black text on white background.
                         [sSelf gtxtest_addTextViewWithForgroundColor:nil
                                                      backgroundColor:nil
                                                                 font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddButtonTraitToCustomTraitsElement
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf
                             gtxtest_withCustomTraitsElementAppendTrait:UIAccessibilityTraitButton];
                       }];
  [self gtxtest_addActionNamed:kAddPlaysSoundTraitToCustomTraitsElement
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_withCustomTraitsElementAppendTrait:
                                    UIAccessibilityTraitPlaysSound];
                       }];
  [self gtxtest_addActionNamed:kAddCustomTraitsTestElement
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addCustomTraitsTestElement];
                       }];
  [self gtxtest_addActionNamed:kAddContrastCheckTestViewWithNoText
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addContrastCheckTestViewWithNoText];
                       }];
  [self gtxtest_addActionNamed:kAddContrastCheckTestViewWithSingleWord
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addContrastCheckTestViewWithSingleWord];
                       }];
  [self gtxtest_addActionNamed:kAddContrastCheckTestViewWithMultipleWords
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addContrastCheckTestViewWithMultipleWords];
                       }];
  [self gtxtest_addActionNamed:kAddContrastCheckTestViewWithLowContrastSingleWord
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addContrastCheckTestViewWithLowContrastSingleWord];
                       }];
  [self gtxtest_addActionNamed:kAddContrastCheckTestViewWithLowContrastMultipleWords
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLowContrastMultiWordContrastCheckTestView];
                       }];
  [self gtxtest_addActionNamed:kAddContrastCheckTestViewWithLargeColorBlocks
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addContrastCheckTestViewWithColorBlocks];
                       }];
  [self gtxtest_addActionNamed:kAddLowContrastTextView
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a low contrast text view: black text on very dark grey background.
                         UIColor *veryDarkGreyColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
                         [sSelf gtxtest_addTextViewWithForgroundColor:[UIColor blackColor]
                                                      backgroundColor:veryDarkGreyColor
                                                                 font:nil];
                       }];
  [self gtxtest_addActionNamed:kAddMultipleElementsWithChildren
                       handler:^(GTXTestViewController *sSelf) {
                         UIView *parent = [GTXTestViewController
                             accessibleViewInSuperview:sSelf.testArea
                                                 frame:CGRectMake(0, 0, 44, 44)
                               accessibilityIdentifier:kGTXTestMultipleTestingElementsIDs[0]
                                       backgroundColor:[UIColor redColor]];
                         UIView *child1 = [GTXTestViewController
                             accessibleViewInSuperview:parent
                                                 frame:CGRectMake(44, 0, 44, 44)
                               accessibilityIdentifier:kGTXTestMultipleTestingElementsIDs[1]
                                       backgroundColor:[UIColor blueColor]];
                         [GTXTestViewController
                             accessibleViewInSuperview:parent
                                                 frame:CGRectMake(0, 44, 44, 44)
                               accessibilityIdentifier:kGTXTestMultipleTestingElementsIDs[2]
                                       backgroundColor:[UIColor greenColor]];
                         [GTXTestViewController
                             accessibleViewInSuperview:child1
                                                 frame:CGRectMake(0, 44, 44, 44)
                               accessibilityIdentifier:kGTXTestMultipleTestingElementsIDs[3]
                                       backgroundColor:[UIColor yellowColor]];
                       }];
  // Default state of the test app is to include an invalid acccessibile element, this helps verify
  // the case where app is launched and scanned for accessibility without interacting with it.
  [self gtxtest_addTinyTappableElement];
}

- (void)gtxtest_addActionNamed:(NSString *)name handler:(ActionHandler)handler {
  UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [newButton addTarget:self
                action:@selector(gtxtest_userTappedActionButton:)
      forControlEvents:UIControlEventTouchUpInside];
  [newButton setTitle:name forState:UIControlStateNormal];
  [newButton sizeToFit];
  CGRect buttonFrame = newButton.frame;
  buttonFrame.size.height = kMinimumElementSize;
  newButton.frame = buttonFrame;
  newButton.accessibilityIdentifier = name;

  CGSize contentSize = self.actionsContainerView.contentSize;
  buttonFrame.origin.y = contentSize.height + kMargin;
  contentSize.height += newButton.frame.size.height + kMargin;
  newButton.frame = buttonFrame;
  self.actionsContainerView.contentSize = contentSize;
  [self.actionsContainerView addSubview:newButton];
  NSAssert(!_actionsToHandlers[name], @"Action %@ was already added.", name);
  _actionsToHandlers[name] = handler;
}

+ (void)performTestActionNamed:(NSString *)actionName {
  GTXTestViewController *controller = gViewController;
  NSAssert(controller, @"View controller has not loaded yet.");
  ActionHandler handler = controller->_actionsToHandlers[actionName];
  NSAssert(handler, @"Action named %@ does not exist", actionName);
  handler(controller);
}

- (void)gtxtest_userTappedActionButton:(UIButton *)sender {
  [[self class] performTestActionNamed:sender.titleLabel.text];
}

- (void)gtxtest_addElementWithLabel:(NSString *)label {
  UIView *newElement = [[UIView alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, kMinimumElementSize, kMinimumElementSize)];
  newElement.isAccessibilityElement = YES;
  newElement.accessibilityLabel = label;
  newElement.backgroundColor = [UIColor whiteColor];
  [self gtxtest_addTestElement:newElement];
}

- (void)gtxtest_addShowKeyboard {
  UITextView *textView = [[UITextView alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, kMinimumElementSize * 2, kMinimumElementSize)];
  textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
  textView.adjustsFontForContentSizeCategory = YES;
  [self gtxtest_addTestElement:textView];
  [textView becomeFirstResponder];
}

- (void)gtxtest_addInaccessibleButton {
  GTXTestStepperButton *stepperButton = [[GTXTestStepperButton alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, kMinimumElementSize, kMinimumElementSize)];
  [self gtxtest_addTestElement:stepperButton];
}

- (void)gtxtest_addInaccessibleButtonInSubview {
  CGRect frame = CGRectMake(kMargin, kMargin, kMinimumElementSize, kMinimumElementSize);
  GTXTestStepperButton *stepperButton = [[GTXTestStepperButton alloc] initWithFrame:frame];
  stepperButton.isAccessibilityElement = YES;
  stepperButton.accessibilityLabel = @"test button";
  UIView *inaccessibleContainer = [[UIView alloc] initWithFrame:frame];
  [inaccessibleContainer addSubview:stepperButton];
  [self gtxtest_addTestElement:inaccessibleContainer];
}

- (void)gtxtest_addTinyTappableElement {
  UIButton *tinyButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, kMargin, 10, 10)];
  tinyButton.accessibilityLabel = @"tiny button";
  tinyButton.accessibilityIdentifier = kGTXTestTestingElementID;
  [tinyButton setTitle:@"*" forState:UIControlStateNormal];
  [self gtxtest_addTestElement:tinyButton];
}

/**
 *  Adds a @c UILabel to the test area view with the given text color, background color, and font.
 *
 *  @param foregroundColor The text color.
 *  @param backgroundColor The background color.
 *  @param font The font. If @c nil, the default Dynamic Type supporting font is used.
 */
- (void)gtxtest_addLabelWithForgroundColor:(UIColor *)foregroundColor
                           backgroundColor:(UIColor *)backgroundColor
                                      font:(nullable UIFont *)font {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, 0, 0)];
  if (font == nil) {
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
  } else {
    label.font = font;
  }
  label.adjustsFontForContentSizeCategory = YES;
  label.text = @"Hello";
  label.textColor = foregroundColor;
  label.backgroundColor = backgroundColor;
  label.accessibilityIdentifier = kGTXTestTestingElementID;
  [label sizeToFit];
  [self gtxtest_addTestElement:label];
}

/**
 *  Adds a @c UITextView to the test area view with the given text color, background color, and
 * font.
 *
 *  @param foregroundColor The text color.
 *  @param backgroundColor The background color.
 *  @param font The font. If @c nil, the default Dynamic Type supporting font is used.
 */
- (void)gtxtest_addTextViewWithForgroundColor:(UIColor *)foregroundColor
                              backgroundColor:(UIColor *)backgroundColor
                                         font:(nullable UIFont *)font {
  UITextView *view = [[UITextView alloc] initWithFrame:CGRectMake(kMargin, kMargin, 0, 0)];
  // text must be set before font because in some cases, the system silently changes the font object
  // when setting text. If the font were set first, it would be overridden. The new font has a
  // different property than expected by some test cases, specifically
  // testTextViewWithFontWithNameCausesErrors, failing them. For some reason, this only occurs when
  // running the entire test suite. The test case passes when run individually or when logging the
  // font value several times in this method. The bug may be an order dependent test or a race
  // condition in the operating system.
  view.text = @"Hello";
  if (font == nil) {
    view.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
  } else {
    view.font = font;
  }
  view.adjustsFontForContentSizeCategory = YES;
  if (![foregroundColor isEqual:nil]) {
    view.textColor = foregroundColor;
  }
  if (![backgroundColor isEqual:nil]) {
    view.backgroundColor = backgroundColor;
  }
  [view sizeToFit];
  [self gtxtest_addTestElement:view];
}

/**
 *  Adds a custom element whose traits can be modified.
 */
- (void)gtxtest_addCustomTraitsTestElement {
  GTXTestCustomTraitElement *element = [[GTXTestCustomTraitElement alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, kMinimumElementSize, kMinimumElementSize)];
  element.isAccessibilityElement = YES;
  _customTraitsElement = element;
  [self gtxtest_addTestElement:element];
}

/**
 *  Adds a contrast test view with no text.
 */
- (void)gtxtest_addContrastCheckTestViewWithNoText {
  GTXTestContrastCheckTestView *element = [[GTXTestContrastCheckTestView alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, 100, kMinimumElementSize)
        renderBlock:^(GTXTestContrastCheckTestView *testView, CGContextRef contextRef) {
          [[UIColor whiteColor] setFill];
          [[UIBezierPath bezierPathWithRect:testView.bounds] fill];
        }];
  element.isAccessibilityElement = YES;
  element.accessibilityTraits |= UIAccessibilityTraitLink;
  [self gtxtest_addTestElement:element];
}

/**
 *  Adds a contrast test view with no text.
 */
- (void)gtxtest_addContrastCheckTestViewWithSingleWord {
  [self gtxtest_addSingleWordContrastCheckTestViewWithBackgroundColor:UIColor.whiteColor
                                                            textColor:UIColor.blackColor];
}

/**
 *  Adds a contrast test view with single word.
 */
- (void)gtxtest_addContrastCheckTestViewWithLowContrastSingleWord {
  [self gtxtest_addSingleWordContrastCheckTestViewWithBackgroundColor:UIColor.whiteColor
                                                            textColor:[UIColor colorWithWhite:0.8
                                                                                        alpha:1.0]];
}

/**
 *  Adds a contrast test view with multiple separated words.
 */
- (void)gtxtest_addContrastCheckTestViewWithMultipleWords {
  [self gtxtest_addMultiWordContrastCheckTestViewWithBackgroundColor:UIColor.whiteColor
                                                          word1Color:UIColor.blackColor
                                                          word2Color:UIColor.blackColor];
}

/**
 *  Adds a low contrast contrast test view with multiple separated words.
 */
- (void)gtxtest_addLowContrastMultiWordContrastCheckTestView {
  // NOTE: Contrast ratio of white vs 55% white is 3.3 (high contrast) and vs 70% white is 2.12 (low
  // contrast).
  [self gtxtest_addMultiWordContrastCheckTestViewWithBackgroundColor:UIColor.whiteColor
                                                          word1Color:[UIColor colorWithWhite:0.55
                                                                                       alpha:1.0]
                                                          word2Color:[UIColor colorWithWhite:0.7
                                                                                       alpha:1.0]];
}

/**
 *  Adds a contrast test view with multiple separated words.
 */
- (void)gtxtest_addMultiWordContrastCheckTestViewWithBackgroundColor:(UIColor *)backgroundColor
                                                          word1Color:(UIColor *)word1Color
                                                          word2Color:(UIColor *)word2Color {
  GTXTestContrastCheckTestView *element = [[GTXTestContrastCheckTestView alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, 100, kMinimumElementSize)
        renderBlock:^(GTXTestContrastCheckTestView *testView, CGContextRef contextRef) {
          [backgroundColor setFill];
          [[UIBezierPath bezierPathWithRect:testView.bounds] fill];
          // Draw first word at top left corner.
          [@"Hello" drawAtPoint:CGPointMake(0, 0)
                 withAttributes:@{NSForegroundColorAttributeName : word1Color}];
          // Draw second word at bottom right corner.
          NSString *bottomText = @"World";
          CGRect textRect;
          textRect.size = [bottomText sizeWithAttributes:nil];
          textRect.origin.x = CGRectGetMaxX(testView.bounds) - textRect.size.width;
          textRect.origin.y = CGRectGetMaxY(testView.bounds) - textRect.size.height;
          [bottomText drawInRect:textRect
                  withAttributes:@{NSForegroundColorAttributeName : word2Color}];
        }];
  element.isAccessibilityElement = YES;
  element.accessibilityTraits |= UIAccessibilityTraitLink;
  [self gtxtest_addTestElement:element];
}

- (void)gtxtest_addSingleWordContrastCheckTestViewWithBackgroundColor:(UIColor *)backgroundColor
                                                            textColor:(UIColor *)textColor {
  GTXTestContrastCheckTestView *element = [[GTXTestContrastCheckTestView alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, 100, kMinimumElementSize)
        renderBlock:^(GTXTestContrastCheckTestView *testView, CGContextRef contextRef) {
          [backgroundColor setFill];
          [[UIBezierPath bezierPathWithRect:testView.bounds] fill];
          [@"Hello" drawAtPoint:CGPointMake(0, 0)
                 withAttributes:@{NSForegroundColorAttributeName : textColor}];
        }];
  element.isAccessibilityElement = YES;
  element.accessibilityTraits |= UIAccessibilityTraitLink;
  [self gtxtest_addTestElement:element];
}

/**
 *  Adds a contrast test view text on top and color blocks below it.
 */
- (void)gtxtest_addContrastCheckTestViewWithColorBlocks {
  GTXTestContrastCheckTestView *element = [[GTXTestContrastCheckTestView alloc]
      initWithFrame:CGRectMake(kMargin, kMargin, 100, kMinimumElementSize)
        renderBlock:^(GTXTestContrastCheckTestView *testView, CGContextRef contextRef) {
          [[UIColor whiteColor] setFill];
          [[UIBezierPath bezierPathWithRect:testView.bounds] fill];
          [[UIColor blackColor] setStroke];
          // Draw some text at top left corner.
          NSString *text = @"Hello";
          [text drawAtPoint:CGPointMake(0, 0) withAttributes:nil];
          // Now render color blocks *outside* its bounds (this ensures that colors obtained from
          // OCR differ from colors obtained using histogram).
          CGSize size = [text sizeWithAttributes:nil];
          CGRect blockBounds = testView.bounds;
          blockBounds.size.height -= size.height;
          blockBounds.origin.y += size.height;
          UIColor *veryLightGray = [UIColor colorWithWhite:0.8 alpha:1.0];
          UIColor *lightGray = [UIColor colorWithWhite:0.6 alpha:1.0];
          CGRect leftBock = blockBounds;
          leftBock.size.width /= 2.0;
          CGRect rightBlock = leftBock;
          rightBlock.origin.x += rightBlock.size.width;
          [veryLightGray setFill];
          [[UIBezierPath bezierPathWithRect:leftBock] fill];
          [lightGray setFill];
          [[UIBezierPath bezierPathWithRect:rightBlock] fill];
        }];
  element.isAccessibilityElement = YES;
  element.accessibilityTraits |= UIAccessibilityTraitLink;
  [self gtxtest_addTestElement:element];
}

/**
 *  Appends the given trait to the custom element.
 *
 *  @param newTrait The new trait to be appended.
 */
- (void)gtxtest_withCustomTraitsElementAppendTrait:(UIAccessibilityTraits)newTrait {
  [_customTraitsElement addCustomTrait:newTrait];
}

- (IBAction)gtxtest_userTappedClearFields:(UIButton *)sender {
  [self gtxtest_clearAllFields];
}

- (IBAction)gtxtest_userTappedScrollToTop:(UIButton *)sender {
  [self.actionsContainerView setContentOffset:CGPointZero animated:YES];
}

- (void)gtxtest_clearAllFields {
  // Clear the container
  for (UIView *subview in self.testArea.subviews) {
    [subview removeFromSuperview];
  }
}

- (void)gtxtest_addTestElement:(UIView *)testElement {
  testElement.accessibilityIdentifier = kGTXTestTestingElementID;
  [gViewController.testArea addSubview:testElement];
}

+ (void)addElementToTestArea:(UIView *)element {
  NSAssert(gViewController, @"View controller has not loaded yet.");
  [gViewController gtxtest_addTestElement:element];
}

+ (UIView *)accessibleViewInSuperview:(UIView *)superview
                                frame:(CGRect)frame
              accessibilityIdentifier:(NSString *)accessibilityIdentifier
                      backgroundColor:(UIColor *)color {
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.isAccessibilityElement = YES;
  view.accessibilityIdentifier = accessibilityIdentifier;
  view.backgroundColor = color;
  [superview addSubview:view];
  superview.isAccessibilityElement = NO;
  return view;
}

+ (void)clearTestArea {
  NSAssert(gViewController, @"View controller has not loaded yet.");
  [gViewController gtxtest_clearAllFields];
}

@end
