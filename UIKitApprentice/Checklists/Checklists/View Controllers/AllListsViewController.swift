//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Sergei Sai on 29.01.2022.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        // Enable Large Titles
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
        
        let index = self.dataModel.indexOfSelectedChecklist
        if index >= 0 && index < self.dataModel.lists.count {
            self.performSegue(withIdentifier: "ShowChecklist", sender: dataModel.lists[index])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            if let dstVC = segue.destination as? ChecklistViewController,
               let checklist = sender as? Checklist {
                dstVC.checklist = checklist
            }
        } else if segue.identifier == "AddChecklist" {
            if let dstVC = segue.destination as? ListDetailViewController {
                dstVC.delegate = self
            }
        }
    }
}

// MARK: - Table View Data Source
extension AllListsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        
        if checklist.items.count == 0 {
            cell.detailTextLabel?.text = "(No Items)"
        } else {
            let count = checklist.countUncheckedItems();
            cell.detailTextLabel?.text = count == 0 ? "All Done" : "\(checklist.countUncheckedItems()) Remaining"
        }
        
        cell.accessoryType = .detailDisclosureButton
        
        cell.imageView?.image = UIImage(named: checklist.iconName)
        
        return cell
    }
}

// MARK: - Table View Delegate
extension AllListsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        self.performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController")
                as? ListDetailViewController else { return }
        
        controller.delegate = self
        controller.checklistToEdit = dataModel.lists[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Table View Data Source
extension AllListsViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - List Detail View Controller Delegage
extension AllListsViewController: ListDetailViewControllerDelegate {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        // 1.
        //let newRowIndex = dataModel.lists.count
        
        self.dataModel.lists.append(checklist)
        self.dataModel.sortChecklists()
        
        self.tableView.reloadData() // replace 1 & 2
        
        // 2.
        //self.tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .automatic)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        // 1.
        /*if let index = dataModel.lists.firstIndex(of: checklist),
           let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.textLabel?.text = checklist.name
        }*/
        self.dataModel.sortChecklists()
        self.tableView.reloadData() // replace 1
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation Controller Delegate
extension AllListsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self { // Was the back button tapped?
            self.dataModel.indexOfSelectedChecklist = -1
        }
    }
}

