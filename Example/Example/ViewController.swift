//
//  ViewController.swift
//  Example
//
//  Created by Luis Padron on 9/16/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ViewController: UIViewController {
    

    @IBOutlet weak var ring1: UICircularProgressRingView!
    @IBOutlet weak var ring2: UICircularProgressRingView!
    @IBOutlet weak var ring3: UICircularProgressRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Here we would do any customization to the view via code
        // Example
        ring1.animationDuration = 3.0
        ring1.animationStyle = kCAMediaTimingFunctionLinear
        ring2.animationDuration = 1.23
    }
    
    // Button clicked, animate them views
    @IBAction func animateTheViews(_ sender: AnyObject) {
        // You set the value that you want to be updated
        // and whether the view should be animated our not
        ring1.setProgress(value: 100, animated: true) {
            print("Awesome ring 1 finished")
        }
        
        // No completion here as its optional
        ring2.setProgress(value: 83, animated: true, completion: nil)
        
        // Set max value to 10
        ring3.maxValue = 10
        ring3.setProgress(value: 3.67, animated: true) {
            print("Ring 3 finished!")
        }
    }
    
}

