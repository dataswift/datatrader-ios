//
/**
 * Copyright (C) 2018 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import UIKit

class MenuTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    private var interactive = false
    var sideMenuDelegate: HATUIViewController?
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    private var statusBarBackground: UIView!
    
    var sourceViewController: UIViewController! {
        
        didSet {
            
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action: #selector(handleOnstagePan(pan:)))
            self.enterPanGesture.edges = UIRectEdge.left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
            
            // create view to go behind statusbar
            self.statusBarBackground = UIView()
            self.statusBarBackground.frame = CGRect(x: 0, y: 0, width: self.sourceViewController.view.frame.width, height: 20)
            self.statusBarBackground.backgroundColor = self.sourceViewController.view.backgroundColor
            
            // add to window rather than view controller
            UIApplication.shared.keyWindow?.addSubview(self.statusBarBackground)
        }
    }
    
    private var exitPanGesture: UIPanGestureRecognizer!
    
    var menuViewController: UIViewController! {
        didSet {
            self.exitPanGesture = UIPanGestureRecognizer()
            self.exitPanGesture.addTarget(self, action: #selector(handleOffstagePan(pan:)))
            self.menuViewController.view.addGestureRecognizer(self.exitPanGesture)
        }
    }
    
    @objc
    func handleOnstagePan(pan: UIPanGestureRecognizer){
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translation(in: pan.view!)
        
        let cgRectWidth = CGRect(origin: pan.view!.bounds.origin, size: pan.view!.bounds.size).width
        // do some math to translate this to a percentage based value
        let d =  translation.x / cgRectWidth * 0.5
        
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizer.State.began:
            // set our interactive flag to true
            self.interactive = true
            
            // trigger the start of the transition
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "sideMenu") as? SideMenuViewController
            self.sourceViewController.present(viewController!, animated: true, completion: nil)
            break
            
        case UIGestureRecognizer.State.changed:
            
            // update progress of the transition
            self.update(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2){
                // threshold crossed: finish
                self.finish()
            }
            else {
                // threshold not met: cancel
                self.cancel()
            }
        }
    }
    
    // pretty much the same as 'handleOnstagePan' except
    // we're panning from right to left
    // perfoming our exitSegeue to start the transition
    @objc
    func handleOffstagePan(pan: UIPanGestureRecognizer){
        
        let translation = pan.translation(in: pan.view!)
        let cgRectWidth = CGRect(origin: pan.view!.bounds.origin, size: pan.view!.bounds.size).width
        let d =  translation.x / cgRectWidth * -0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizer.State.began:
            self.interactive = true
            self.menuViewController.dismiss(animated: true, completion: nil)
            break
            
        case UIGestureRecognizer.State.changed:
            self.update(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.1){
                self.finish()
            }
            else {
                self.cancel()
            }
        }
    }
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!, transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as? SideMenuViewController : screens.to as? SideMenuViewController
        let topViewController = !self.presenting ? screens.to as? SideMenuViewController : screens.from as? SideMenuViewController
        
        let menuView = menuViewController!.view
        let topView = topViewController!.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuControllerInteractive(menuViewController: menuViewController!) // offstage for interactive
        }
        
        // add the both views to our view controller
        
        container.addSubview(menuView!)
        container.addSubview(topView!)
        container.addSubview(self.statusBarBackground)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .allowAnimatedContent, animations: {
            
            if (self.presenting){
                self.onStageMenuController(menuViewController: menuViewController!) // onstage items: slide in
                topView?.transform = self.offStage(amount: 290)
            }
            else {
                topView?.transform = .identity
                self.offStageMenuControllerInteractive(menuViewController: menuViewController!)
            }
            
        }, completion: { finished in
            
            // tell our transitionContext object that we've finished animating
            if(transitionContext.transitionWasCancelled){
                
                transitionContext.completeTransition(false)
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.shared.keyWindow?.addSubview(screens.from.view)
                
            }
            else {
                
                transitionContext.completeTransition(true)
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.shared.keyWindow?.addSubview(screens.to.view)
                
            }
            UIApplication.shared.keyWindow?.addSubview(self.statusBarBackground)
            
        })
        
    }
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(translationX: amount, y: 0)
    }
    
    func offStageMenuControllerInteractive(menuViewController: SideMenuViewController){
        
        menuViewController.view.alpha = 0
        self.statusBarBackground.backgroundColor = self.sourceViewController.view.backgroundColor
        
        // setup paramaters for 2D transitions for animations
        let offstageOffset  :CGFloat = -200
        
        menuViewController.view.transform = self.offStage(amount: offstageOffset)
    }
    
    func onStageMenuController(menuViewController: SideMenuViewController){
        
        // prepare menu to fade in
        menuViewController.view.alpha = 1
        self.statusBarBackground.backgroundColor = UIColor.black
        
        menuViewController.view.transform = .identity
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
}
