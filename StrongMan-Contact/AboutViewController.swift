//
//  AboutViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/31.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import SnapKit
import LocalAuthentication

class AboutViewController: UIViewController, UIGestureRecognizerDelegate {
    private var previousScale = CGFloat(1)
    private var scale = CGFloat(1)
    private var previousRotation = CGFloat(1)
    private var rotation = CGFloat(1)
    
    let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        
        view.backgroundColor = .systemFill
        
        return view
    }()
    
    lazy var pinchGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(doPinch))
        gesture.delegate = self
        return gesture
    }()
    
    lazy var rotateGesture: UIRotationGestureRecognizer = {
        let gesture = UIRotationGestureRecognizer(target: self, action: #selector(doRotate))
        gesture.delegate = self
        return gesture
    }()
    
    lazy var iconView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "hzy"))
        
        image.sizeToFit()
        image.isUserInteractionEnabled = true
        
        image.addGestureRecognizer(self.pinchGesture)
        image.addGestureRecognizer(self.rotateGesture)
        
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
    
    let authButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(NSLocalizedString("Auth", comment: "认证"), for: .normal)
        button.addTarget(self, action: #selector(handleAuth), for: .touchUpInside)
        
        return button
    }()
    
    func checkForUpdate() -> Bool {
        Thread.sleep(forTimeInterval: 5)
        return arc4random() % 2 == 1
    }
    
    @objc func handleAuth() {
        let authContext: LAContext = {
            let context = LAContext()
            context.localizedCancelTitle = NSLocalizedString("Enter Password", comment: "输入密码")
            return context
        }()
        
        var error: NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: NSLocalizedString("Unlock more contents", comment: "解锁更多内容")) { (success, err) in
                if success {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: NSLocalizedString("StrongManContacts", comment: "强者通讯录"), message: NSLocalizedString("Operation Successful", comment: "操作成功"), preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: NSLocalizedString("StrongManContacts", comment: "强者通讯录"), message: err?.localizedDescription, preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            print(error!)
        }
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
    
    @objc func handleChangePhoto() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        self.present(picker, animated: true)
    }
    
    let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Change Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconView, innerStackView])
        
        view.axis = .vertical
        
        return view
    }()
    
    lazy var innerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [licenceButton, checkForUpdateButton, authButton, changePhotoButton])
        
        view.axis = .vertical
        view.distribution = .fillEqually
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("About", comment: "关于")
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = .systemBackground
        
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
    
    @objc func handleOrientationChange() {
        if UIDevice.current.orientation.isPortrait {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func transformImageView() {
        var transform = CGAffineTransform(scaleX: previousScale * scale, y: previousScale * scale)
        transform = transform.rotated(by: previousRotation + rotation)
        iconView.transform = transform
    }
    
    @objc func doPinch(_ gesture: UIPinchGestureRecognizer) {
        scale = gesture.scale
        transformImageView()
        if gesture.state == .ended {
            previousScale *= scale
            scale = 1
        }
    }
    
    @objc func doRotate(_ gesture: UIRotationGestureRecognizer) {
        rotation = gesture.rotation
        transformImageView()
        if gesture.state == .ended {
            previousRotation *= rotation
            rotation = 1
        }
    }
}


extension AboutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        if let selectedImage = selectedImage {
            self.iconView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
}
