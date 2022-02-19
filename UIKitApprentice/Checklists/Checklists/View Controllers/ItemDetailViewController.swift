//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Sergei Sai on 28.01.2022.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Large Titles For This View Controller
        self.navigationItem.largeTitleDisplayMode = .never
        
        if let item = self.itemToEdit {
            self.title = "Edit Item"
            self.textField.text = item.text
            self.doneBarButton.isEnabled = true
            self.shouldRemindSwitch.isOn = item.shouldRemind
            self.datePicker.date = item.dueDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        self.delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = self.itemToEdit {
            item.text = self.textField.text!
            item.shouldRemind = self.shouldRemindSwitch.isOn
            item.dueDate = self.datePicker.date
            item.sheduleNotification()
            self.delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: self.textField.text!,
                                     isChecked: false,
                                     shouldRemind: self.shouldRemindSwitch.isOn,
                                     dueDate: self.datePicker.date)
            item.sheduleNotification()
            self.delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // Local notification auth
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        self.textField.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { _, _ in
                // do nothing
            }
        }
    }

}

// MARK: - Table View Delegate
extension ItemDetailViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Text Field Delegate
extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        self.doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.doneBarButton.isEnabled = false
        return true
    }
}
