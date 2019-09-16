<p align="center">
	<img src="https://img.shields.io/github/license/luispadron/UICircularProgressRing.svg">
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

* 2 views, progress or timer
* Interface builder designable
* Highly customizable and flexible
* Easy to use
* Fluid and interruptible animations
* Written in Swift
* RTL language support

## Apps Using UICircularProgressRing

- [GradePoint](http://gradepoint.luispadron.com) by Luis Padron.

- [UVI Mate](https://itunes.apple.com/us/app/uvi-mate-global-uv-index-now/id1207745216?mt=8) by Alexander Ershov.

- [HotelTonight](https://itunes.apple.com/app/id407690035?mt=8) by Hotel Tonight Inc.

- [הנתיב המהיר](https://itunes.apple.com/us/app/הנתיב-המהיר/id1320456872?mt=8) by Elad Hayun

- [Nyx Nightclub Management](https://itunes.apple.com/dk/app/nyx-nightclub-management-ipad/id954874082?mt=8) by Nyx Systems IVS

- [Barstool Sports](https://itunes.apple.com/us/app/barstool-sports/id456805313) by Barstool Sports

- [88 Days](http://88-days.com) by Stijn Kramer

- [Bookbot](https://www.bookbotkids.com) by Bookbot

## Installation

*NOTE: Objective-C support: Support for Objective-C has been dropped in version 5.0.0, use version 4 or lower if you are using Objective-C.*

⚠️ **There is currently work being done to re-write this library in SwiftUI, check out [features/swift-ui](https://github.com/luispadron/UICircularProgressRing/tree/features/swift-ui) branch for more info!** ⚠️

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

### UICircularProgressRing Example

```swift
override func viewDidLoad() {
  // Create the view
  let progressRing = UICircularProgressRing()
  // Change any of the properties you'd like
  progressRing.maxValue = 50
  progressRing.style = .dashed(pattern: [7.0, 7.0])
  // etc ...
}
```

To set a value and animate the view

```swift
// Somewhere not in viewDidLoad (since the views have not set yet, thus cannot be animated)
// Remember to use unowned or weak self if referencing self to avoid retain cycle
progressRing.startProgress(to: 49, duration: 2.0) {
  print("Done animating!")
  // Do anything your heart desires...
}

// Pause at any time during a running animation
progressRing.pauseProgress()

// Continue where you left off after a pause
progressRing.continueProgress()
```

### UICircularTimerRing Example

```swift
override func viewDidLoad() {
	// create the view
	let timerRing = UICircularTimerRing()
}
```

Animate and set time

```swift
						// seconds
timerRing.startTimer(to: 60) { state in
    switch state {
    case .finished:
        print("finished")
    case .continued(let time):
        print("continued: \(time)")
    case .paused(let time):
        print("paused: \(time)")
    }
}

timerRing.pauseTimer() // pauses the timer

timerRing.continueTimer() // continues from where we paused

timerRing.resetTimer() // resets and cancels animations previously running
```

## Documentation

Please **read** this before creating an issue about how to use the library:

[DOCUMENTATION](https://htmlpreview.github.io/?https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/docs/Classes/UICircularProgressRing.html)

## Misc.

Do you use this library? Want to be featured? Go [here.](https://github.com/luispadron/UICircularProgressRing/issues/54)
