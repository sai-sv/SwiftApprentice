//
//  ViewController.swift
//  StoreSearch
//
//  Created by Sergei Sai on 08.02.2022.
//

/* Localize command:
 find ./ -name \*.swift -print0 | xargs -0  genstrings -o /Users/sais/Desktop/UIkitApprentice/StoreSearch/StoreSearch/Resources/en.lproj
 */

import UIKit

class SearchViewController: UIViewController {
    
    // The variable is an optional because it will be nil when the app runs on an iPhone.
    weak var splitViewDetail: DetailViewController?
    
    private struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    private let search = Search()
    private var landscapeVC: LandscapeViewController?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Search", comment: "Split vew primary button")
        
        // This tells the table view to add a 51-point margin at the top to account for the Search Bar.
        // update 1: 47 after deleting gap between the search bar and the status bar (4 points)
        // update 2: 91 after adding toolbar (44 points)
        tableView.contentInset = UIEdgeInsets(top: 91, left: 0, bottom: 0, right: 0)
        
        // Register UINib
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        switch newCollection.verticalSizeClass {
        case .compact:
            if newCollection.horizontalSizeClass == .compact {
                showLandscape(with: coordinator)
            }
        case .regular, .unspecified:
            hideLandscape(with: coordinator)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let dstVC = segue.destination as? DetailViewController,
           let indexPath = sender as? IndexPath {
            if case .results(let results) = search.state {
                dstVC.searchResult = results[indexPath.row]
                dstVC.isPopUp = true
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    // MARK: - Helper Methods
    private func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Error alert: title"),
                                      message: NSLocalizedString("There was an error reading from the iTunes Store. Please try again.",
                                                                 comment: "Error alert: message"),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Error alert action: OK"), style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func performSearch() {
        guard let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        search.performSearch(for: searchBar.text!, category: category) { success in
            if !success {
                self.showNetworkError()
            }
            self.tableView.reloadData()
            self.landscapeVC?.searchResultsReceived()
        }
        
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    private func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        guard landscapeVC == nil else { return }
        
        landscapeVC = storyboard?.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController
        if let controller = landscapeVC {
            // deprecated note:
            /*
             You have to be sure to set searchResults before you access the view property from the LandscapeViewController,
             because that will trigger the view to be loaded and call viewDidLoad().
             The view controller will read from the searchResults array in viewDidLoad() to build up
             the contents of its scroll view. But if you access controller.view before setting searchResults,
             this property will still be nil and no buttons will be created. The order in which you do things matters here!
             */
            controller.search = search
            
            controller.view.frame = view.bounds
            view.addSubview(controller.view) // That method will then take care of sending the “willMove to parent” message.
            addChild(controller)
            
            controller.view.alpha = 0
            
            coordinator.animate { _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder() // hide keyboard if shown
                
                // Hide Detail View Controller
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            } completion: { _ in
                controller.didMove(toParent: self)
            }
        }
    }
    
    private func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeVC {
            controller.willMove(toParent: nil)
            
            coordinator.animate { _ in
                controller.view.alpha = 0
                
                // Hide the pop-up on rotation
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            } completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParent() // That method will then take care of sending the “didmove to parent” message.
                self.landscapeVC = nil
            }
        }
    }
    
    private func hidePrimaryPane() {
        UIView.animate(withDuration: 0.25) {
            self.splitViewController?.preferredDisplayMode = .secondaryOnly
        } completion: { _ in
            self.splitViewController?.preferredDisplayMode = .automatic
        }
    }
    
}

// MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .notSearchedYet:
            return 0
        case .loading:
            return 1
        case .noResults:
            return 1
        case let .results(results):
            return results.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .notSearchedYet:
            fatalError("Should never get here")
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        case let .results(results):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell,
                                                     for: indexPath) as! SearchResultCell
            
            let searchResult = results[indexPath.row]
            cell.configure(for: searchResult)
            
            return cell
        }
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch search.state {
        case .notSearchedYet, .loading, .noResults:
            return nil
        case .results:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        /*
         Note: To determine whether the app is running on an iPhone, you look at the horizontal size class of the window’s root view controller,
         which is the UISplitViewController. On the iPhone, the horizontal size class is always compact — well,
         almost always since there are some exceptions, but more about that shortly. On the iPad it is always regular.
         The reason you’re looking at the size class from the root view controller and not SearchViewController is that the latter’s size class
         is always horizontally compact, even on iPad, because it sits inside the split view’s primary pane.
         */
        if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact { // iPhone
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "ShowDetail", sender: indexPath)
        } else { // iPad
            if case .results(let results) = search.state {
                splitViewDetail?.searchResult = results[indexPath.row]
            }
            
            // Hide primary pane
            // The .oneBesideSecondary mode only applies in landscape, so this says,
            // “if the split view is not in landscape, hide the primary pane when a row gets tapped.”
            if splitViewController?.displayMode != .oneBesideSecondary {
                hidePrimaryPane()
            }
        }
    }
    
}

// MARK: - Search Bar Delegage
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    // There’s a delegate method for UINavigationBar and UISearchBar items
    // which allows the item to indicate its top position.
    // (delete gap between the search bar and the status bar)
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
