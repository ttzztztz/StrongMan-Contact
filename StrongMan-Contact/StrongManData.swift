//
//  StrongManData.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/3/27.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import CoreData

//struct StrongMan {
//    let name: String
//    let mobile: String
//    var isStar: Bool
//}
//

struct StrongManGroup {
    let groupName: String
    var list: [StrongMan]
    var isShow: Bool = true
}


//var strongManList: [StrongManGroup] = [
//    StrongManGroup(groupName: NSLocalizedString("Frontend", comment: "前端"), list: [
//        StrongMan(name: "hzy", mobile: "123456", isStar: true),
//        StrongMan(name: "zcy", mobile: "123456", isStar: false)
//    ]),
//    StrongManGroup(groupName: NSLocalizedString("Backend", comment: "后端"), list: [
//        StrongMan(name: "hezeyu", mobile: "123456", isStar: false)
//    ]),
//]


class StrongManData {
    static var strongManCount = 0
    
    static func reloadData() {
        self.strongManList = readData()
    }
    
    private static func readData() -> [StrongManGroup] {
        let fetchRequest: NSFetchRequest<StrongMan> = StrongMan.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var group = [
            StrongManGroup(groupName: NSLocalizedString("Frontend", comment: "前端"), list: []),
            StrongManGroup(groupName: NSLocalizedString("Backend", comment: "后端"), list: []),
        ]
        
        self.strongManCount = 0
        
        do {
            let people = try PersistentService.context.fetch(fetchRequest)
            for i in people.indices {
                let groupId = people[i].group
                group[Int(groupId)].list.append(people[i])
                strongManCount += 1
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return group
    }

    static var strongManList: [StrongManGroup] = {
        return readData()
    }()
}
