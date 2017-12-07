![Banner](https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/banner.png)

<h3 align="center">A circular progress bar for iOS written in Swift</h3>

<p align="center">
<img src="https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/demo.gif"/>  
</p>

![Styles](https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/styles-banner.png)

## Features

* Interface builder designable
* Highly customizable and flexible
* Easy to use
* Sleek animations
* Written in Swift

## Apps Usig UICircularProgressRing

- [GradePoint](http://gradepoint.luispadron.com) by Luis Padron. 

- [UVI Mate](https://itunes.apple.com/us/app/uvi-mate-global-uv-index-now/id1207745216?mt=8) by Alexander Ershov.

## Installation 

### CocoaPods (Recommended)

1. Install [CocoaPods](https://cocoapods.org)
2. Add this repo to your `Podfile`

	```ruby
	target 'Example' do
		# IMPORTANT: Make sure use_frameworks! is included at the top of the file
		use_frameworks!

		pod 'UICircularProgressRing'
	end
	```
3. Run `pod install`
4. Open up the `.xcworkspace` that CocoaPods created
5. Done!

### Carthage

**_Important note_: Carthage support for IBDesignable and IBInspectable is broken due to how frameworks work.
So if you decide on using Carthage, you will not be able to use IB to design this view.
Take a look [here](https://github.com/Carthage/Carthage/issues/335) for the issue.**

To use with [Carthage](https://github.com/Carthage/Carthage)

1. Make sure Carthage is installed 
	
	`brew install carthage`
2. Add this repo to your Cartfile

	`github "luispadron/UICircularProgressRing"` 
3. Drag the `UICircularProgressRing.framework` from `MyProjDir/Carthage/Builds/iOS/UICircularProgressRing` into the `General -> Embeded Binaries` section of your Xcode project.

### Manually

1. Simply download the `UICircularProgressRingView.swift`, `UICircularProgressRingLayer.swift` and `UICiruclarProgressRingDelegate.swift` files from [here](https://github.com/luispadron/UICircularProgressRing/tree/master/UICircularProgressRing) into your project, make sure you point to your projects target

## Usage

### Interface Builder

Simply drag a `UIView` into your storyboard. Make sure to subclass `UICircularProgressRingView` and that the module points `UICircularProgressRing`. 

Design your heart out

![ib-demo.gif](https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/ib-demo.gif)

### Code

```swift
override func viewDidLoad() {
  // Create the view
  let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
  // Change any of the properties you'd like
  progressRing.maxValue = 50
  progressRing.innerRingColor = UIColor.blue
  // etc ...
}
```

To set a value and animate the view

```swift
// Somewhere not in viewDidLoad (since the views have not set yet, thus cannot be animated)
// Remember to use unowned or weak self if refrencing self to avoid retain cycle
progressRing.setProgress(value: 49, animationDuration: 2.0) {
  print("Done animating!")
  // Do anything your heart desires...
}
```

## Documentation

Please read this before creating an issue about how to use the package:

[DOCUMENTATION](https://htmlpreview.github.io/?https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/docs/Classes/UICircularProgressRingView.html)

## Example project

Take a look at the example project over [here](Example/)

1. Download it
2. Open the `Example.xcworkspace` in Xcode
3. Mess around and experiment!

## Misc.

Do you use this library? Want to be featured? Go [here.](https://github.com/luispadron/UICircularProgressRing/issues/54)
