//
//  AppDelegate.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 02.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        (window?.rootViewController as? StackNavigationController)?.dataSource = self
        
        return true
    }

}

// MARK: - NavigationControllerDataSource
extension AppDelegate: StackNavigationControllerDataSource {
    
    func navigationController(_ navigationController: StackNavigationController, nextActionFor direction: StackDirection) -> StackDirectionAction {
        
        switch direction {
        case .down:
            return .push(viewController: ViewController())
        case .left:
            return .push(viewController: ViewController())
            
        case .right:
            return .pop
            
        case .up:
            return .none
            
        case .none:
            return .none
        }
        
    }
    
}
