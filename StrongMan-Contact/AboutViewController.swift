//
//  AboutViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/31.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import SnapKit

class AboutViewController: UIViewController {
    let spinner = UIActivityIndicatorView(style: .large)
    
    let iconView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "hzy"))
        
        image.sizeToFit()
        return image
    }()
    
    let licenceButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(NSLocalizedString("Licence", comment: "协议"), for: .normal)
        button.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        
        return button
    }()
    
    let checkForUpdateButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(NSLocalizedString("Check For Update", comment: "检测更新"), for: .normal)
        button.addTarget(self, action: #selector(handleCheckForUpdate), for: .touchUpInside)
        
        return button
    }()
    
    func checkForUpdate() -> Bool {
        Thread.sleep(forTimeInterval: 5)
        return arc4random() % 2 == 1
    }
    
    @objc func handleCheckForUpdate() {
        spinner.startAnimating()
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let checkResult = self.checkForUpdate()
            DispatchQueue.main.async {
                if (checkResult) {
                    self.checkForUpdateButton.setTitle(NSLocalizedString("Please Update", comment: "有更新"), for: .normal)
                } else {
                    self.checkForUpdateButton.setTitle(NSLocalizedString("No Update", comment: "无更新"), for: .normal)
                }
                self.spinner.stopAnimating()
            }
        }
    }
    
    @objc func handleButtonClick() {
        navigationController?.pushViewController(LicenceViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("About", comment: "关于")
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [iconView, licenceButton, checkForUpdateButton])
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(view)
        }
        
        iconView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        view.addSubview(spinner)
        spinner.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
