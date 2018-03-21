## What is GTXiLib?
GTXiLib, Google Toolbox for Accessibility for the iOS platform or simply GTX-eye
is framework for iOS accessibility testing which can also be embedded into any
tool. GTXiLib has XCTest integration and can be used with any XCTest based
frameworks such as EarlGrey.
GTXiLib enhances the value of your tests by installing "accessibility checks"
on them, your existing test cases can double as accessibility tests with
no other code change on your part. GTXiLib is able to accomplish this by
hooking into the test tear down process and invoking the registered
accessibility checks (such as check for presence of accessibility label) on
all elements on the screen.

## Getting Started

To install GTXiLib on all the tests of a specific test class add the following
snippet of code to it.

```
// Include the GTXiLib umbrella header.
#import <GTXiLib/GTXiLib.h>

// Note that that is +setUp not -setUp
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
case tearDown and fail the test if any accessibility checks fail. Note that code
is being added to `+setUp` method not the instance method `-setUp` since GTX
must only be installed once (for a given test run).

To Add GTXiLib to your project use the xcodeproj file in this project or
[cocoapods](https://cocoapods.org/pods/GTXiLib).

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
please let us know by [filing a bug](https://github.com/google/GTXiLib/issues)
or better [fix it](https://github.com/google/GTXiLib/blob/master/CONTRIBUTING.md)
for everyone.

## Analytics

To prioritize and improve GTXiLib, the framework collects usage data and uploads
it to Google Analytics. More specifically, the framework collects the MD5 hash
of the test app's Bundle ID and pass/fail status of GTXiLib checks. This
information allows us to measure the volume of usage. For more detailed
information about our analytics collection, please peruse the `GTXAnalytics.m`
file which contains the implementation details. If they wish, users can choose
to opt out by disabling the Analytics by adding the following code snippet in
test’s `+(void) setUp` method:

```
// Disable GTXiLib analytics.
[GTXAnalytics setEnabled:NO];
```

*Note: This is not an official Google product.*
