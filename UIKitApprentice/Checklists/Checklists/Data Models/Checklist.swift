//
//  Checklist.swift
//  Checklists
//
//  Created by Sergei Sai on 29.01.2022.
//

import UIKit

final class Checklist: NSObject {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return self.items.filter{ !$0.isChecked }.count
        /*return self.items.reduce(0) { result, item in
            result + (!item.isChecked ? 1 : 0)
        }*/
        /*var count = 0
        for item in self.items where !item.isChecked {
            count += 1
        }
        return count*/
    }
}

extension Checklist: Codable {}
