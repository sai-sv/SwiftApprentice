//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Sergei Sai on 04.02.2022.
//
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject {

    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photURL: URL {
        assert(photoID != nil, "No photoID set!")
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationsDocumentDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let nextPhotoId = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(nextPhotoId, forKey: "PhotoID")
        return nextPhotoId
    }
    
    func removePhotoFile() {
        guard hasPhoto else { return }
        do {
            try FileManager.default.removeItem(at: photURL)
        } catch {
            print("Error removing file: \(error)")
        }
    }
}

// MARK: - Map Kit Annotation
extension Location: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? {
        locationDescription.isEmpty ? "(No Description)" : locationDescription
    }
    
    public var subtitle: String? {
        category
    }
}
