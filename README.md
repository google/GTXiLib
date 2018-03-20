## What is GTXiLib?
GTXiLib (spelled GTX eye lib) is library of APIs for iOS accessibility testing
that can be easily embedded into any test framework or tool, for example it has
XCTest integration and can be used with EarlGrey. GTXiLib works by installing
"checks" on your existing test cases so that before test teardown the checks are
evaluated on your app to look for accessibility issues such as missing labels.

## Getting Started

To install GTXiLib on all the tests of a specific test class add the following
snippet of code to it.

```
// Include the GTXiLib umbrella header.
#import <GTXiLib/GTXiLib.h>

+ (void)setUp {
  [super setUp];

  // ... your other setup code (if any) comes here.

  // Install GTX on all tests in *this* test class.
  [GTXiLib installOnTestSuite:[GTXTestSuite suiteWithAllTestsInClass:self]
                       checks:[GTXChecksCollection allGTXChecks]
            elementBlacklists:@[]];
}
```

Once installed, GTX will run all registered accessibility checks before test
case tearDown and fail the test if any accessibility checks fail. Note that GTX
is being added to `+setUp` method not the instance method `-setUp` since GTX
must only be installed once (for a given test run).

## Incremental Accessibility

GTXiLib APIs support a practical solution for improving accessibility of large
projects which may not have included accessibility from the get go - incremental
accessibility. Adding GTXiLib to a project that is already halfway through
development may leads to several test failures and fixing them at once can be
time consuming and tedious. To solve this problem incrementally:

+ Use above snippet to add GTXiLib to all test cases but fix errors in a small
  subset of them.
  + Blacklist elements that you don't control using GTXiLib's blacklist APIs.
+ Then use `GTXTestSuite's` `suiteWithClass:andTests:` method to
  create a test suite with only the tests cases that have been fixed and add
  GTXiLib only to that suite.

Once the code is checked into your repo GTXiLib will catch any new failures in
those tests. From this point:

+ Every new test being added must be added it to the suite.
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
or even memory usage checks). To create new checks use `GTXiLib's`
`checkWithName:block:` API and provide a unique name and block that evaluates
the check and returns YES/NO for success/failure. Add the newly created check
to the array of checks being passed on to GTXiLib via the install API call.

## Dealing with GTXiLib Failures

When GTXiLib fails it has most likely found an accessibility bug and you must fix
it. But due to various team priorities it may not be possible to do so right
away in which case you have the following options at your disposal:

+ Temporarily blacklist the test case by using
  `suiteWithAllTestsInClass:exceptTests:`.
+ Temporarily blacklist the offending element using element blacklist APIs

But if you believe GTXiLib has caught a bug that is not an accessibility issue
please let us know by [filing a bug](TODO) or better [fix it](TODO) for
everyone.

## Analytics

To prioritize and improve GTXiLib, the framework collects usage data and uploads
it to Google Analytics. More specifically, the framework collects the MD5 hash
of the test app's Bundle ID and pass/fail status of GTXiLib checks. This
information allows us to measure the volume of usage. For more detailed
information about our analytics collection, please peruse the `GTXAnalytics.m`
file which contains the implementation details. If they wish, users can choose
to opt out by disabling the Analytics by adding the folling code snippet in
test’s `+(void) setUp` method:

```
// Disable GTXiLib analytics.
[GTXAnalytics setEnabled:NO];
```

*Note: This is not an official Google product.*
