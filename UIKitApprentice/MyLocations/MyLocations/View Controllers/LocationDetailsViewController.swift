//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Sergei Sai on 02.02.2022.
//

import UIKit
import CoreLocation
import CoreData

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class LocationDetailsViewController: UITableViewController {
    
    // Core Data
    var managedObjectContext: NSManagedObjectContext!
    var locationToEdit: Location? {
        didSet {
            if let locationToEdit = locationToEdit {
                descriptionText = locationToEdit.locationDescription
                categoryName = locationToEdit.category
                coordinate = CLLocationCoordinate2D(latitude: locationToEdit.latitude,
                                                    longitude: locationToEdit.longitude)
                placemark = locationToEdit.placemark
                date = locationToEdit.date
            }
        }
    }
    
    var descriptionText = ""
    var categoryName = "No Category"
    var image: UIImage? {
        didSet {
            if let image = image {
                show(image: image)
            }
        }
    }
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var date = Date()
    
    var observer: Any!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locationToEdit = locationToEdit {
            title = "Edit Location"
            
            if locationToEdit.hasPhoto {
                //!!! what you don’t do here: the Location’s image is not assigned to the image instance variable.
                // If the user doesn’t change the photo, then you don’t need to write it out to a file again
                if let theImage = locationToEdit.photoImage {
                    show(image: theImage)
                }
            }
        }
        
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "Not Found"
        }
        dateLabel.text = format(date: date)
        
        // Hide Keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        // Notification from UIScene Delegate
        listenForBackgroundNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let dstVC = segue.destination as! CategoryPickerViewController
            dstVC.selectedCategoryName = categoryName
        }
    }
    
    // MARK: - Helper Methods
    func string(from placemark: CLPlacemark) -> String {
        var line = ""
        line.add(text: placemark.subThoroughfare)
        line.add(text: placemark.thoroughfare, separatedBy: ", ")
        line.add(text: placemark.locality, separatedBy: ", ")
        line.add(text: placemark.administrativeArea, separatedBy: " ")
        line.add(text: placemark.postalCode, separatedBy: ", ")
        line.add(text: placemark.country, separatedBy: ", ")
        return line
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imageHeight.constant = 260
        
        addPhotoLabel.text = ""
        tableView.reloadData()
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point),
           indexPath.section == 0, indexPath.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }
    
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: UIScene.didEnterBackgroundNotification,
                                                          object: nil,
                                                          queue: OperationQueue.main) { [weak self] _ in
            guard let self = self else { return }
            if self.presentedViewController != nil { // modal active: ActionSheet or ImagePickerController
                self.dismiss(animated: true) // close modal screen
            }
            self.descriptionTextView.resignFirstResponder()
        }
    }
    
    // MARK: - Actions
    @IBAction func done() {
        guard let mainView = navigationController?.parent?.view else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        
        // Create Core Data Entity
        let location: Location
        
        if let locationToEdit = locationToEdit {
            hudView.text = "Updated"
            location = locationToEdit
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
            location.photoID = nil
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        
        // Save Image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        // Save Core Data Entity
        do {
            try managedObjectContext.save()
            
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // unwind segue
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let sourceVC = segue.source as! CategoryPickerViewController
        categoryName = sourceVC.selectedCategoryName
        categoryLabel.text = categoryName
    }
}

// MARK: - Table View Delegate
extension LocationDetailsViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
}

// MARK: - Image Picker Helper Methods
extension LocationDetailsViewController {
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let takePhotolAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.takePhotoWithCamera()
        }
        alert.addAction(takePhotolAction)
        
        let choosePhotoAction = UIAlertAction(title: "Choose From Library", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alert.addAction(choosePhotoAction)
        
        present(alert, animated: true)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}

// MARK: - Image Picker Controller Delegate
extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
