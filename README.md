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

		pod 'UICircularProgressRing', :git => 'https://github.com/luispadron/UICircularProgressRing'
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

1. Simply download the `UICircularProgressRingView.swift` and the `UICircularProgressRingDelegate.swift` from [here](https://github.com/luispadron/UICircularProgressRing/tree/master/UICircularProgressRing) into your project, make you point to your projects target

## Usage

### Interface Builder

Simply drag a `UIView` into your storyboard. Make sure to subclass `UICircularProgressRingView` and that the module points `UICircularProgressRing`. 

Design your heart out

[ib-demo.gif](/GitHubAssets/ib-demo.gif)

### Code

```swift
# Create the view
let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
# Assign the delegate
progressRing.delegate = self
# Add the view as a subview or whatever else you would like to do
```

To set a value and animate the view

```swift
progressRing.setProgress(value: 83, animated: true)
```

**Read the documentation [HERE](DOCUMENTATION.md)**

