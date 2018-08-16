//: UICircularProgressRing Example

import UIKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 300, height: 300)

//: Create and customize the ring as you wish
let progressRing = UICircularProgressRing(frame: frame)
progressRing.backgroundColor = .white
progressRing.outerRingColor = .blue
progressRing.innerRingColor = .white
progressRing.outerRingWidth = 10
progressRing.innerRingWidth = 8
progressRing.ringStyle = .ontop
progressRing.font = UIFont.boldSystemFont(ofSize: 40)

PlaygroundPage.current.liveView = progressRing

//: Animate with a given duration
progressRing.startProgress(to: 100, duration: 6) {
    // This is called when it's finished animating!

    DispatchQueue.main.async {
        // We can animate the ring back to another value here, and it does so fluidly
        progressRing.startProgress(to: 80, duration: 2)
    }
}

//: Pause and continue animations dynamically
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    progressRing.pauseProgress()
    //: Customize the ring even more
    progressRing.showsValueKnob = true
    progressRing.valueKnobSize = 20
    progressRing.valueKnobColor = .green

}

//: Continue the animation whenever you want
DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    progressRing.continueProgress()
}

//: For more information [read the docs](https://goo.gl/JJCHeo)
