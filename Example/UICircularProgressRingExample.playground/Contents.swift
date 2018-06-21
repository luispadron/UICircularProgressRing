//: UICircularProgressRing Example

import UIKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 300, height: 300)

//: Create and customize the ring as you wish
let progressRing = UICircularProgressRingView(frame: frame)
progressRing.backgroundColor = .white
progressRing.outerRingColor = .blue
progressRing.innerRingColor = .white
progressRing.outerRingWidth = 10
progressRing.innerRingWidth = 8
progressRing.ringStyle = .ontop
progressRing.font = UIFont.boldSystemFont(ofSize: 40)


PlaygroundPage.current.liveView = progressRing

//: Animate with a given duration
progressRing.setProgress(to: 100, duration: 5) {
    // This is called when it's finished animating!

    // We can animate the ring back to another value here, and it does so fluidly
    progressRing.setProgress(to: 80, duration: 2)
}

//: For more information [read the docs](https://goo.gl/JJCHeo)

