## UICircularProgressRing - SwiftUI Branch

### Overview

This is the [Swift-UI](https://developer.apple.com/documentation/swiftui) branch for the UICircularProgressRing library, currently in very early stages of development. The idea behind this branch and major change to the library is to re-write the library using only SwiftUI features and components. This also involves rewriting the API to better match how Apple's own SwiftUI views operate. This branch is **not** meant to simply wrap every class in `UIViewRepresentable` and call it a day.

**TL;DR:** re-write the library in pure SwiftUI and hopefully get sexy code that looks like this:

```swift
struct MyView: View {
    @State var progressRingValue = 0.0

    var body: some View {
        ProgressRing(progress: $progressRingValue)
            .labelStyle(.init(font: .title, textColor: .red))
            .labelFormatter(CustomFormatter())
            .ringColors(outer: .blue, inner: .green)
            .onAppear {
                 withAnimation(.easeIn(duration: 4)) {
                    self.progressRingValue = 100
                 }
            }
    }
}
```

### Things to expect

- Breaking changes
- Missing features
- Minimal/no documentation
- Bugs (lots)

### Installing

Using Xcode 11, installation is rather simple:

1. Add the package as a dependency
	- `File -> Swift Packages -> Add Package Dependency`
	- Paste this URL `https://github.com/luispadron/UICircularProgressRing/`
	- Select `branch`
	- Choose the `features/swift-ui` branch
2. `import UICircularProgressRing` to use within any Swift-UI code
3. Look at [Sources/SwiftUI](https://github.com/luispadron/UICircularProgressRing/tree/features/swift-ui/Sources/UICircularProgressRing/SwiftUI) for "documentation"

### Getting involved

If you would like to help out in the development of this libraries transition to Swift-UI, please feel free to contact me. The best thing you can do to help is to simply test the project.