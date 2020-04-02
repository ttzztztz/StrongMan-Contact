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
        contactSplit.viewControllers = [navigationController, AboutViewController()]
        
        contactSplit.tabBarItem = UITabBarItem(title: NSLocalizedString("Contacts", comment: "通讯录"), image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        contactSplit.preferredDisplayMode = .allVisible
        
        return contactSplit
    }()
    
//    let toBeStrongManController: UINavigationController = {
//        let strong = UINavigationController(rootViewController: ToBeStrongViewController())
//        strong.tabBarItem = UITabBarItem(title: NSLocalizedString("ToBe", comment: "成为强者"), image: UIImage(systemName: "plus.circle"), selectedImage: UIImage(systemName: "plus.circle.fill"))
//
//        return strong
//    }()
    
    let aboutController: UIViewController = {
        let about = UINavigationController(rootViewController: AboutViewController())
        
        about.tabBarItem = UITabBarItem(title: NSLocalizedString("About", comment: "关于"), image: UIImage(systemName: "paperplane"), selectedImage: UIImage(systemName: "paperplane.fill"))
        return about
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [contactSplitViewController, aboutController]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
