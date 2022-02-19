//
//  DataModel.swift
//  Checklists
//
//  Created by Sergei Sai on 29.01.2022.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        // Fake Data!
        /*self.lists = [Checklist(name: "Birthdays"),
                      Checklist(name: "Groceries"),
                      Checklist(name: "Cool Apps"),
                      Checklist(name: "To Do")]
        for list in self.lists {
            let item = ChecklistItem(text: "Item for \(list.name)")
            list.items.append(item)
        }*/
        
        print("Documents folder is \(self.documentsDirectory())")
        print("Data file path is \(self.dataFilePath())")
        
        self.loadChecklists()
        self.registerDefaults()
        self.handleFirstTime()
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    func dataFilePath() -> URL {
        return self.documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.lists)
            try data.write(to: self.dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let decoder = PropertyListDecoder()
        guard let data = try? Data(contentsOf: self.dataFilePath()) else { return }
        do {
            self.lists = try decoder.decode([Checklist].self, from: data)
            self.sortChecklists()
        } catch {
            print("Error decoding list array: \(error.localizedDescription)")
        }
    }
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        if UserDefaults.standard.bool(forKey: "FirstTime") {
            let checklist = Checklist(name: "List")
            self.lists.append(checklist)
            
            self.indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        self.lists.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
