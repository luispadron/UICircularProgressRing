# Version 4.1.0

- Fix issues with border drawing and crashes related to it.
  Thanks to [@abdulla-allaith](https://github.com/abdulla-allaith) for the PR!

# Version 4.0.0

- Migrate to Swift 4.2, thanks to [@chirs-redbeed](https://github.com/chris-redbeed) for initial migration

## Breaking API Changes:

- Rename `animationStyle` to `animationTimingFunction`. Now uses new `CAMediaTimingFunctionName` enum instead of unsafe String.

# Version 3.3.2

- Add check for `value` being set greater than `maxValue`
  Thanks to [@byronsalty](https://github.com/byronsalty) for the PR!

# Version 3.3.1

- Fixes more issues with pause/continue progress logic.
  Thanks to [@nickdnk](https://github.com/nickdnk) for the PR!

# Version 3.3.0

- Fixes issues with inconsisten API. The `pauseProgress()` and `resetProgress()`
  now work as expeted/intended. When calling `pauseProgress()`, the completion
  on the `startProgress` function wont be called until it's actually been completed.
  When calling `resetProgress` the completion for `startProgress` is discarded and
  will no longer be called, since the ring has not actually completed (same with delegate).

  Thanks a lot to [@MileyHollenberg](https://github.com/MileyHollenberg) for these fixes!

# Version 3.2.0

- Add new ring style `bordered` thanks to [@abdulla-allaith](https://github.com/abdulla-allaith)!

# Version 3.1.0

- Adds three new properties for more fine grained control of the
  progress knob. `valueKnobShadowBlur`, `valueKnobShadowOffset`, and `valueKnobShadowColor`.
  Thanks to [@xismic](https://github.com/xismic) for the contribution!

# Version 3.0.0

### Tons of new features and improvements!

- Add new properties `showsValueKnob`, `valueKnobColor`, and `valueKnobSize`
  as requested by [#97](https://github.com/luispadron/UICircularProgressRing/issues/97)
- Add new `continueProgress` and `pauseProgress` functions which allow fluid continuation
  and pausing of progress animations.
- Add new delegate functions `didPauseProgress`, and `didContinueProgress`
- Tons of refactoring and renaming of properties/functionality

### Breaking API Changes

**Lots** please refer to the documentation to get your code up to spec with
version 3.0.0

# Version 2.2.0

- Add new `isClockwise` property which allows users of the library to
set whether or not the ring should rotate in a clockwise fashion.

Thanks to [@petewalker](https://github.com/petewalker) for adding this!

# Version 2.1.3

- Add example playground, remove old example workspace

# Version 2.1.2

- Enable app-extension safe API

# Version 2.1.1

- Build with Swift 4.1.2

# Version 2.1.0

Add right-to-left language support, thanks [eladhayun](https://github.com/eladhayun).

- New property `rightToLeft` which when set to true will display the ring with RTL language support, for example when `rightToLeft = true`, the progress will be `GB 100` instead of `100 GB`.

# Version 2.0.0

Add feature requested in [#86](https://github.com/luispadron/UICircularProgressRing/issues/86) and general clean up and refactoring of API.

- Add new `ring` paramater to functions `didUpdateProgressValue` and `willDisplayLabel` so that they can be used with multiple rings if needed.

## Breaking API Changes

- `finishedUpdatingProgress(forRing:)` now changed to `finishedUpdatingProgress(for:)`
- `didUpdateProgressValue(to:)` now changed to `didUpdateProgressValue(for:to:)`
- `willDisplayLabel(label:)` now changed to `willDisplayLabel(for:_:)`
- `setProgress(value:animationDuration:completion:)` now changed to `setProgress(to:duration:completion:)`

# Version 1.8.5

- Build project with Swift 4.1

# Version 1.8.4

- Mark delegate methods as `@objc optional` to allow default or optional conformance, thanks to [@AbelToy](https://github.com/AbelToy)

# Version 1.8.3

- Fix issue with `@objc` and new `willDisplayLabel` method in `UICircularProgressRingDelegate`.

# Version 1.8.2

- Add ability to modify ring label before drawing, thanks to [@hohteri](https://github.com/hohteri)

# Version 1.8.1

- Fix bug with not checking `shouldAnimateProperties` in the progress ring layer.

# Version 1.8.0

Add new `animateProperties(duration:animations:completion:)` method.

This allows you to animate any of the animatable properties of the `UICircularProgressRing`, which currently are: `innerRingColor`, `innerRingWidth`, `outerRingColor`, `outerRingWidth`, `innerRingSpacing`, `fontColor`.

Example usage:

```swift
self.ring.animateProperties(duration: 1.5) {
	// Animate things here
	self.ring.innerRingColor = .purple
	self.ring.outerRingColor = .blue
}
```

# Version 1.7.7

Add Objective-C support, thanks to [@hohteri](https://github.com/.hohteri)

# Version 1.7.6

Add Carthage Interface Builder support, thanks to [@AbelToy](https://github.com/abeltoy).

# Version 1.7.5

- Add fix for progress ring requiring square frame
- Fix issue where height was set to width.
- Use min between height and width to calculate radius for both outer
    and inner ring

# Version 1.7.4

- Code optimization & Added missing test cases
- Refactored test cases to also test UICircularProgressRingLayer.
- Add missing test cases for new gradient members.
- Add explicit typing to local variables in order to speed up compilation.
- Add new Swift compiler flags to warn about long function/type inference compilation.

# Version 1.7.3
- Improved calculations for inner ring angle.
	- Thanks to [@jeffro256](https://github.com/jeffro256) for committing.

# Version 1.7.2

- Add `s.ios.deployment_target = "8.0"` to Podspec, thanks to [@younatics](https://github.com/younatics)

# Version 1.7.1

- Fix issue where outer ring width couldn't be smaller than inner ring width.
Thanks to: [SwiftTsubame](https://github.com/SwiftTsubame) for the contribution.

# Version 1.7.0

#### Highlight: New `UICircularProgressRingView.minValue` property.

- Add ability to set a range of values for the ring, unlike before where only `maxValue` could be set. You can now use the new `minValue` to specify a range that the value can fall between. Read the docs to learn about any issues that may arise with setting a `value` less than `minValue`.
- Fixed bugs related to how many degrees the inner ring for the progress ring draws. Everything should exact now even if not using the `fullCircle` property.
- Fixed a bug which allowed setting a `value` less than zero. Read the docs to learn why this was an issue.
- Refactored some unused code and tidied things up a bit
- Regenerated documentation using Jazzy


# Version 1.6.2

#### Highlight: New `UICircularProgressRingDelegate` method.

- New method in `UICircularProgressRingDelegate `, `didUpdateProgressValue(to newValue: CGFloat)`, which can be used to get notified of value changes to the progress ring in real time. As the documentation states, this is a very hot method and it may be called hundreds of times per second, thus only very minimal work should be performed in this method.

# Version 1.6.1

- Make sure `.swift-version` is included in pod, in order to fix issue with Xcode 9

# Version 1.6.0

#### Highlight: Updated for Xcode 9 and Swift 4

- Updated project settings to recommended Xcode settings
- Updated language to Swift 4
- Updated `@objc inference` to `default`

# Version 1.5.5

#### Highlight: New Progress ring style `gradient` added!

- Added new progress ring style `gradient` which allows for drawing a gradient inner ring given some colors.
- Added 4 new properties to `UICircularProgressRingView` which are used to determine the look of the gradient when drawing
- Added new enumeration type `UICircularProgressRingGradientPosition` to determine position of gradient for drawing purposes
- Updated docs to reflect these new changes

##### Breaking changes in 1.5.5

None!

# Version 1.5.0

#### Highlight:  Major refactoring and making properties safer/easier to use.

- Refactored the `ringStyle` property to `ibRingStyle` and made unavailable for use with code (see below)
-  Refactored `outerRingCapStyle`,  and `innerRingCapStyle` into new properties and made them unavailable for code use. As these properties will only be used for interface builder, while I patiently wait for Apple to allow enums in IBInspectable properties
- Added new `ringStyle` which uses new type `UICircularProgressRingStyle` enum to make it easier and safer to assign a style to the progress ring
- Added new `outCapStyle` and `inCapStyle` enum properties of type `CGCapStyle` which again, allow for easer and safer assignment of progress ring cap styles in code.
- Refactored most of the source code to maintain a max line width of 80, cause I'm insane like that
- Updated documentation

##### Breaking Changes in 1.5.0

Due to the refactoring, any code which previously used these properties will have to use the new enumerations provided (sorry).

Also, since the `ringStyle` property was changed to `ibRingStyle` then any customized ring style inside of Interface Builder will need to be updated to use the new property, you may see a warning from interface builder. To fix these warnings: Go into the class inspector of the view, under `User Defined Run Time Attributes` remove any of the `ringStyle` values. Then refresh the views by doing `Editor -> Refresh Views`



# Version 1.4.3

- Fix deprecation warning in new Xcode version from using `M_PI`

# Version 1.4.2

- Add new `fullCircle` property to the `UICircularProgressRingView`. Which removes the confusion of setting a valid end angle. For example previously if you wanted a full circle and you wanted the progress to start from the top you could do `startAngle = -90` however this would also require you to subtract 90 from the end angle, since the default is 360. This was not fully understood by some users. Now you have the option using `fullCircle` to set and forget the `startAngle` and the `endAngle` will automagically be corrected for you, thus always giving you a full circle with your desired start angle.
- Update some Xcode unit tests
- Update documentation to include new `fullCircle` property

#### Breaking changes in 1.4.2

With the addition of the `fullCircle` property which is `true` by default anyone who was using a non-circular progress ring will see that their progress ring is now circular. To fix this either set `fullCircle` to `false` via code or go into interface builder and toggle `Full Circle` to `Off`.

# Version 1.4.1

- Fix bug where the default `valueIndicator` _'%'_ - was not set on initialization

#### Breaking API Changes in 1.4.1

Nothing really, but previously if you had not set the `valueIndicator` property then there would be no value indicator shown to the right of the value. This was not intended and has been fixed in this release. If you prefer to have no value indicator, you must now explicitly set the property to empty

```swift
ring.valueIndicator = ""
```

# Version 1.4.0

- Remove the `fontSize` and `customFontWithName` properties
- Add new `font` property of type `UIFont` to handle all font related configuration
- Update documentation to include changes

#### Breaking API Changes in 1.4.0

- Since no longer using `fontSize` or `customFontWithName` any projects using these properties will break until updated to newer `font` and to use `UIFont`.
- Any interface builder views which used `fontSize` or `customFontWithName` will now complain about breaking. To fix this simply go into the class inspector of the view, under `User Defined Run Time Attributes` remove any of the `fontSize` or `customFontWithName` values. Then refresh the views by doing `Editor -> Refresh Views`

__Why was this done?__

This made sense to do because it was slightly confusing how to accomplish fonts and interface builder since apple does not add support for `IBDesignable` fonts. I've decided to sacrifice the interface builder support for code only font management, because this leads to safer use of fonts since the view is no longer handleing the creation of `UIFont` itself. This also adds more customization to the view since previously you could only change the font size and font. Now users can do whatever is allowed with UIFont, such as using defined font families, etc.

# Version 1.3.0

- Add a property for accessing the current value of the progress ring while animating, closes [issue #14](https://github.com/luispadron/UICircularProgressRing/issues/14)
- Add fix for removing a currently running animation when calling `setProgress(:)` while ring is animating, closes [issue #19](https://github.com/luispadron/UICircularProgressRing/issues/19)
- Fixed access levels for variables and functions, changed from `public` to `open` to allow subclassing.
- Updated `docs` by running Jazzy


# Version 1.2.2

- Remove useless print statements from guards

# Version 1.2.1

- Fix line dash property when using `viewStyle = 3` not being set properly, thanks to [RomainBSQT](https://github.com/RomainBSQT).

# Version 1.2.0


- Default completion handler to nil for `setProgress(:)`
- Fix issue with module version number, now actually supports __iOS 8__
- Added some basic tests for right now
- Refactor some comments
- Remove `private` access, set to `internal` for unit testing
- Fix default with inCapStyle being sett to wrong value

# Version 1.1.9


- Revert back to using `draw(rect:)` as was having issues with nib loaded views?
- Change class of UICircularProgressRingLayer from `CALayer` to `CAShapeLayer`

# Version 1.1.8

- Remove overridden `draw(rect:)` method to avoid any issues with performance and iOS drawing
	- Implemented `prepareForInterfaceBuilder` to still allow for IB designing

- Remove strong reference to delegate
    - UICircularProgressRingDelegate is now a class protocol
    - UICircularProgressRingDelegate inside of UICircularProgressRingView is now weak to avoid retain cycle

#### BREAKING CHANGES:

- UICircularProgressRingDelegate is now a `protocol: class` can only be used on `class` types

# Version 1.1.7

Fix bug where progress bar was pixelated inside of tableView from [issue #4](https://github.com/luispadron/UICircularProgressRing/issues/4)

Thanks to [@DeepAnchor](https://github.com/DeepAnchor) for the fix!

- Default background color for view and layer is now of `UIColor.clear`

# Version 1.1.6

Lower required iOS version to iOS 8.0

- Lower podspec for compatibility with iOS 8.0
- Lower project deployment target to 8.0

# Version 1.1.5

Fix inaccessible ring value thanks to [@DaveKim](https://github.com/davekim)

- Update delegate method parameters for more Swift like method names/parameters
- Update Xcode project to recommended settings

### API Changes:

Delegate method renamed to: `func finishedUpdatingProgress(forRing ring: UICircularProgressRingView)` (this is the last time, I swear)

# Version 1.1.4

Add isAnimating to UICircularProgressRingView

- Added new property to determine whether ring is animating currently
- Fix some typos
- Made completion handler default to nil
- Refactor delegate method call to look more Swifty

## Breaking API Changes:

Delegate method renamed to: `func finishedUpdatingProgress(forRing: UICircularProgressRingView)`

# Version 1.0.0

### Hugh Mungus changes

- Refactor code into two separate files (UICircularProgressRingView, and UICircularProgressRingLayer)
- Fix animation, now works smoothly both increasing and decreasing
- More stability in terms of not causing a crash due to RunLoop
- More documentation
- ITS READY
