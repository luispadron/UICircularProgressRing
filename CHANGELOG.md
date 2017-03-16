# Version 1.4.0

- Remove the `fontSize` and `customFontWithName` properties
- Add new `font` property of type `UIFont` to handle all font related configuration
- Update documentation to include changes

#### Breaking API Changes in 1.4.0

- Since no longer using `fontSize` or `customFontWithName` any projects using these properties will break until updated to newer `font` and to use `UIFont`. 
- Any interface builder views which used `fontSize` or `customFontWithName` will now complain about breaking. To fix this simply go into the class inspector of the view, under `User Defined Run Time Attributes` remove any of the `fontSize` or `customFontWithName` values. Then refresh the views by doing `Editor -> Refresh Views`

__Why was this done?__

This made sense to do because it was slightly confusing how to accomplish fonts and interface builder since apple does not add support for `IBDesignable` fonts. I've decided to sacrifice the interface builder support for code only font management, because this leads to safer use of fonts since the view is no longer handeling the creation of `UIFont` itself. This also adds more customization to the view since previously you could only change the font size and font. Now users can do whatever is allowed with UIFont, such as using defined font families, etc.

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

- Remove overriden `draw(rect:)` method to avoid any issues with performance and iOS drawing
	- Implemented `prepareForInterfaceBuilder` to still allow for IB designing

- Remove strong refrence to delegate
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

- Lower podspec for compatability with iOS 8.0
- Lower project deployment target to 8.0

# Version 1.1.5

Fix inaccesible ring value thanks to [@DaveKim](https://github.com/davekim)

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
