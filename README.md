![Banner](/GitHubAssets/banner.png)

<h3 align="center">A circular progress bar for iOS written in Swift 3</h3>

<p align="center">
<img src="/GitHubAssets/demo.gif"/>  
</p>

![Styles](/GitHubAssets/styles-banner.png)

## Features

* Interface builder designable
* Highly customizable 
* Animation for progress and value text built in
* Written in Swift 3 and using Xcode 8

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

1. Simply download the `UICircularProgressRingView.swift` and the `UICircularProgressRingDelegate.swift` from [here](https://github.com/luispadron/UICircularProgressRing/tree/master/UICircularProgressRing) into your project, make sure you point to your projects target

## Usage

### Interface Builder

Simply drag a `UIView` into your storyboard. Make sure to subclass `UICircularProgressRingView` and that the module points `UICircularProgressRing`. 

Design your heart out

![ib-demo.gif](/GitHubAssets/ib-demo.gif)

### Code

```swift
override func viewDidLoad() {
  // Create the view
  let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
  // Change any of the properties you'd like
  progressRing.maxValue = 50
  progressRing.innerRingColor = UIColor.blue
  progressRing.animationDuration = 3.0
  // etc ...
}
```

To set a value and animate the view

```swift
// Somewhere not in viewDidLoad (since the views have not set yet, thus cannot be animated)
progressRing.setProgress(value: 49, animated: true) {
  // The closure 
  print("Done animating!")
}
```

## Documentation

Read all about everything there is to know here:

[DOCUMENTATION](http://htmlpreview.github.io/?https://github.com/luispadron/UICircularProgressRing/blob/master/docs/index.html)

## Example project

Take a look at the example project over [here](Example/)

## Upcoming enhancements

* Add decreasing animation, currently nothing gets animated when decreasing value
* Better way of handling animation finishing, probably a completion block

## License

```
Copyright (c) 2016 Luis Padron

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
