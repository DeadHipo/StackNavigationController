//
//  StackDirectionAction.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 04.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit

enum StackDirectionAction {
    case pop
    case push(viewController: UIViewController)
    case none
    case dismiss
}
