//
//  NewsFeedCell.swift
//  VKDemo
//
//  Created by Admin on 28.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit



class NewsFeedCell: UITableViewCell {
    
    static let id = "ReuseCell"
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    func configure(with model: NewsFeedCellViewModel) {

        iconImageView.set(imageURL: model.icon)
        nameLabel.text = model.name
        dateLabel.text = model.date
        postTextLabel.text = model.text
        
        /*if let photoAttachment = model.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoURL)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }*/
        
        likesLabel.text = model.likes
        commentsLabel.text = model.comments
        sharesLabel.text = model.reposts
        viewsLabel.text = model.views
        
        postTextLabel.frame = model.sizes.textFrame
        postImageView.frame = model.sizes.photoAttachmentFrame
        bottomView.frame = model.sizes.bottomViewFrame
    }    
}
