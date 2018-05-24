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
* RTL language support

## Apps Usig UICircularProgressRing

- [GradePoint](http://gradepoint.luispadron.com) by Luis Padron.

- [UVI Mate](https://itunes.apple.com/us/app/uvi-mate-global-uv-index-now/id1207745216?mt=8) by Alexander Ershov.

- [HotelTonight](https://itunes.apple.com/app/id407690035?mt=8) by Hotel Tonight Inc.

- [הנתיב המהיר](https://itunes.apple.com/us/app/הנתיב-המהיר/id1320456872?mt=8) by Elad Hayun

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

## Example project

Take a look at the example project over [here](https://github.com/luispadron/UICircularProgressRing/tree/master/Example)

1. Download it
2. Open the `Example.xcworkspace` in Xcode
3. Mess around and experiment!
