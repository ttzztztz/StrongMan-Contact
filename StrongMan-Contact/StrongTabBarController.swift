//
//  StrongTabBarController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/30.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit

class StrongTabBarController: UITabBarController, UISplitViewControllerDelegate {
    lazy var contactSplitViewController: UISplitViewController = {
        let navigationController = UINavigationController(rootViewController: ContactViewController())
        
        let contactSplit = UISplitViewController()
        contactSplit.delegate = self
        contactSplit.viewControllers = [navigationController, UINavigationController(rootViewController: AboutViewController())]
        
        contactSplit.tabBarItem = UITabBarItem(title: NSLocalizedString("Contacts", comment: "通讯录"), image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        contactSplit.preferredDisplayMode = .allVisible
        
        return contactSplit
    }()
    
    let aboutController: UIViewController = {
        let about = UINavigationController(rootViewController: AboutViewController())
        
        about.tabBarItem = UITabBarItem(title: NSLocalizedString("About", comment: "关于"), image: UIImage(systemName: "paperplane"), selectedImage: UIImage(systemName: "paperplane.fill"))
        return about
    }()
    
    let motionController: UIViewController = {
        let motion = MotionViewController()
        
        let navController = UINavigationController(rootViewController: motion)
        navController.tabBarItem = UITabBarItem(title: "Motion", image: UIImage(systemName: "flame"), selectedImage: UIImage(systemName: "flame.fill"))
        
        return navController
    }()
    
    let locationController: UIViewController = {
        let controller = YourLocationViewController()
        
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        
        return navController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [contactSplitViewController, aboutController, motionController, locationController]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let alert = UIAlertController(title: NSLocalizedString("Hello", comment: "你好"), message: NSLocalizedString("Hello", comment: "你好"), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.invalidateIntrinsicContentSize()
    }
}
