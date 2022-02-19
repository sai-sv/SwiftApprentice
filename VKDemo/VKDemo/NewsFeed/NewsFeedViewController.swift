//
//  NewsFeedViewController.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {
    
    @IBOutlet weak var tableView: UITableView!
    private var titleView = TitleView()
    private var topRefreshIndicator: UIRefreshControl = {
        var control = UIRefreshControl()
        control.addTarget(self, action: #selector(topRefreshAction), for: .valueChanged)
        return control
    }()
    private lazy var footerView = FooterView()
    private var model = FeedViewModel(cells: [], footerTitle: nil)
    
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    
    // MARK: Object lifecycle
    
    /*override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
     super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
     setup()
     }
     
     required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     setup()
     }*/
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTopBars()
        setupTableView()
        
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUsers)
    }
    
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayNewsFeed(let viewModel):
            model = viewModel
            tableView.reloadData()
            topRefreshIndicator.endRefreshing()
            footerView.setTitle(title: viewModel.footerTitle)
        case .displayUserInfo(let viewModel):
            titleView.set(viewModel: viewModel)
        case .displayFooterRefreshControl:
            footerView.showIndicator()
        }
    }
    
    private func setupTopBars() {
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.titleView = titleView
    }
    
    private func setupTableView() {
        tableView.contentInset.top = 8
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: NewsFeedCell.id)
        tableView.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.id)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.addSubview(topRefreshIndicator)
        tableView.tableFooterView = footerView
    }
    
    @objc private func topRefreshAction() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.id, for: indexPath) as! NewsFeedCell
        //        let cellViewModel = model.cells[indexPath.row]
        //        cell.configure(with: cellViewModel)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.id, for: indexPath) as! NewsFeedCodeCell
        let cellViewModel = model.cells[indexPath.row]
        cell.configure(with: cellViewModel)
        
        // handle show more text button touch action
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = model.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = model.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

extension NewsFeedViewController {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height * 0.9) {
            print(#function, "getNextBatch")
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
}

extension NewsFeedViewController: NewsFeedCodeCellDelegate {
    func revealPost(for cell: NewsFeedCodeCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = model.cells[indexPath.row]
        let postId = cellViewModel.postId
        
        //        print("post id: \(postId)")
        interactor?.makeRequest(request: .revealPostText(postId: postId))
    }
}
