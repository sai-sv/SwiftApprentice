//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Sergei Sai on 13.02.2022.
//

import UIKit

class LandscapeViewController: UIViewController {

    var search: Search!
    
    private var firstTime = true
    private var downloads = [URLSessionDownloadTask]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        pageControll.removeConstraints(pageControll.constraints)
        pageControll.translatesAutoresizingMaskIntoConstraints = true
        
        // Pattern Image Background
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        
        pageControll.numberOfPages = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // The viewWillLayoutSubviews() method is called by UIKit as part
        // of the layout phase of your view controller when it first appears on screen.
        
        /*
         The scroll view should always be as large as the entire screen, so you would think that you should make its frame equal
         to the main view’s bounds. This used to be the case till Apple introduced the iPhone X. But things change ...
         With the iPhone X, you had to make sure that your content did not appear where the iPhone X’s notch was,
         or where the scroll bar appeared at the bottom of the screen.
         So, Apple introduced the safe area concept — iOS would tell you what parts of a view were safe to have content
         on and each view would have several properties which defined the safe area for that view.
         */
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        scrollView.frame = safeFrame
        
        pageControll.frame = CGRect(x: safeFrame.origin.x,
                                    y: safeFrame.size.height - pageControll.frame.size.height,
                                    width: safeFrame.size.width,
                                    height: pageControll.frame.size.height)
        
        if firstTime {
            /*
             You may think that viewDidLoad() would be a good place for this, but at the point in the view controller’s lifecycle
             when viewDidLoad() is called, the view is not on the screen yet and has not been added into the view hierarchy.
             At this time, it doesn’t know how large the view should be.
             Only after viewDidLoad() is done does the view get resized to fit the actual screen.
             */
            firstTime = false
            switch search.state {
            case .results(let results):
                tileButtons(results)
            case .loading:
                showSpinner()
            case .noResults:
                showNothingFoundLabel()
            case .notSearchedYet:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if case .results(let results) = search.state {
                let dstVC = segue.destination as! DetailViewController
                let searchResult = results[(sender as! UIButton).tag -  2000]
                dstVC.searchResult = searchResult
                dstVC.isPopUp = true
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func pageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.width * CGFloat(sender.currentPage), y: 0)
        }, completion: nil )
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowDetail", sender: sender)
    }
    
    // MARK: - Helper Methods
    func searchResultsReceived() {
        hideSpinner()
        
        switch search.state {
        case .results(let results):
            tileButtons(results)
        case .noResults:
            showNothingFoundLabel()
        case .notSearchedYet, .loading:
            break;
        }
    }
    
    private func tileButtons(_ searchResults: [SearchResult]) {
        let itemWidth: CGFloat = 94
        let itemHeight: CGFloat = 88
        let viewWidth = UIScreen.main.bounds.size.width
        let viewHeight = UIScreen.main.bounds.size.height
        
        var columnsPerPage = 0
        var rowsPerPage = 0
        
        var marginX: CGFloat = 0
        var marginY: CGFloat = 0
        
        columnsPerPage = Int(viewWidth / itemWidth)
        rowsPerPage = Int(viewHeight / itemHeight)
        
        marginX = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) * 0.5 // divide the result by 2 to get the padding on the left and right
        marginY = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) * 0.5 // divide the result by 2 to get the padding on the top and bottom
        
        let buttonWidth: CGFloat = 82
        let buttonHeigh: CGFloat = 82
        
        let paddingHorz = (itemWidth - buttonWidth) / 2 // item horizontaly padding [leftPadding:item:rightPadding]
        let paddingVert = (itemHeight - buttonHeigh) / 2 // item vertical padding [topPadding:item:bottomPadding]
        
        // Add buttons
        var row = 0
        var column = 0
        var x = marginX
        
        // Add the buttons
        for (index, result) in searchResults.enumerated() {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
            //button.setTitle("\(index)", for: .normal)
            
            button.tag = 2000 + index
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row) * itemHeight + paddingVert,
                                  width: buttonWidth, height: buttonHeigh)
            downloadImage(for: result, andPlaceOn: button)
            scrollView.addSubview(button)
            
            row += 1
            if row == rowsPerPage {
                row = 0
                x += itemWidth
                column += 1
                if column == columnsPerPage {
                    column = 0
                    x += marginX * 2
                }
            }
        }
        
        // Set Scroll View Content Size
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth,
                                        height: scrollView.bounds.size.height)
        
        print("Number of Pages: \(numPages)")
        pageControll.numberOfPages = numPages
        pageControll.currentPage = 0
    }
    
    private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
        if let url = URL(string: searchResult.imageSmall) {
            let task = URLSession.shared.downloadTask(with: url) { [weak button] url, _, error in
                if error == nil, let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        button?.setBackgroundImage(image, for: .normal)
                    }
                }
            }
            task.resume()
            downloads.append(task)
        }
    }
    
    private func showSpinner() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = CGPoint(x: scrollView.bounds.midX + 0.5,
                                 y: scrollView.bounds.midY + 0.5)
        spinner.tag =  1000
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    private func hideSpinner() {
        if let spinner = view.viewWithTag(1000) as? UIActivityIndicatorView {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
    private func showNothingFoundLabel() {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("Nothing Found", comment: "Localized label: Nothing Found")
        label.textColor = .label // system label color
        label.backgroundColor = .clear // transparent
        
        label.sizeToFit()
        
        /*
         If you divide a number such as 11 by 2 you get 5.5. The ceil() function rounds up 5.5 to make 6,
         and then you multiply by 2 to get a final value of 12. This formula always gives you the next even number
         if the original is odd. You only need to do this because these values have type CGFloat.
         If they were integers, you wouldn’t have to worry about fractional parts.
         */
        var rect = label.frame
        rect.size.width = ceil(rect.size.width / 2) * 2
        rect.size.height = ceil(rect.size.height / 2) * 2
        label.frame = rect
        
        label.center = CGPoint(x: scrollView.bounds.midX + 0.5,
                                 y: scrollView.bounds.midY + 0.5)
        view.addSubview(label)
    }
}

// MARK: - Scroll View Delegate
extension LandscapeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControll.currentPage = page
    }
}
