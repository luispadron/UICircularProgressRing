//
//  ViewController.swift
//  Example
//
//  Created by Luis Padron on 9/16/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ViewController: UIViewController, UICircularProgressRingDelegate {

    @IBOutlet weak var ring1: UICircularProgressRingView!
    @IBOutlet weak var ring2: UICircularProgressRingView!
    @IBOutlet weak var ring3: UICircularProgressRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Button clicked, animate them views
    @IBAction func animateTheViews(_ sender: AnyObject) {
        ring1.setProgress(value: 100, animated: true)
        // Set the delegate as an example
        ring1.delegate = self
        ring2.setProgress(value: 83, animated: true)
        
        // Set max value to 10
        ring3.maxValue = 10
        ring3.setProgress(value: 3.67, animated: true)
    }
    
    // The delegate method
    func progressRingAnimationDidFinish() {
        print("yay the animation finished!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

