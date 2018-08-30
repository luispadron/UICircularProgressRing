<p align="center">
	<img src="https://img.shields.io/github/license/luispadron/UICircularProgressRing.svg">
	<img src="https://img.shields.io/cocoapods/dt/UICircularProgressRing.svg">
	<img src="https://travis-ci.org/luispadron/UICircularProgressRing.svg?branch=master">
	<img src="https://img.shields.io/github/issues/luispadron/UICircularProgressRing.svg">
</p>

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
* Fluid and interruptible animations
* Written in Swift
* RTL language support

## Apps Usig UICircularProgressRing

- [GradePoint](http://gradepoint.luispadron.com) by Luis Padron.

- [UVI Mate](https://itunes.apple.com/us/app/uvi-mate-global-uv-index-now/id1207745216?mt=8) by Alexander Ershov.

- [HotelTonight](https://itunes.apple.com/app/id407690035?mt=8) by Hotel Tonight Inc.

- [הנתיב המהיר](https://itunes.apple.com/us/app/הנתיב-המהיר/id1320456872?mt=8) by Elad Hayun

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

#### Important: Interface builder support with Carthage is either broken or extremely limted

To use with [Carthage](https://github.com/Carthage/Carthage)

1. Make sure Carthage is installed

	`brew install carthage`
2. Add this repo to your Cartfile

	`github "luispadron/UICircularProgressRing"`
3. Install dependencies
	`carthage update --platform iOS`

## Usage

### Interface Builder

Simply drag a `UIView` into your storyboard. Make sure to subclass `UICircularProgressRing` and that the module points to `UICircularProgressRing`.

Design your heart out

![ib-demo.gif](https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/ib-demo.gif)

### Code

```swift
override func viewDidLoad() {
  // Create the view
  let progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
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
progressRing.startProgress(to: 49, duration: 2.0) {
  print("Done animating!")
  // Do anything your heart desires...
}

// Pause at any time during a running animation
progressRing.pauseProgress()

// Continue where you left off after a pause
progressRing.continueProgress()
```

## Documentation

Please read this before creating an issue about how to use the package:

[DOCUMENTATION](https://htmlpreview.github.io/?https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/docs/Classes/UICircularProgressRing.html)

## Example project

Take a look at the example playground over [here](Example/)

1. Download it
2. Mess around and experiment!

## Misc.

Do you use this library? Want to be featured? Go [here.](https://github.com/luispadron/UICircularProgressRing/issues/54)
