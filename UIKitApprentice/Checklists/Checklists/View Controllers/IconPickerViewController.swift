//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Sergei Sai on 29.01.2022.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    let icons = [
        "No Icon", "Appointments", "Birthdays", "Chores",
        "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
    ]
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension IconPickerViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let icon = self.icons[indexPath.row]
        
        cell.textLabel?.text = icon
        cell.imageView?.image = UIImage(named: icon)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.iconPicker(self, didPick: self.icons[indexPath.row])
    }
}
