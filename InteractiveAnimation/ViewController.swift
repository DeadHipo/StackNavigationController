//
//  ViewController.swift
//  InteractiveAnimation
//
//  Created by Александрк Бельковский on 02.12.2019.
//  Copyright © 2019 Александрк Бельковский. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: .random(in: 0...1),
                                            green: .random(in: 0...1),
                                            blue: .random(in: 0...1),
                                            alpha: 1.0)
        
        let rightView = UIView()
        rightView.backgroundColor = .red
        rightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightView)
        rightView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        rightView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let leftView = UIView()
        leftView.backgroundColor = .red
        leftView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftView)
        leftView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        leftView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        leftView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        leftView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        let topView = UIView()
        topView.backgroundColor = .red
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        topView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        let bottomView = UIView()
        bottomView.backgroundColor = .red
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        bottomView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let actionButton = UIButton(type: .system)
        actionButton.setTitle("FIRE", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .black
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        actionButton.addTarget(self, action: #selector(fireButtonClicked), for: .touchUpInside)
    }

    @objc private func fireButtonClicked(_ button: UIButton) {
        let vc = ViewController()
        let nv = StackNavigationController(rootViewController: vc)
        nv.dataSource = self
        nv.navigationControllerDelegate = self
        
        present(nv, animated: true)
    }
    
}

// MARK: - NavigationControllerDataSource
extension ViewController: StackNavigationControllerDataSource {
    
    func navigationController(_ navigationController: StackNavigationController,
                              nextActionFor direction: StackDirection) -> StackDirectionAction {
        
        switch direction {
        case .down:
            return .dismiss
        case .left:
            return .push(viewController: ViewController())
            
        case .right:
            return .none
            
        case .up:
            return .pop
            
        case .none:
            return .none
        }
        
    }
    
}

// MARK: - NavigationControllerDelegate
extension ViewController: StackNavigationControllerDelegate {

    func navigationController(_ navigationController: StackNavigationController,
                              shouldRecive touch: UITouch,
                              in view: UIView?) -> Bool {
        return !(view is UIButton)
    }

}
