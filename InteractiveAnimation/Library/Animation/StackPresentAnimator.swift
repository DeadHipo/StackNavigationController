//
//  StackPresentAnimator.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 04.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit

final class StackPresentAnimator: NSObject {
    
    private let direction: StackDirection
    
    init(direction: StackDirection) {
        self.direction = direction
    }
    
    private func getStartToViewFrame(startFrame: CGRect) -> CGRect {
        switch direction {
        case .up:
            return CGRect(x: 0.0, y: startFrame.height, width: startFrame.width, height: startFrame.height)
        case .down:
            return CGRect(x: 0.0, y: -startFrame.height, width: startFrame.width, height: startFrame.height)
        case .left:
            return CGRect(x: startFrame.width, y: 0.0, width: startFrame.width, height: startFrame.height)
        case .right:
            return CGRect(x: -startFrame.width, y: 0.0, width: startFrame.width, height: startFrame.height)
        default:
            return startFrame
        }
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension StackPresentAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CATransaction.animationDuration()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),  let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let duration = transitionDuration(using: transitionContext)
        let startFrame = fromView.frame
        
        let overlayView = UIView(frame: startFrame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        transitionContext.containerView.addSubview(overlayView)
        transitionContext.containerView.addSubview(toView)
        
        toView.frame = getStartToViewFrame(startFrame: startFrame)
        
        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                toView.frame = startFrame
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
            }
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: animations) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            overlayView.removeFromSuperview()
        }
    }
}

