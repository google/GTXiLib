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

  [self axetest_addActionNamed:kAddNoLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addElementWithLabel:@""];
  }];
  [self axetest_addActionNamed:kAddPunctuatedLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addElementWithLabel:@"Foo."];
  }];
  [self axetest_addActionNamed:kAddConcatenatedLabelElementActionName
                       handler:^(GTXTestViewController *sSelf) {
    // Add an element with concatenated labels: foo and bar.
    [sSelf axetest_addElementWithLabel:@"foo,bar."];
  }];
  [self axetest_addActionNamed:kShowKeyboardActionName handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addShowKeyboard];
  }];
  [self axetest_addActionNamed:kHideKeyboardActionName handler:^(GTXTestViewController *sSelf) {
    [sSelf.testArea.subviews[0] resignFirstResponder];
  }];
  [self axetest_addActionNamed:kAddInaccessibleButton handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addInAccessibleButton];
  }];
  [self axetest_addActionNamed:kAddAccessibleButtonInContainer
                       handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addInAccessibleButtonInSubview];
  }];
  [self axetest_addActionNamed:kAddTinyTappableElement handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addTinyTappableElement];
  }];
  [self axetest_addActionNamed:kAddVeryHighContrastLabel handler:^(GTXTestViewController *sSelf) {
    // Add a high contrast label: black text on white background.
    [sSelf axetest_addLabelWithForgroundColor:[UIColor blackColor]
                              backgroundColor:[UIColor whiteColor]];
  }];
  [self axetest_addActionNamed:kAddVeryLowContrastLabel handler:^(GTXTestViewController *sSelf) {
    // Add a low contrast label: black text on very dark grey background.
    UIColor *veryDarkGreyColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    [sSelf axetest_addLabelWithForgroundColor:[UIColor blackColor]
                              backgroundColor:veryDarkGreyColor];
  }];

  UIColor *kAlmostRed = [UIColor colorWithRed:kAlmostRedColorValue green:0 blue:0 alpha:1];
  UIColor *kAlmostRedButDarker =
      [UIColor colorWithRed:kAlmostRedColorValue - 0.1f green:0 blue:0 alpha:1];
  [self axetest_addActionNamed:kAddBarelyLowContrastLabel handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addLabelWithForgroundColor:[UIColor redColor]
                              backgroundColor:kAlmostRed];
  }];
  [self axetest_addActionNamed:kAddBarelyHighContrastLabel handler:^(GTXTestViewController *sSelf) {
    [sSelf axetest_addLabelWithForgroundColor:[UIColor redColor]
                              backgroundColor:kAlmostRedButDarker];
  }];
  [self axetest_addActionNamed:kAddLowContrastBackground handler:^(GTXTestViewController *sSelf) {
    // Add a low contrast background with respect to text added on top of it.
    [sSelf axetest_addLabelWithForgroundColor:[UIColor redColor]
                              backgroundColor:[UIColor clearColor]];
    [sSelf.testArea setBackgroundColor:kAlmostRed];
  }];
  [self axetest_addActionNamed:kAddHighContrastBackground handler:^(GTXTestViewController *sSelf) {
    // Add a high contrast background with respect to text added on top of it.
    [sSelf axetest_addLabelWithForgroundColor:[UIColor redColor]
                              backgroundColor:[UIColor clearColor]];
    [sSelf.testArea setBackgroundColor:kAlmostRedButDarker];
  }];
}

- (void)axetest_addActionNamed:(NSString *)name handler:(ActionHandler)handler {
  UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [newButton addTarget:self
                action:@selector(userTappedActionButton:)
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

- (void)userTappedActionButton:(UIButton *)sender {
  [[self class] performTestActionNamed:sender.titleLabel.text];
}

- (void)axetest_addElementWithLabel:(NSString *)label {
  UIView *newElement = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin,
                                                                kMinimumElementSize,
                                                                kMinimumElementSize)];
  newElement.isAccessibilityElement = YES;
  newElement.accessibilityLabel = label;
  newElement.backgroundColor = [UIColor whiteColor];
  [self.testArea addSubview:newElement];
}

- (void)axetest_addShowKeyboard {
  UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kMargin, kMargin,
                                                                      kMinimumElementSize * 2,
                                                                      kMinimumElementSize)];
  textView.accessibilityIdentifier = @"testTextField";
  [self.testArea addSubview:textView];
  [textView becomeFirstResponder];
}

- (void)axetest_addInAccessibleButton {
  GTXTestStepperButton *stepperButton =
      [[GTXTestStepperButton alloc] initWithFrame:CGRectMake(kMargin, kMargin,
                                                             kMinimumElementSize,
                                                             kMinimumElementSize)];
  stepperButton.accessibilityIdentifier = @"inAccessibleButton";
  [self.testArea addSubview:stepperButton];
}

- (void)axetest_addInAccessibleButtonInSubview {
  CGRect frame = CGRectMake(kMargin, kMargin, kMinimumElementSize, kMinimumElementSize);
  GTXTestStepperButton *stepperButton = [[GTXTestStepperButton alloc] initWithFrame:frame];
  stepperButton.isAccessibilityElement = YES;
  stepperButton.accessibilityLabel = @"test button";
  UIView *inAccessibleContainer = [[UIView alloc] initWithFrame:frame];
  inAccessibleContainer.accessibilityIdentifier = @"inAccessibleContainerID";
  [inAccessibleContainer addSubview:stepperButton];
  [self.testArea addSubview:inAccessibleContainer];
}

- (void)axetest_addTinyTappableElement {
  UIButton *tinyButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, kMargin, 10, 10)];
  tinyButton.accessibilityLabel = @"tiny button";
  [tinyButton setTitle:@"*" forState:UIControlStateNormal];
  [self.testArea addSubview:tinyButton];
}

- (void)axetest_addLabelWithForgroundColor:(UIColor *)foregroundColor
                           backgroundColor:(UIColor *)backgroundColor {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, 0, 0)];
  label.font = [UIFont systemFontOfSize:60.0];
  label.text = @"Hello";
  label.textColor = foregroundColor;
  label.backgroundColor = backgroundColor;
  [label sizeToFit];
  [self.testArea addSubview:label];
}

- (IBAction)userTappedClearFields:(UIButton *)sender {
  [self axetest_clearAllFields];
}

- (IBAction)userTappedScrollToTop:(UIButton *)sender {
  [self.actionsContainerView setContentOffset:CGPointZero animated:YES];
}

- (void)axetest_clearAllFields {
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
  [viewController axetest_clearAllFields];
}

@end
