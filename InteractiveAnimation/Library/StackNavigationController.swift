//
//  StackNavigationController.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 04.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit

class StackNavigationController: UINavigationController {
    
    weak var dataSource: StackNavigationControllerDataSource?
    weak var navigationControllerDelegate: StackNavigationControllerDelegate?
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var inTransition: Bool = false
    private var currentDirection: StackDirection = .none
    
    lazy var panGestureRecognizer: StackDirectionPanGestureRecognizer = {
        let panGestureRecognizer = StackDirectionPanGestureRecognizer(target: self, action: #selector(panGestureRecognized))
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        return panGestureRecognizer
    }()
    
    // MARK: - Status bar
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    // MARK: - Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        transitioningDelegate = self
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transitioningDelegate = self
        modalPresentationStyle = .fullScreen
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        
        transitioningDelegate = self
        modalPresentationStyle = .fullScreen
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        transitioningDelegate = self
        modalPresentationStyle = .fullScreen
    }
    
    deinit {
        interactionController = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarHidden(true, animated: false)
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        delegate = self
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - Handler
    
    @objc private func panGestureRecognized(_ sender: StackDirectionPanGestureRecognizer) {
        guard let gestureRecognizerView = sender.view else {
            interactionController = nil
            return
        }
        
        let velocity = getVelocity(sender)
        let percent = getProgress(sender)
        
        switch sender.state {
            
        case .possible:
            break
            
        case .began:
            currentDirection = sender.currentDirection
            
            let action = dataSource?.navigationController(self, nextActionFor: currentDirection) ?? .none
            
            switch action {
            case .pop:
                interactionController = UIPercentDrivenInteractiveTransition()
                popViewController(animated: true)
                
            case .push(let viewController):
                interactionController = UIPercentDrivenInteractiveTransition()
                pushViewController(viewController, animated: true)
                
            case .dismiss:
                interactionController = UIPercentDrivenInteractiveTransition()
                presentingViewController?.dismiss(animated: true)
                
            case .none:
                break
                
            }
            
        case .changed:
            interactionController?.update(percent)
            
        case .ended where percent > 0.4 || velocity > 1400.0:
            interactionController?.completionSpeed = getCompletionSpeed(view: gestureRecognizerView, velocity: velocity)
            interactionController?.finish()
            interactionController = nil
            
        default:
            interactionController?.cancel()
            interactionController = nil
            inTransition = false
            
        }
        
    }
    
    private func getProgress(_ sender: StackDirectionPanGestureRecognizer) -> CGFloat {
        guard let view = sender.view else {
            return 0.0
        }
        
        switch currentDirection {
        case .left, .right:
            let percent = abs(sender.translation(in: view).x / view.bounds.size.width)
            return min(1.0, max(0.0, percent))
        case .up, .down:
            let percent = abs(sender.translation(in: view).y / view.bounds.size.height)
            return min(1.0, max(0.0, percent))
        case .none:
            return 0.0
        }
    }
    
    private func getVelocity(_ sender: StackDirectionPanGestureRecognizer) -> CGFloat {
        let velocity = sender.velocity(in: sender.view)
        switch currentDirection {
        case .left, .right:
            return abs(velocity.x)
        case .up, .down:
            return abs(velocity.y)
        case .none:
            return 0.0
        }
    }
    
    private func getCompletionSpeed(view: UIView, velocity: CGFloat) -> CGFloat {
        switch currentDirection {
        case .left, .right:
            return max(1.0, velocity / view.frame.width)
        case .up, .down:
            return max(1.0, velocity / view.frame.height)
        case .none:
            return 1.0
        }
    }
    
}

// MARK: - UINavigationControllerDelegate
extension StackNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        inTransition = true
        
        navigationControllerDelegate?.navigationController(self, willShow: viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        inTransition = false
        currentDirection = .none
        
        navigationControllerDelegate?.navigationController(self, didShow: viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let navigationControllerDelegate = navigationControllerDelegate {
            return navigationControllerDelegate.navigationController(self, animationControllerFor: currentDirection, operation: operation, from: fromVC, to: toVC)
        } else {
            switch operation {
            case .push, .pop:
                return StackDefaultAnimation(direction: currentDirection)
            default:
                return nil
            }
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension StackNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return navigationControllerDelegate?.navigationController(self, shouldRecive: touch, in: touch.view) ?? true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationControllerDelegate?.navigationController(self, shouldBeRequiredToFailBy: otherGestureRecognizer) ?? false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = navigationControllerDelegate?.navigationController(shouldBeginTransition: self) ?? true
        return shouldBegin && !inTransition
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension StackNavigationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StackDismissAnimator(direction: currentDirection)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StackPresentAnimator(direction: .up)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}

