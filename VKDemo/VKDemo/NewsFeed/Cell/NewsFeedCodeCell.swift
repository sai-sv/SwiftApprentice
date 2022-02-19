//
//  NewsFeedCodeCell.swift
//  VKDemo
//
//  Created by Admin on 10.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class NewsFeedCodeCell: UITableViewCell {
    
    static let id = "ReuseId"
    
    weak var delegate: NewsFeedCodeCellDelegate?
    
    private var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        return view
    }()
    
    private var postTextLabel: UITextView = {
       var textView = UITextView()
        textView.font = Constants.postTextFont
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .all
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        return textView
    }()
    
    private var postImageView: WebImageView = {
        let imageView = WebImageView()
//        imageView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return imageView
    }()
    
    private let galleryCollectionView = GalleryCollectionView()
    
    private var bottomView: UIView = {
        var view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    
    // MARK: - topView layers
    private var iconImageView: WebImageView = {
        let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
//        label.backgroundColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        label.textColor = #colorLiteral(red: 0.227329582, green: 0.2323184013, blue: 0.2370472848, alpha: 1)
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
//        label.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        return label
    }()
    
    // MARK: - bottomView - likes layer
    private var likesView: UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var likesImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "like")
//        image.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return image
    }()
    
    var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        return label
    }()
    
    // MARK: bottomView - comments layer
    private var commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        return view
    }()
    
    private var commentsImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "comment")
//        image.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return image
    }()
    
    private var commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        return label
    }()
    
    // MARK: - bottomView - shares layer
    private var sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = #colorLiteral(red: 0.03537632042, green: 0.5067929482, blue: 0.3727167694, alpha: 1)
        return view
    }()
    
    private var sharesImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "share")
//        image.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return image
    }()
    
    private var sharesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        return label
    }()
    
    // MARK: - bottomView - views
    private var viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.1921568627, alpha: 1)
        return view
    }()
    
    private var viewsImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "eye")
//        image.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return image
    }()
    
    private var viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        return label
    }()
    
    // MARK: - show more button
    private var showMoreTextButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitle("Показать больше...", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    // MARK: - Layers
    private func setupLayers() {
        setupMainLayer()
        setupFirstSublayer()
        setupTopViewLayer()
        setupBottomViewLayer()
    }
    
    private func setupMainLayer() {
        addSubview(cardView)
        
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cardViewInsets.top).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardViewInsets.left).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardViewInsets.right).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.cardViewInsets.bottom).isActive = true
    }
    
    private func setupFirstSublayer() {
        cardView.addSubview(topView)
        cardView.addSubview(postTextLabel)
        cardView.addSubview(showMoreTextButton)
        cardView.addSubview(postImageView)
        cardView.addSubview(galleryCollectionView)
        cardView.addSubview(bottomView)
        
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
    }
    
    private func setupTopViewLayer() {
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        iconImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: (Constants.topViewHeight / 2) - 2).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    private func setupBottomViewLayer() {
        
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)
        
        likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor).isActive = true
        sharesView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor).isActive = true
        viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        
        setupSubviewInBottomView(view: likesView, imageView: likesImageView, label: likesLabel)
        setupSubviewInBottomView(view: commentsView, imageView: commentsImageView, label: commentsLabel)
        setupSubviewInBottomView(view: sharesView, imageView: sharesImageView, label: sharesLabel)
        setupSubviewInBottomView(view: viewsView, imageView: viewsImageView, label: viewsLabel)
    }
    
    private func setupSubviewInBottomView(view: UIView, imageView: UIImageView, label: UILabel) {
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        view.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: Constants.bottomViewHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: Constants.bottomViewSubviewWidth).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.bottomViewSubviewIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.bottomViewSubviewIconSize).isActive = true
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // show more text button action
        showMoreTextButton.addTarget(self, action: #selector(showMoreTextButtonAction), for: .touchUpInside)
        
        iconImageView.layer.cornerRadius = Constants.topViewHeight / 2
        iconImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func showMoreTextButtonAction() {
        delegate?.revealPost(for: self)
    }
    
    func configure(with model: NewsFeedCellViewModel) {
        
        iconImageView.set(imageURL: model.icon)
        nameLabel.text = model.name
        dateLabel.text = model.date
        postTextLabel.text = model.text
        
        if let photo = model.photoAttachments.first, model.photoAttachments.count == 1 {
            postImageView.set(imageURL: photo.photoURL)
            postImageView.frame = model.sizes.photoAttachmentFrame
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
        } else if model.photoAttachments.count > 1 {
            galleryCollectionView.set(model: model.photoAttachments)
            galleryCollectionView.frame = model.sizes.photoAttachmentFrame
            galleryCollectionView.isHidden = false
            postImageView.isHidden = true
        }  else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
        
        likesLabel.text = model.likes
        commentsLabel.text = model.comments
        sharesLabel.text = model.reposts
        viewsLabel.text = model.views
        
        postTextLabel.frame = model.sizes.textFrame
        showMoreTextButton.frame = model.sizes.moreTextButtonFrame
        bottomView.frame = model.sizes.bottomViewFrame
    }
}
