GtxChecker is the entry point for running accessibility checks. Understand some
of its features can help you write your own tools or test frameworks that make
use of it. In some situations you may want to disable some checks or add some
of your own, here is how you do it.


### Disabling a *single* check for all elements

```
// 1. Create a settings object with appropriate settings.
GTXSettings *settings = [[GTXSettings alloc] init];
[settings disableCheckWithName:<the check's name> reason:<a reason>];

// 2. Create a checker with the settings object.
GTXChecker *checker = [[GTXChecker alloc] initWithSettings:settings];

// This checker will not check the disabled checks.
```


### Disabling a check for a *single* element

This is currently not supported in Gtx but if think you have a good use case or
are in need of a workaround, please ask on g/ios-accessibility


### Adding custom checks

```
// 1. Create a custom check using GTXCheckBlock
GTXCheckBlock *customCheck =
    [GTXCheckBlock GTXCheckWithName:<unique check name>
                              block:^BOOL(id  _Nonnull element, GTXErrorRefType errorOrNil) {
    // perform checks on the element here...
    // return YES if checks passed NO for failure.
  }];

// 2. Register the new check.
[GTXChecksCollection registerCheck:customCheck];

// 3. Any checkers created next will include the newly registered check.
GTXChecker *checker = [[GTXChecker alloc] initWithSettings:settings];
```


### Custom error reporting

If you use any APIs that take an NSError object and pass nil for the error,
the errors are automatically logged and failures are asserted, to customize the
error reporting simply pass an NSError object and assert on it.

```
NSError *errorObj;
// Assume checker is a valid GTXChecker object.
[checker checkAllElementsFromRootElements:<some root elements> error:&errorObj];
if (errorObj) {
  // Error(s) have occurred process/log errorObj.
} else {
  // All checks have passed
}
```
