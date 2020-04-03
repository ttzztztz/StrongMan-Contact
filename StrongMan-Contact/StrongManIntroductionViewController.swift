//
//  StrongManIntroductionViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/31.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit

class StrongManIntroductionViewController: UITableViewController {
    let cellId = "introductionItem"
    let fields = [
        [NSLocalizedString("Name", comment: "姓名"), NSLocalizedString("Mobile", comment: "电话")],
        [NSLocalizedString("isStar", comment: "星标")]
    ]
    
    private var info = [
        ["", ""],
        [""]
    ]
    
    private var editIndex: Int
    init(editIndex: Int) {
        self.editIndex = editIndex
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleMoreButtonClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: "编辑"), style: .default) { (_) in
            let editView = ToBeStrongViewController()
            let navigationView = UINavigationController(rootViewController: editView)
            
            let data = StrongManData.strongManList[self.editIndex]
            editView.setToEditMode(index: self.editIndex, data: data)
            
            self.present(navigationView, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel)
        
        alert.addAction(editAction)
        
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.barButtonItem = moreButton
        self.present(alert, animated: true)
    }
    
    lazy var moreButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleMoreButtonClick))
        
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleRefreshData()
        
        navigationItem.title = NSLocalizedString("Introduction", comment: "介绍")
        navigationItem.rightBarButtonItem = moreButton
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields[section].count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .value2, reuseIdentifier: cellId)
        }
        
        cell!.selectionStyle = .none
        cell!.textLabel?.text = fields[indexPath.section][indexPath.row]
        cell!.detailTextLabel?.text = info[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleObserver), name: NSNotification.Name(rawValue: "editStrongMan"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleRefreshData() {
        let data = StrongManData.strongManList[editIndex]
        info[0][0] = data.name ?? ""
        info[0][1] = data.mobile ?? ""
        info[1][0] = (data.isStar ? "🌟" : "") ?? ""
    }
    
    @objc func handleObserver() {
        handleRefreshData()
        tableView.reloadData()
    }
}
