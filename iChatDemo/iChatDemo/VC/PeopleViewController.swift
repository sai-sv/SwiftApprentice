//
//  PeopleViewController.swift
//  iChatDemo
//
//  Created by Admin on 11.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    
    enum CollectionViewSection: Int, CaseIterable {
        case Users
        
        func description(usersCount: Int) -> String {
            switch self {
            case .Users:
                return "\(usersCount) people nearby"
            }
        }
    }
    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<CollectionViewSection, UserModel>!
    
    private var model: [UserModel] = [] //= Bundle.main.decode([UserModel].self, from: "users.json")
    private var currentUser: UserModel
    private var listner: ListenerRegistration?
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        listner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupSignOutItem()
        
        setupCollectionView()
        collectionViewData()
        
        title = currentUser.username
        
        // realtime firestore update
        listner = StorageListner.shared.observe(users: model, completion: { (result) in
            switch result {
            case .success(let users):
                self.model = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        })
        
        collectionView.delegate = self
    }
    
    private func setupSignOutItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOutAction))
    }
    
    @objc private func signOutAction() {
        let alert = UIAlertController(title: nil, message: "Are you shure want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print(#function + " sign out error: " + error.localizedDescription)
            }
        }))
        present(alert, animated: true)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .whiteColor
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.obscuresBackgroundDuringPresentation = true
        searchBarController.searchBar.delegate = self
        
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .whiteColor
        
        collectionView.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewSectionHeader.reuseId)
        collectionView.register(UserChatCell.self, forCellWithReuseIdentifier: UserChatCell.id)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

// MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userModel = self.collectionViewDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let profileVC = ProfileViewController(userModel: userModel)
        self.present(profileVC, animated: true)
    }
}

// MARK: - Collection View Layout
extension PeopleViewController {
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            guard let section = CollectionViewSection(rawValue: sectionIndex) else {
                fatalError("Unknown section")
            }
            
            switch section {
            case .Users:
                return self.usersSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func usersSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
        
        let headerSection = createHeaderSection()
        section.boundarySupplementaryItems = [headerSection]
        
        return section
    }
    
    private func createHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
}

// MARK: - Collection View Data Source
extension PeopleViewController {
    
    private func collectionViewData() {
        // items
        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                                      cellProvider: { (collectionView, indexPath, itemData) -> UICollectionViewCell? in
            
            guard let section = CollectionViewSection(rawValue: indexPath.section) else {
                fatalError("Unknown section")
            }
            
            switch section {
            case .Users:
                return self.collectionViewCell(collectionView, type: UserChatCell.self, with: itemData, by: indexPath)
            }
        })
        
        // header
        collectionViewDataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: CollectionViewSectionHeader.reuseId,
                                                                                      for: indexPath) as? CollectionViewSectionHeader else {
                fatalError("Unknown section")
            }
            
            guard let section = CollectionViewSection(rawValue: indexPath.section) else {
                fatalError("Unknown section")
            }
            let items = self.collectionViewDataSource.snapshot().itemIdentifiers(inSection: .Users)
            headerSection.configure(title: section.description(usersCount: items.count),
                                    font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
            return headerSection
        }
    }
    
    private func reloadData(with filter: String?) {
        
        let filteredModel = model.filter { (user) -> Bool in
            user.contains(filter: filter)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, UserModel>()
        snapshot.appendSections([.Users])
        snapshot.appendItems(filteredModel, toSection: .Users)
        
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
    typealias ProviderType = PeopleVCProvider
    typealias VCType = MainTabBarController
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = VCType()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderType.ContainerView>) -> VCType {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: ProviderType.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderType.ContainerView>) {
        }
    }
}
