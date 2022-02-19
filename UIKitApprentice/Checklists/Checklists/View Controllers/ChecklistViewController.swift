//
//  ViewController.swift
//  Checklists
//
//  Created by Sergei Sai on 27.01.2022.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var isRow0Checked = false
    var items = [ChecklistItem]()
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = checklist.name
        
        // Disable Large Titles For This View Controller
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dstVC = segue.destination as? ItemDetailViewController else { return }
        
        if segue.identifier == "AddItem" {
            dstVC.delegate = self
        } else if segue.identifier == "EditItem" {
            dstVC.delegate = self
            if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
                dstVC.itemToEdit = self.checklist.items[indexPath.row]
            }
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        //cell.accessoryType = item.isChecked ? .checkmark : .none
        guard let checkmarkLabel = cell.viewWithTag(1001) as? UILabel else { return }
        checkmarkLabel.text = item.isChecked ? "√" : ""
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
            //label.text = "\(item.itemID): \(item.text)"
        }
    }
    
    // MARK: - Actions
}

// MARK: - Table View Data Source
extension ChecklistViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = self.checklist.items[indexPath.row]
        self.configureText(for: cell, with: item)
        self.configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Table View Delegate
extension ChecklistViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let item = self.checklist.items[indexPath.row]
        item.isChecked.toggle()
        
        self.configureCheckmark(for: cell, with: item)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Item Detail View Controller Delegage
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let indexPath = IndexPath(row: self.checklist.items.count, section: 0)
        self.checklist.items.append(item)
        
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = self.checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) {
                self.configureText(for: cell, with: item)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
