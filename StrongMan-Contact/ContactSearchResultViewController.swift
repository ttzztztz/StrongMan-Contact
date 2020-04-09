//
//  SearchResultController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/4/9.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit

struct SearchResultItem {
    var name: String
    var group: String
}

class ContactSearchResultViewController: UITableViewController, UISearchResultsUpdating {
    var filteredName: [SearchResultItem] = []
    let cellId = "searchCell"
    
    func updateSearchResults(for searchController: UISearchController) {
        if let inputString = searchController.searchBar.text {
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            
            filteredName.removeAll(keepingCapacity: true)
            if !inputString.isEmpty {
                filteredName += StrongManData.strongManList.filter { (item: StrongMan) -> Bool in
                    
                    if buttonIndex != 0 && buttonIndex - 1 != Int(item.group) {
                        return false
                    }
                    
                    let range = item.name?.range(of: inputString, options: .caseInsensitive, range: nil, locale: nil)
                    
                    return range != nil
                }
                .map {
                    SearchResultItem(name: $0.name ?? "", group: StrongManData.getGroupName(man: $0))
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        let item = filteredName[indexPath.row]
        
        cell?.textLabel?.text = item.name
        cell?.detailTextLabel?.text = item.group
        
        return cell!
    }
}
