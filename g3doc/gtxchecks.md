# Gtx Checks
This doc is go/all-gtx-checks.

All Gtx checks are designed with the following constraints:

* Gtx check failures are 100% repeatable.
* Fixing Gtx checks will lead to better GAR score.
* Fixing Gtx checks will lead to a more accessible iOS App.
* All failing Gtx checks will log helpful info on how to fix it.

If you find an Gtx check that does not satisfy the above please notify us at
ios-accessibility@google.com

Currently Gtx has support for the following checks:

## 1. kGTXCheckNameAccessibilityLabelPresent
This check verifies that all the accessibility elements in the UI have a non-nil accessibility
label.

## 2. kGTXCheckNameAccessibilityLabelNotPunctuated
This check that verifies that the accessibility labels on non-text elements are not punctuated
(i.e. they do not end with a period). A good example of non-text element is a button.

## 3. kGTXCheckNameAccessibilityTraitsDontConflict
This check that verifies that the accessibility elements in the UI do not have any
accessibilityTraits that conflict with each other. The following sets traits are mutually exclusive
and cannot be used together:

* Set 1
  * UIAccessibilityTraitButton
  * UIAccessibilityTraitLink
  * UIAccessibilityTraitSearchField
  * UIAccessibilityTraitKeyboardKey
* Set 2
  * UIAccessibilityTraitButton
  * UIAccessibilityTraitAdjustable

## 4. kGTXCheckNameMinimumTappableArea
This check that verifies that the accessibility elements have a minimum tappabel area (as defined
by accessibility frame) of 48X48. NOTE that this check is available under GTXSystemVersionLatest not
GTXSystemVersionStable.

## 5. kGTXCheckNameMinimumContrastRatio
This check that verifies that text elements have a minimum contrast ratio of 1:3 against their
background. NOTE that this check is available under GTXSystemVersionLatest not
GTXSystemVersionStable.

## Other Checks
While Gtx is scanning the UI it also verifies if the the App uses `accessibilityElements` selector
and `accessibilityElementAtIndex` consistently, i.e. any given element must either use only one
of the APIs to provide accessibility children or must provide the same set of elements from both
the APIs.
