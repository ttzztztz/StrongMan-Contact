//
//  ToBeStrongViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/30.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit

enum ToBeStrongViewControllerType {
    case Add
    case Edit
}

class ToBeStrongViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var type: ToBeStrongViewControllerType = .Add
    var editIndex: Int = -1
    
    func setToEditMode(index: Int, data: StrongMan) {
        type = .Edit
        editIndex = index
        navigationItem.title = NSLocalizedString("EditStrongMan", comment: "编辑强者")
        
        nameInput.text = data.name
        mobileInput.text = data.mobile
        pickerInput.selectRow(Int(data.group), inComponent: 0, animated: true)
    }
    
    let cellId = "toBeStrong"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    lazy var nameInput: UITextField = {
        let input = UITextField()
        
        input.placeholder = NSLocalizedString("Name", comment: "姓名")
        input.delegate = self
        input.returnKeyType = .done
        
        return input
    }()
    
    
    lazy var mobileInput: UITextField = {
        let input = UITextField()
        
        input.placeholder = NSLocalizedString("Mobile", comment: "手机")
        input.delegate = self
        input.returnKeyType = .done
        
        return input
    }()
    
    lazy var pickerInput: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        return picker
    }()
    
    lazy var inputViewList: [[UIView]] = [[nameInput, mobileInput], [pickerInput]]
    
    @objc func handleSave() {
        let groupId = pickerInput.selectedRow(inComponent: 0)
        if (type == .Add) {
            let newStrongMan = StrongMan(context: PersistentService.context)
            newStrongMan.name = nameInput.text ?? ""
            newStrongMan.group = Int16(groupId)
            newStrongMan.isStar = false
            newStrongMan.mobile = mobileInput.text ?? ""
            newStrongMan.order = Int32(StrongManData.strongManList.count)
            
            StrongManData.strongManList.append(newStrongMan)
        } else if (type == .Edit) {
            let newStrongMan = StrongManData.strongManList[editIndex]
            
            newStrongMan.name = nameInput.text ?? ""
            newStrongMan.group = Int16(groupId)
            newStrongMan.mobile = mobileInput.text ?? ""
        }
        
        PersistentService.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listDidChange"), object: nil)
        
        if (type == .Edit) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editStrongMan"), object: nil)
        }
        
        let alert = UIAlertController(title: NSLocalizedString("StrongManContacts", comment: "通讯录"), message: NSLocalizedString("Operation Successful", comment: "操作成功"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true)
    }
    
    lazy var cancelNavButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "取消"), style: .plain, target: self, action: #selector(handleCancel))
        
        return button
    }()
    
    lazy var saveNavButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Save", comment: "保存"), style: .done, target: self, action: #selector(handleSave))
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (type == .Add) {
            navigationItem.title = NSLocalizedString("ToBe", comment: "成为强者")
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.leftBarButtonItem = cancelNavButton
        navigationItem.rightBarButtonItem = saveNavButton
        
        self.view.backgroundColor = .systemBackground
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return inputViewList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputViewList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        
        cell?.selectionStyle = .none
        
        let subView = inputViewList[indexPath.section][indexPath.row]
        cell?.addSubview(subView)
        subView.snp.makeConstraints { (make) -> Void in
            make.margins.equalTo(cell!).inset(8)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 1) {
            return 128
        }
        
        return 48
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 24
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewCell()
    }
    
    let pickerFields = [NSLocalizedString("Frontend", comment: "前端"), NSLocalizedString("Backend", comment: "后端")]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerFields.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerFields[row]
    }
}
