//
//  LocationCell.swift
//  MyLocations
//
//  Created by Sergei Sai on 04.02.2022.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Rounded corners for images
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        photoImageView.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for location: Location) {
        photoImageView.image = thumbnail(for: location)
        descriptionLabel.text = location.locationDescription.isEmpty ? "(No Description)" : location.locationDescription
        
        if let placemark = location.placemark {
            var text = ""
            text.add(text: placemark.subThoroughfare)
            text.add(text: placemark.thoroughfare, separatedBy: " ")
            text.add(text: placemark.locality, separatedBy: ", ")
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
    }
    
    func thumbnail(for location: Location) -> UIImage {
        guard location.hasPhoto, let image = location.photoImage else {
            return UIImage(named: "No Photo")!
        }
        return image.resized(withBounds: CGSize(width: 52, height: 52))
    }

}
