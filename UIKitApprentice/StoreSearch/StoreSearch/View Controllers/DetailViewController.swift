//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Sergei Sai on 12.02.2022.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    
    var isPopUp = false
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    private enum AnimationStyle {
        case slide
        case fade // will be used when rotating to landscape
    }
    private var dismissStyle: AnimationStyle = .fade
    private var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // init?(coder) is invoked to load the view controller from the storyboard
        
        transitioningDelegate = self
    }
    
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPopUp {
            popupView.layer.cornerRadius = 10
            
            // Gesture recognizer
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            
            // Gradient View
            view.backgroundColor = UIColor.clear
            let dimmingView = GradientView(frame: .zero)
            dimmingView.frame = view.bounds
            view.insertSubview(dimmingView, at: 0)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.isHidden = true
            
            // Popover action button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                target: self, action: #selector(showPopover(_:)))
        }
        
        if searchResult != nil {
            updateUI()
        }
    }
    
    // MARK: - Actions
    @IBAction func close(_ sender: Any) {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showInStore(_ sender: UIButton) {
        if let url = URL(string: searchResult.storeUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Helper Methods
    private func updateUI() {
        // download image
        if let url = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: url)
        }
        
        nameLabel.text = searchResult.name
        
        artistNameLabel.text = searchResult.artist.isEmpty
            ? NSLocalizedString("Unknown", comment: "Localized artist name: Unknown") : searchResult.artist
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        // show price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        let priceText: String
        if searchResult.price == 0.0 {
            priceText = NSLocalizedString("Free", comment: "Localized price text: Free")
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        
        popupView.isHidden = false
    }
    
    @objc private func showPopover(_ sender: UIBarButtonItem) {
        guard let popover = storyboard?.instantiateViewController(withIdentifier: "PopoverView") as? MenuViewController else { return }
        popover.modalPresentationStyle = .popover
        popover.delegate = self
        
        if let ppc = popover.popoverPresentationController {
            ppc.barButtonItem = sender
        }
        present(popover, animated: true, completion: nil)
    }
    
}

// MARK: - Gesture Recognizer Delegate
extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // It only returns true when the touch was on the background view
        // It will return false if the touch was inside the Pop-up View.
        return (touch.view === self.view)
    }
}

// MARK: - Animation
extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}

// MARK: - Menu View Controller Delegate
extension DetailViewController: MenuViewControllerDelegate {
    
    /*
     Run the app and pick the Send Support Email menu option.
     The standard e-mail compose sheet should slide up — if you are on a device.
     This won’t work on the Simulator at all
     */
    func menuViewControllerSendEmail(_ controller: MenuViewController) {
        dismiss(animated: true) {
            if MFMailComposeViewController.canSendMail() {
                let controller = MFMailComposeViewController()
                controller.mailComposeDelegate = self
                controller.setSubject(NSLocalizedString("Support Request", comment: "Email subject"))
                controller.setToRecipients(["your@email-address-here.com"])
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Mail Compose View Controller Delegate
extension DetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
