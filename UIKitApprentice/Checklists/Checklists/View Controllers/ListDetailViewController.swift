//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Sergei Sai on 29.01.2022.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Large Titles For This View Controller
        self.navigationItem.largeTitleDisplayMode = .never
        
        if let checklistToEdit = self.checklistToEdit {
            self.title = "Edit Checklist"
            self.textField.text = checklistToEdit.name
            self.doneBarButton.isEnabled = true
            self.iconName = checklistToEdit.iconName
        }
        
        self.iconImage.image = UIImage(named: self.iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            if let dstVC = segue.destination as? IconPickerViewController {
                dstVC.delegate = self
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func done() {
        if let checklistToEdit = self.checklistToEdit {
            checklistToEdit.name = self.textField.text!
            checklistToEdit.iconName = self.iconName
            self.delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: self.iconName)
            self.delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    @IBAction func cancel() {
        self.delegate?.listDetailViewControllerDidCancel(self)
    }
}

// MARK: - Table View Delegage
extension ListDetailViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
}

// MARK: - Text Field Delegate
extension ListDetailViewController: UITextFieldDelegate {
    
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

// MARK: - Icon Picker Delegate
extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        self.iconImage.image = UIImage(named: self.iconName)
        self.navigationController?.popViewController(animated: true)
    }
}
