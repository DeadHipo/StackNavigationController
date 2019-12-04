//
//  StackNavigationControllerDelegate.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 04.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit

protocol StackNavigationControllerDelegate: class {
    
    func navigationController(_ navigationController: StackNavigationController,
                              animationControllerFor direction: StackDirection,
                              operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    func navigationController(_ navigationController: StackNavigationController, willShow viewController: UIViewController)
    func navigationController(_ navigationController: StackNavigationController, didShow viewController: UIViewController)
    
    func navigationController(_ navigationController: StackNavigationController, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    func navigationController(shouldBeginTransition navigationController: StackNavigationController) -> Bool
    func navigationController(_ navigationController: StackNavigationController, shouldRecive touch: UITouch, in view: UIView?) -> Bool
    
}

extension StackNavigationControllerDelegate {
    
    func navigationController(_ navigationController: StackNavigationController,
                              animationControllerFor direction: StackDirection,
                              operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch direction {
        case .down, .up, .left, .right:
            return StackDefaultAnimation(direction: direction)
        case .none:
            return nil
        }
        
    }
    
    func navigationController(_ navigationController: StackNavigationController,
                              willShow viewController: UIViewController) {
        
    }
    
    func navigationController(_ navigationController: StackNavigationController,
                              didShow viewController: UIViewController) {
        
    }

    
    func navigationController(_ navigationController: StackNavigationController,
                              shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func navigationController(_ navigationController: StackNavigationController,
                              shouldRecive touch: UITouch,
                              in view: UIView?) -> Bool {
        return true
    }
    
    

    
    func navigationController(shouldBeginTransition navigationController: StackNavigationController) -> Bool {
        return true
    }
    
}
