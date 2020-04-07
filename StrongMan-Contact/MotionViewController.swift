//
//  Motion.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/4/7.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import CoreMotion

class MotionViewController: UITableViewController {
    let key: [[String]] = [["x","y","z"], ["x", "y", "z"], ["x", "y", "z"], ["Roll", "Pitch", "Yaw"]]
    let sectionText: [String] = ["Rotation Rate", "Acceleration User", "Acceleration Gravity", "Attitude"]
    var value: [[String]] = [["","",""], ["", "", ""], ["", "", ""], ["", "", ""]]
    let cellId = "motionCell"
    
    let motionManager = CMMotionManager()
    var motionTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Motion"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func updateMotionData() {
        if let motion = motionManager.deviceMotion {
            let rotationRate = motion.rotationRate, accUser = motion.userAcceleration, accGravity = motion.gravity, attitude = motion.attitude
            
            DispatchQueue.main.async {
                self.value[0][0] = "\(rotationRate.x)"
                self.value[0][1] = "\(rotationRate.y)"
                self.value[0][2] = "\(rotationRate.z)"
                
                self.value[1][0] = "\(accUser.x)"
                self.value[1][1] = "\(accUser.y)"
                self.value[1][2] = "\(accUser.z)"
                
                self.value[2][0] = "\(accGravity.x)"
                self.value[2][1] = "\(accGravity.y)"
                self.value[2][2] = "\(accGravity.z)"
                
                self.value[3][0] = "\(attitude.roll)"
                self.value[3][1] = "\(attitude.pitch)"
                self.value[3][2] = "\(attitude.yaw)"
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates()
            
            motionTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:
                #selector(updateMotionData), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
            
            motionTimer.invalidate()
            motionTimer = nil
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionText.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return key[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = key[indexPath.section][indexPath.row]
        cell?.detailTextLabel?.text = value[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = sectionText[section]
        return label
    }
}
