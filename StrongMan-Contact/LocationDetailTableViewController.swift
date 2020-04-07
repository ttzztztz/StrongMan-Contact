//
//  LocationDetailTable.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/4/7.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let row: [String] = ["Lattitude", "Longitude", "Altitude", "Horizontal Accuracy", "Vertical Accuracy"]
    var data: [String] = ["", "", "", "", ""]
    let cellId = "mapDetailCell"
    
    var location: CLLocation? {
        didSet {
            if location == nil {
                return
            }
            
            data[0] = "\(location!.coordinate.latitude)"
            data[1] = "\(location!.coordinate.longitude)"
            data[2] = "\(location!.altitude)"
            data[3] = "\(location!.horizontalAccuracy)"
            data[4] = "\(location!.verticalAccuracy)"
            
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return row.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = row[indexPath.row]
        cell?.detailTextLabel?.text = data[indexPath.row]
        
        return cell!
    }
}
