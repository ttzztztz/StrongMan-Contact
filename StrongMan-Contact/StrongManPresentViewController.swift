//
//  StrongManPresent.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/30.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import SnapKit

class StrongManPresentViewController: UIViewController {
    var strongManName: String? {
        didSet {
            if (strongManName == nil) { return }
            
            let prefix = NSLocalizedString("StrongManDiscovery", comment: "你发现了一位强者！")
            let attributedText = NSMutableAttributedString(string: "\(prefix)", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
            
            attributedText.append(NSAttributedString(string: "\n\(strongManName!)", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSMutableAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
            
            headLabel.attributedText = attributedText
            headLabel.textAlignment = .center
            headLabel.numberOfLines = 5
        }
    }
    
    let bigStar: UIImageView = {
        let startImage = UIImage(systemName: "star.fill")!
        let imageView = UIImageView(image: startImage)
        
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    let headLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    @objc func handleButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleFinishClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleWowClick() {
        let alert = UIAlertController(title: "Wow", message: "Wow", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(NSLocalizedString("IKnow", comment: "我知道了"), for: .normal)
        button.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var navigationRightBarClose: UIBarButtonItem = {
        let bar = UIBarButtonItem(title: NSLocalizedString("Finish", comment: "完成"), style: .done, target: self, action: #selector(handleFinishClick))
        
        return bar
    }()
    
    lazy var navigationLeftBarWow: UIBarButtonItem = {
        let bar = UIBarButtonItem(title: "Wow", style: .plain, target: self, action: #selector(handleWowClick))
        
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("StrongManContacts", comment: "强者通讯录")
        self.navigationItem.setRightBarButton(navigationRightBarClose, animated: true)
        self.navigationItem.setLeftBarButton(navigationLeftBarWow, animated: true)
        
        let stackView = UIStackView(arrangedSubviews: [bigStar, headLabel, confirmButton])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(196)
        }
        
        bigStar.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(stackView.snp.top).offset(36)
//            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(196)
//            make.width.equalTo(196)
        }
        
        view.backgroundColor = .systemBackground
    }
    
}
