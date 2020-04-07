//
//  LicenceViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/4/1.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import SnapKit

class LicenceViewController: UIViewController {
    let licenceTextView: UITextView = {
        let textView = UITextView()
        
        var viewText = "Licence is here!!!!! \n"
        for _ in 0...5 {
            viewText += viewText
        }
        textView.text = viewText
        textView.isEditable = false
        textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("Licence", comment: "协议")
        
        view.addSubview(licenceTextView)
        licenceTextView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
