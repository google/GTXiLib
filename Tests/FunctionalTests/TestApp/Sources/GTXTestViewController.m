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

#import "GTXTestStepperButton.h"

NSString *const kAddNoLabelElementActionName = @"Add no-label Element";
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
NSString *const kAddLowContrastBackground = @"Add Low contrast background";
NSString *const kAddHighContrastBackground = @"Add High contrast backgorund";

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

static __weak GTXTestViewController *viewController;

typedef void(^ActionHandler)(GTXTestViewController *sSelf);

@interface GTXTestViewController ()<UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UIScrollView *actionsContainerView;
@property(weak, nonatomic) IBOutlet UIView *testArea;

@end

@implementation GTXTestViewController {
  NSMutableDictionary *actionsToHandlers;
}

- (instancetype)init {
  self = [super initWithNibName:@"GTXTestViewController" bundle:nil];
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  viewController = self;
  self.actionsContainerView.accessibilityIdentifier = @"Actions Container";
  actionsToHandlers = [[NSMutableDictionary alloc] init];
  [self.navigationController setNavigationBarHidden:YES animated:NO];

  [self gtxtest_addActionNamed:kAddNoLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addElementWithLabel:@""];
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
                                                   backgroundColor:[UIColor whiteColor]];
                       }];
  [self gtxtest_addActionNamed:kAddVeryLowContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a low contrast label: black text on very dark grey background.
                         UIColor *veryDarkGreyColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor blackColor]
                                                   backgroundColor:veryDarkGreyColor];
                       }];

  UIColor *kAlmostRed = [UIColor colorWithRed:kAlmostRedColorValue green:0 blue:0 alpha:1];
  UIColor *kAlmostRedButDarker =
      [UIColor colorWithRed:kAlmostRedColorValue - 0.1f green:0 blue:0 alpha:1];
  [self gtxtest_addActionNamed:kAddBarelyLowContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:kAlmostRed];
                       }];
  [self gtxtest_addActionNamed:kAddBarelyHighContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:kAlmostRedButDarker];
                       }];
  [self gtxtest_addActionNamed:kAddNoContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:[UIColor redColor]];
                       }];
  [self gtxtest_addActionNamed:kAddTransparentHighContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor colorWithWhite:1.0
                                                                                     alpha:0.5]
                                                   backgroundColor:[UIColor blackColor]];
                       }];
  [self gtxtest_addActionNamed:kAddTransparentLowContrastLabel
                       handler:^(GTXTestViewController *sSelf) {
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor colorWithWhite:0.0
                                                                                     alpha:0.5]
                                                   backgroundColor:[UIColor redColor]];
                       }];
  [self gtxtest_addActionNamed:kAddLowContrastBackground
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a low contrast background with respect to text added on top of it.
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:[UIColor clearColor]];
                         [sSelf.testArea setBackgroundColor:kAlmostRed];
                       }];
  [self gtxtest_addActionNamed:kAddHighContrastBackground
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a high contrast background with respect to text added on top of it.
                         [sSelf gtxtest_addLabelWithForgroundColor:[UIColor redColor]
                                                   backgroundColor:[UIColor clearColor]];
                         [sSelf.testArea setBackgroundColor:kAlmostRedButDarker];
                       }];
  [self gtxtest_addActionNamed:kAddStandardUIKitTextView
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a standard contrast text view: black text on white background.
                         [sSelf gtxtest_addTextViewWithForgroundColor:nil backgroundColor:nil];
                       }];
  [self gtxtest_addActionNamed:kAddLowContrastTextView
                       handler:^(GTXTestViewController *sSelf) {
                         // Add a low contrast text view: black text on very dark grey background.
                         UIColor *veryDarkGreyColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
                         [sSelf gtxtest_addTextViewWithForgroundColor:[UIColor blackColor]
                                                      backgroundColor:veryDarkGreyColor];
                       }];
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
  NSAssert(!actionsToHandlers[name], @"Action %@ was already added.", name);
  actionsToHandlers[name] = handler;
}

