//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Sergei Sai on 09.02.2022.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // NOTE: The awakeFromNib() method is called after the cell object has been loaded from the nib
        // but before the cell is added to the table view.
        // awakeFromNib() is called some time after init?(coder) and also after
        // the objects from the nib have been connected to their outlets.
        
        // The view from that property is placed on top of the cell’s background,
        // but below the other content, when the cell is selected.
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        artistNameLabel.text = result.artist.isEmpty
        ? NSLocalizedString("Unknown", comment: "Localized artist name in cell: Unknown")
        : String(format: NSLocalizedString("ARTIST_NAME_LABEL_FORMAT",
                                           comment: "Format for  artist name"), result.artist, result.type)
        
        artworkImageView.image = UIImage(systemName: "square")
        if let url = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: url)
        }
    }
    
}
