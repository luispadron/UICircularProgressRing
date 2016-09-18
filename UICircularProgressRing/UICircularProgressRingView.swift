//
//  UICircularProgressRingView.swift
//  TestEnv
//
//  Created by Luis Padron on 9/18/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit

@IBDesignable
class UICircularProgressRingView: UIView {
    
    // MARK: Value Properties
    
    /**
     The value property for the progress ring. ex: (23)/100
     
     ## Important ##
     Default = 0
     When assigning to this var the view will be redrawn.
     Recommended to assign value using setProgress(_:) instead.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var value: CGFloat = 0 {
        didSet {
            self.progressLayer.value = value
        }
    }
    
    /**
     The max value for the progress ring. ex: 23/(100)
     Used to calculate amount of progress depending on self.value and self.maxValue
     
     ## Important ##
     Default = 100
     
     When assigning to this var the view will be redrawn.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var maxValue: CGFloat = 100 {
        didSet {
            self.progressLayer.maxValue = maxValue
        }
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    public func set(value: CGFloat) {
        self.progressLayer.animated = false
        self.progressLayer.value = value
    }
    
    public func set(value: CGFloat, animationDuration: TimeInterval, completion: (() -> Void)?) {
        self.progressLayer.animated = true
        self.progressLayer.animationDuration = animationDuration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let comp = completion {
                comp()
            }
        }
        self.progressLayer.value = value
        CATransaction.commit()
        
    }
    
    var progressLayer: UICircularProgressRingLayer {
        return self.layer as! UICircularProgressRingLayer
    }
    
    override class var layerClass: AnyClass {
        get {
            return UICircularProgressRingLayer.self
        }
    }
    
}
