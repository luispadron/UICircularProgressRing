//
//  ViewController.swift
//  pruebasCircularProgress
//
//  Created by sistemas on 10/9/18.
//  Copyright © 2018 paladinesa. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ViewController: UIViewController {
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //: Create and customize the ring as you wish
//        progressRing = UICircularProgressRing(frame: frame)
        progressRing.backgroundColor = .white
        progressRing.outerRingColor = .lightGray
        progressRing.innerRingColor = .green
        progressRing.outerRingWidth = 5
        progressRing.innerRingWidth = 5
//        progressRing.ringStyle = .gradient
//        progressRing.ringStyle = .dashed
        progressRing.ringStyle = .inside

        progressRing.font = UIFont.boldSystemFont(ofSize: 20)
        
        progressRing.maxValue = 60
        progressRing.minValue = 0
        
//        progressRing.fullCircle = false
        progressRing.startAngle = -90
        progressRing.endAngle = 270

        
        progressRing.isClockwise = false
        
        progressRing.gradientColors = [.green, .yellow, .red, .red]
        
        
        progressRing.innerRingSpacing = 3
        progressRing.valueIndicator = "s"
        
        progressRing.valueKnobSize = 20
        progressRing.valueKnobColor = .purple
        progressRing.showsValueKnob = true
//        progressRing.valueKnobShadowBlur = 0
//        progressRing.valueKnobShadowColor = .clear
        progressRing.showsValueKnob = false
        
        
        
        progressRing.startProgress(to: 60, duration: 0) {
            DispatchQueue.main.async {
                //: Animate with a given duration
                self.progressRing.startProgress(to: 60, duration: 2) {
                    // This is called when it's finished animating!
                    DispatchQueue.main.async {
                        // We can animate the ring back to another value here, and it does so fluidly
                        self.progressRing.startProgress(to: 0, duration: 5)
                    }
                }
            }
        }
        
//        //: Pause and continue animations dynamically
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            progressRing.pauseProgress()
//            //: Customize the ring even more
//            progressRing.showsValueKnob = true
//            progressRing.valueKnobSize = 20
//            progressRing.valueKnobColor = .green
//
//        }
        
        //: Continue the animation whenever you want
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.progressRing.continueProgress()
//        }
        
        self.runTimer()
    }
    
    var tiempoRestante = 60
    var timer : Timer!
    
    @objc func restarUno() {
        if(tiempoRestante == 0) {
            timer.invalidate()
            return
        }
        
        switch self.tiempoRestante {
        case 10:
            self.progressRing.innerRingColor = .red
        case 30:
            self.progressRing.innerRingColor = .orange
        case 45:
            self.progressRing.innerRingColor = .yellow
        default:
            print("nothing to do..")
        }
        
        tiempoRestante = tiempoRestante - 1
        progressRing.startProgress(to: UICircularProgressRing.ProgressValue(tiempoRestante), duration: 1)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.restarUno), userInfo: nil, repeats: true)
    }

}

