[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## What is GTXiLib?
GTXiLib, Google Toolbox for Accessibility for the iOS platform or simply GTX-eye
is a framework for iOS accessibility testing. GTXiLib has XCTest integration and
can be used with any XCTest-based frameworks such as
[EarlGrey](https://github.com/google/EarlGrey). GTXiLib enhances the value of
your tests by installing "accessibility checks" on them; your existing test
cases can double as accessibility tests with no other code change on your part.
GTXiLib is able to accomplish this by hooking into the test tear-down process
and invoking the registered accessibility checks (such as check for presence of
accessibility label) on all elements on the screen.

## Getting Started

To install GTXiLib on all the tests of a specific test class add the following
snippet of code to it.

```objective-c
// Include the GTXiLib umbrella header.

// Note that that is +setUp not -setUp
+ (void)setUp {
  [super setUp];

  // ... your other setup code (if any) comes here.

  // Create an array of checks to be installed.
  NSArray *checksToBeInstalled = @[
      [GTXChecksCollection checkForAXLabelPresent]
  ];

  // Install GTX on all tests in *this* test class.
  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:checksToBeInstalled
          elementExcludeLists:@[]];
}
```

Once installed, GTX will run all registered accessibility checks before test
case tearDown and fail the test if any accessibility checks fail. With the above
snippet of code your tests will now begin to catch issues where you have added
UI elements to your app but forgot to set accessibility labels on them.

In the above snippet we have only installed `checkForAXLabelPresent`, but you
can also install multiple checks from GTXChecksCollection or include your own
custom checks as well:

```objective-c
// Inside +setUp ...
// Create a new check (for example that ensures that all AX label is not an image name)
id<GTXChecking> myNewCheck =
    [GTXCheckBlock GTXCheckWithName:@"AXlabel is not image name"
                              block:^BOOL(id element, GTXErrorRefType errorPtr) {
    // Ensure accessibilityLabel does not end with .png
    return ![[element accessibilityLabel] hasSuffix:@".png"];
  }];

// Create an array of checks to be installed.
NSArray *checksToBeInstalled = @[
    [GTXChecksCollection checkForAXLabelPresent],
    [GTXChecksCollection checkForAXTraitDontConflict],
    myNewCheck,
];

// Install GTX on all tests in *this* test class.
[GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                     checks:checksToBeInstalled
        elementExcludeLists:@[]];
```

Note that GTX is being added to `+setUp` method, not the instance method
`-setUp` since GTX must only be installed once (for a given test run).

To add GTXiLib to your project use [cocoapods](https://cocoapods.org/pods/GTXiLib).

## Podfile
If installing via CocoaPods, you need to add `GTXiLib` as a dependency in your Podfile. `GTXiLib` only runs in test processes, so do not add it to your main app's spec. Additionally, CocoaPods no longer requires `use_frameworks!`. `use_frameworks!` will cause your build to fail with error `ld: framework not found`. Your Podfile should look like:

```
target 'myapp' do
  # Configuration for app myapp

  # Note the lack of use_frameworks!

  target 'myappTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'GTXiLib'
  end

end
```

## CocoaPods and Swift
GTXiLib supports Swift projects. The installation instructions are almost the same as for Objective-C projects. Your `Podfile` should look like
```
use_modular_headers!
target "NameOfYourProject" do
  pod "GTXiLib"
end
```
with an optional version specifier for "GTXiLib". Note the `use_modular_headers!` line and the **lack** of `use_frameworks!`. As of [CocoaPods 1.5.0](https://blog.cocoapods.org/CocoaPods-1.5.0/), `use_frameworks!` is no longer required for Swift projects. `use_frameworks!` makes `Abseil`, which is a dependency of `GTXiLib`, fail to import properly. Thus, you cannot use `use_frameworks!`, which means you must use `use_modular_headers!`. You may also specify `:modular_headers => true` on a per-pod basis. Then, add `import GTXiLib` to your Swift files, and you can use GTXiLib APIs.

If your project does not contain Swift files, `use_modular_headers!` is optional.

## Incremental Accessibility

GTXiLib APIs support a practical solution for improving accessibility of large
projects which may not have included accessibility from the get-go -- incremental
accessibility. Adding GTXiLib to a project that is already halfway through
development may lead to several test failures and fixing them at once can be
time consuming and tedious. To solve this problem incrementally:

+ Use the above snippet to add GTXiLib to all test cases but fix errors in a small
  subset of them.
  + Exclude elements that you don't control using GTXiLib's excludeList APIs.
+ Then use `GTXTestSuite's` `suiteWithClass:andTests:` method to
  create a test suite with only the tests cases that have been fixed and add
  GTXiLib only to that suite.

Once the code is checked into your repo GTXiLib will catch any new failures in
those tests. From this point:

+ Every new test being added must be added to the suite.
+ Based on team priorities keep moving existing tests into the suite until all
  methods are in the suite.

If at any point all the tests of a test class are in the suite use
`suiteWithAllTestsInClass:` method instead of listing all the methods, this also
ensures that new methods added to the class are automatically under
accessibility checking.

If GTXiLib is installed on every test in your project, use
`suiteWithAllTestsFromAllClassesInheritedFromClass:` to automatically add
accessibility checking to any test case added.

## Authoring your own checks

GTXiLib has APIs that allow for creation of your own accessibility checks (in fact
it does not have to be related to accessibility, for example i18n layout checks
or even memory usage checks). To create new checks use GTXiLib's
`checkWithName:block:` API and provide a unique name and block that evaluates
the check and returns YES/NO for success/failure. Add the newly created check
to the array of checks being passed on to GTXiLib via the install API call.

## Dealing with GTXiLib Failures

When GTXiLib fails it has most likely found an accessibility bug and you must fix
it. But due to various team priorities it may not be possible to do so right
away in which case you have the following options at your disposal:

+ Temporarily exclude the test case by using
  `suiteWithAllTestsInClass:exceptTests:`.
+ Temporarily exclude the offending element using element excludeList APIs.

But if you believe GTXiLib has caught a bug that is not an accessibility issue
please let us know by [filing a bug](https://github.com/google/GTXiLib/issues)
or better [fix it](https://github.com/google/GTXiLib/blob/master/CONTRIBUTING.md)
for everyone.

## Integrating GTXiLib into custom test frameworks

If you are test *framework* author you can use GTXToolKit class to integrate
accessibility checking into your test framework. GTXiLib's own XCTest
integration is also built using the APIs provided by GTXToolKit. Using
GTXToolKit for performing accessibility checks on a given element involves:

1. Creating a GTXToolKit object.
2. Associating a set of checks with it.
3. Use it on the element to be checked.

```objective-c
GTXToolKit *toolkit = [[GTXToolKit alloc] init];

// Register one or more built in checks:
[toolkit registerCheck:[GTXChecksCollection checkForAXLabelPresent]];
[toolkit registerCheck:[GTXChecksCollection checkForAXLabelNotPunctuated]];

// and/or add a couple of your own:
id<GTXChecking> fooCustomCheck =
    [GTXCheckBlock GTXCheckWithName:@"AXlabel is not image name"
                              block:^BOOL(id element, GTXErrorRefType errorPtr) {
    // Check logic comes here...
    return YES;
 }];
[toolkit registerCheck:fooCustomCheck];

// Use the toolkit on an element.
NSError *error;
BOOL success = [toolkit checkElement:someElement error:&error];
if (!success) {
  NSLog(@"Element FAILED accessibility checks! Error: %@",
        [error localizedDescription]);
} else {
  NSLog(@"Element PASSED accessibility checks!");
}
```

GTXToolKit objects can also be applied on a tree of elements by just providing
the root element.

```objective-c
// Use the toolkit on a tree of elements by providing a root element.
NSError *error;
BOOL success = [toolkit checkAllElementsFromRootElements:@[rootElement]
                                                   error:&error];
if (!success) {
  NSLog(@"One or more elements FAILED accessibility checks! Error: %@",
        error);
} else {
  NSLog(@"All elements PASSED accessibility checks!");
}
```

When using `checkAllElementsFromRootElements:`, you may want to ignore some
elements from checks for various reasons, you can do that using GTXToolKit's
`ignore` APIs.

```objective-c
- (void)ignoreElementsOfClassNamed:(NSString *)className;
- (void)ignoreElementsOfClassNamed:(NSString *)className
                     forCheckNamed:(NSString *)skipCheckName;
```

Also, note that `checkAllElementsFromRootElements:` requires an *array* of root
elements, not a single element. The following snippet shows how to run the
checks on all elements on the screen:

```objective-c
// Run the checks on all elements on the screen.
[toolkit checkAllElementsFromRootElements:@[[UIApplication sharedApplication].keyWindow]
                                    error:&error];
```

For full latest reference please refer [GTXToolKit.h](https://github.com/google/GTXiLib/blob/master/Classes/GTXToolKit.h) file.

## Analytics

To prioritize and improve GTXiLib, the framework collects usage data and uploads
it to Google Analytics. More specifically, the framework collects the MD5 hash
of the test app's Bundle ID and pass/fail status of GTXiLib checks. This
information allows us to measure the volume of usage. For more detailed
information about our analytics collection, please peruse the `GTXAnalytics.m`
file which contains the implementation details. If they wish, users can choose
to opt out by disabling the Analytics by adding the following code snippet in
test’s `+(void) setUp` method:

```objective-c
// Disable GTXiLib analytics.
[GTXAnalytics setEnabled:NO];
```

## Discuss

Please join us on the [ios-accessibility](https://groups.google.com/forum/#!forum/ios-accessibility)
Google group to discuss all things accessibility and also to keep a tab on all
updates to GTXiLib.

## Contributors

Please make sure you’ve followed the guidelines in
[CONTRIBUTING.md](./CONTRIBUTING.md) before making any contributions.

*Note: This is not an official Google product.*
