![Banner](/.github/banner.png)

<h3 align="center">A circular progress bar for iOS written in Swift 3</h3>

<p align="center">
<img src="/.github/demo.gif"/>  
</p>

![Styles](/.github/styles-banner.png)

### Looking for people to help maintain and contribute, email me [here](mailto:luis@luispadron.com)

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

__Note:__ If you have any issues with Swift 3 and CocoaPods you can try to force the version. (Cocoapods support for Swift 3 projects has been a bit wonky).

Add this to the end of your `Podfile`

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "3.0"
    end
  end
end
```

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

![ib-demo.gif](/.github/ib-demo.gif)

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


## License

```
Copyright (c) 2016 Luis Padron

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
