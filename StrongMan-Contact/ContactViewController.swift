//
//  ContactViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/27.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController {
    let cellId = "hzytqlCell"
    
    func setToEditMode() {
        navigationItem.rightBarButtonItem = finishButton
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @objc func setFromEditMode() {
        navigationItem.rightBarButtonItem = moreButton
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @objc func handleMoreButtonClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: NSLocalizedString("Add", comment: "添加"), style: .default) { (_) in
            let addController = ToBeStrongViewController()
            let navController = UINavigationController(rootViewController: addController)
            
            self.present(navController, animated: true)
        }
        
        let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: "编辑"), style: .default) { (_) in
            self.setToEditMode()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(editAction)
        
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.barButtonItem = moreButton
        self.present(alert, animated: true)
    }
    
    lazy var moreButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleMoreButtonClick))
        
        return item
    }()
    
    lazy var finishButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: NSLocalizedString("Finish", comment: "完成"), style: .done, target: self, action: #selector(setFromEditMode))
        
        return item
    }()
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let previousIndex = sourceIndexPath.row, newIndex = destinationIndexPath.row
        
        let previousStrongMan = StrongManData.strongManList[previousIndex], newStrongMan = StrongManData.strongManList[newIndex]
        
        previousStrongMan.order = Int32(newIndex)
        newStrongMan.order = Int32(previousIndex)
        PersistentService.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("StrongManContacts", comment: "强者通讯录")
        navigationItem.rightBarButtonItem = moreButton
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "listDidChange"), object: nil)
    }
    
    @objc func refreshData() {
        StrongManData.reloadData()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StrongManData.strongManList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let strongMan = StrongManData.strongManList[indexPath.row]
        
        let attributedString = NSMutableAttributedString(string: strongMan.name ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributedString.append(NSAttributedString(string: "\n \(StrongManData.getGroupName(man: strongMan))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]))
        
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.numberOfLines = 2
        
        let infoButton = StrongManTableAccessorButtonView(type: .system)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.sizeToFit()
        infoButton.strongManName = strongMan.name
        infoButton.addTarget(self, action: #selector(showInfoView), for: .touchUpInside)
        
        cell.accessoryView = infoButton
        return cell
    }
    
    @objc func showInfoView(button: StrongManTableAccessorButtonView) {
        let controller = StrongManPresentViewController()
        controller.strongManName = button.strongManName
        let navigationController = UINavigationController(rootViewController: controller)
        
        self.present(navigationController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = StrongManIntroductionViewController(editIndex: indexPath.row)
        let navigationCntroller = UINavigationController(rootViewController: controller)
        
        splitViewController?.showDetailViewController(navigationCntroller, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "删除")) { (_, _, finished) -> Void in
            
            let confirmAlert = UIAlertController(title: NSLocalizedString("StrongManContacts", comment: "强者通讯录"), message: NSLocalizedString("ConfirmDelete", comment: "删除确认"), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel)
            let confirmAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "删除"), style: .destructive) { (action) -> Void in
                
                let obj = StrongManData.strongManList[indexPath.row]
                PersistentService.context.delete(obj)
                PersistentService.saveContext()
                
                StrongManData.strongManList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
                finished(true)
            }
            
            confirmAlert.addAction(cancelAction)
            confirmAlert.addAction(confirmAction)
            self.present(confirmAlert, animated: true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: NSLocalizedString("Edit", comment: "编辑")) { (_, _, _) -> Void in
            let editView = ToBeStrongViewController()
            let navigationView = UINavigationController(rootViewController: editView)
            
            let data = StrongManData.strongManList[indexPath.row]
            editView.setToEditMode(index: indexPath.row, data: data)
            
            self.present(navigationView, animated: true)
        }
        
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return actions
    }
}
