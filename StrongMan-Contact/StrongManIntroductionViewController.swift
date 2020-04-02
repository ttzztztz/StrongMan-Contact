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
    var info = [
        ["", ""],
        [""]
    ]
    var data: StrongMan? {
        didSet {
            if data == nil {
                return
            }
            
            info[0][0] = data?.name ?? ""
            info[0][1] = data?.mobile ?? ""
            info[1][0] = (data?.isStar ?? false ? "🌟" : "") ?? ""
        }
    }
    
    @objc func handleMoreButtonClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: "编辑"), style: .default) { (_) in
            
        }

        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "删除"), style: .destructive) { (_) in
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        
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
}