+ (void)performTestActionNamed:(NSString *)actionName {
  GTXTestViewController *controller = viewController;
  NSAssert(controller, @"View controller has not loaded yet.");
  ActionHandler handler = controller->actionsToHandlers[actionName];
  NSAssert(handler, @"Action named %@ does not exist", actionName);
  handler(controller);
}

- (void)gtxtest_userTappedActionButton:(UIButton *)sender {
  [[self class] performTestActionNamed:sender.titleLabel.text];
}

- (void)gtxtest_addElementWithLabel:(NSString *)label {
  UIView *newElement = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin,
                                                                kMinimumElementSize,
                                                                kMinimumElementSize)];
  newElement.isAccessibilityElement = YES;
  newElement.accessibilityLabel = label;
  newElement.backgroundColor = [UIColor whiteColor];
  [self.testArea addSubview:newElement];
}

- (void)gtxtest_addShowKeyboard {
  UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kMargin, kMargin,
                                                                      kMinimumElementSize * 2,
                                                                      kMinimumElementSize)];
  textView.accessibilityIdentifier = @"testTextField";
  [self.testArea addSubview:textView];
  [textView becomeFirstResponder];
}

- (void)gtxtest_addInaccessibleButton {
  GTXTestStepperButton *stepperButton =
      [[GTXTestStepperButton alloc] initWithFrame:CGRectMake(kMargin, kMargin,
                                                             kMinimumElementSize,
                                                             kMinimumElementSize)];
  stepperButton.accessibilityIdentifier = @"inaccessibleButton";
  [self.testArea addSubview:stepperButton];
}

- (void)gtxtest_addInaccessibleButtonInSubview {
  CGRect frame = CGRectMake(kMargin, kMargin, kMinimumElementSize, kMinimumElementSize);
  GTXTestStepperButton *stepperButton = [[GTXTestStepperButton alloc] initWithFrame:frame];
  stepperButton.isAccessibilityElement = YES;
  stepperButton.accessibilityLabel = @"test button";
  UIView *inaccessibleContainer = [[UIView alloc] initWithFrame:frame];
  inaccessibleContainer.accessibilityIdentifier = @"inaccessibleContainerID";
  [inaccessibleContainer addSubview:stepperButton];
  [self.testArea addSubview:inaccessibleContainer];
}

- (void)gtxtest_addTinyTappableElement {
  UIButton *tinyButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, kMargin, 10, 10)];
  tinyButton.accessibilityLabel = @"tiny button";
  [tinyButton setTitle:@"*" forState:UIControlStateNormal];
  [self.testArea addSubview:tinyButton];
}

- (void)gtxtest_addLabelWithForgroundColor:(UIColor *)foregroundColor
                           backgroundColor:(UIColor *)backgroundColor {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, 0, 0)];
  label.font = [UIFont systemFontOfSize:60.0];
  label.text = @"Hello";
  label.textColor = foregroundColor;
  label.backgroundColor = backgroundColor;
  [label sizeToFit];
  [self.testArea addSubview:label];
}

- (void)gtxtest_addTextViewWithForgroundColor:(UIColor *)foregroundColor
                              backgroundColor:(UIColor *)backgroundColor {
  UITextView *view = [[UITextView alloc] initWithFrame:CGRectMake(kMargin, kMargin, 0, 0)];
  view.font = [UIFont systemFontOfSize:60.0];
  view.text = @"Hello";
  if (![foregroundColor isEqual:nil]) {
    view.textColor = foregroundColor;
  }
  if (![backgroundColor isEqual:nil]) {
    view.backgroundColor = backgroundColor;
  }
  [view sizeToFit];
  [self.testArea addSubview:view];
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

+ (void)addElementToTestArea:(UIView *)element {
  NSAssert(viewController, @"View controller has not loaded yet.");
  [viewController.testArea addSubview:element];
}

+ (void)clearTestArea {
  NSAssert(viewController, @"View controller has not loaded yet.");
  [viewController gtxtest_clearAllFields];
}

@end
