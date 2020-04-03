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

//struct StrongManGroup {
//    let groupName: String
//    var list: [StrongMan]
//    var isShow: Bool = true
//}


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
    static func reloadData() {
        self.strongManList = readData()
    }
    
    private static func readData() -> [StrongMan] {
        let fetchRequest: NSFetchRequest<StrongMan> = StrongMan.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var strongManList: [StrongMan] = []
        
        do {
            let people = try PersistentService.context.fetch(fetchRequest)
            strongManList = people
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return strongManList
    }

    static var strongManList: [StrongMan] = {
        return readData()
    }()
    
    static func getGroupName(man: StrongMan) -> String {
        if (man.group == 0) {
            return NSLocalizedString("Frontend", comment: "前端")
        } else {
            return NSLocalizedString("Backend", comment: "后端")
        }
    }
}
