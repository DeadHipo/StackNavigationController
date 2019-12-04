//
//  StackDirectionPanGestureRecognizer.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 03.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class StackDirectionPanGestureRecognizer: UIPanGestureRecognizer {
    
    var currentDirection: StackDirection = .none
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            let veloctity = velocity(in: view)
            
            if abs(veloctity.x) > abs(veloctity.y) {
                if veloctity.x > 0 {
                    currentDirection  = .right
                } else {
                    currentDirection = .left
                }
            } else {
                if veloctity.y > 0 {
                    currentDirection = .down
                } else {
                    currentDirection = .up
                }
            }
            
        }
    }
}
