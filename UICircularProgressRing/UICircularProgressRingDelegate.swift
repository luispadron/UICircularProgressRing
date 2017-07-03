//
//  UICircularProgressRingDelegate.swift
//  UICircularProgressRing
//
//  Copyright (c) 2016 Luis Padron
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
//  OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


/**
 This is the protocol declaration for the UICircularProgressRingView delegate property
 
 ## Important ##
 When progress is done updating via UICircularProgressRingView.setValue(_:), the
 finishedUpdatingProgress(forRing: UICircularProgressRingView) will be called.
 
 The ring will be passed to the delegate in order to keep 
 track of multiple ring updates if needed.
 
 ## Author
 Luis Padron
 */
public protocol UICircularProgressRingDelegate: class {
    /**
     Delegate call back, called when progress ring is done animating for current value
     
     - Parameter ring: The ring which finished animating
     
    */
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView)
    
    /**
     This method is called whenever the value is updated, this means during animation this method will be called in real time.
     This can be used to update another label or do some other work, whenever you need the exact current value of the ring
     during animation.
     
     ## Important:
     
     This is a very hot method and may be called hundreds of times per second during animations. As such make sure to only
     do very simple and non-intensive work in this method. Do any work that takes time will considerably slow down your application.
     
     - Paramater newValue: The value which the ring has updated to
     */
    func didUpdateProgressValue(to newValue: CGFloat)
}


/// Protocol extension to add default conformance
public extension UICircularProgressRingDelegate {
    // Adds default conformance with an empty method stub
    func didUpdateProgressValue(to newValue: CGFloat) { }
}
