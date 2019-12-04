//
//  StackNavigationControllerDataSource.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 04.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import Foundation

protocol StackNavigationControllerDataSource: class {
    func navigationController(_ navigationController: StackNavigationController,
                              nextActionFor direction: StackDirection) -> StackDirectionAction
}

extension StackNavigationControllerDataSource {
    
}
