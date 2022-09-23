//
//  SearchSearchViewController.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, NavigationBarStyle {
    
    // MARK: Views
    
    private var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        }
    }
    
    private var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "Search..."
        }
    }
    
    private var emptyStateContainerView: UIStackView! {
        didSet {
            emptyStateContainerView.axis = .vertical
            emptyStateContainerView.spacing = 16.0
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.style = .large
            activityIndicator.startAnimating()
        }
    }
    
    
    // MARK: Properties

    var output: SearchViewOutput!
    
    private var photoManager: PhotoLoadManager!
    
    private var photosList: [Photo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }
    }

    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpViews()
        
        output.viewIsReady()
    }
    
    
    // MARK: Helper methods
    
    private func setUpViews() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: CollectionView Delegate & Data Source

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = collectionView.frame.width / 3 - flowLayout.minimumInteritemSpacing
        
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photosList[indexPath.item]
        output.didSelectRow(with: selectedPhoto)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        output.willDisplayRow(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photosList[indexPath.item]
        cell.configure(with: photo, manager: photoManager)
        
        return cell
    }
}


// MARK: CollectionView Delegate & Data Source

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.searchBarTextDidChange(searchText: searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        output.didTapSearchBarCancelButton()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        output.didTapSearchBarSearchButton()
    }
}


// MARK: HomeViewInput methods

extension SearchViewController: SearchViewInput {
    
    var moduleInput: SearchModuleInput {
        output as! SearchModuleInput
    }
    
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
        }
    }
    
    func hideActivityIndicator() {
        activityIndicator?.removeFromSuperview()
    }
    
    func showEmtpySateView(message: String) {
        emptyStateContainerView = UIStackView()
        view.addSubview(emptyStateContainerView)
        
        emptyStateContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = message
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        emptyStateContainerView.addArrangedSubview(label)
    }
    
    func hideEmptyStateView() {
        emptyStateContainerView?.removeFromSuperview()
    }
    
    func setupInitialState(photoManager: PhotoLoadManager) {
        self.photoManager = photoManager
    }
    
    func setPhotosList(_ list: [Photo]) {
        photosList = list
    }
    
    func appendToPhotosList(_ list: [Photo]) {
        photosList.append(contentsOf: list)
    }
}
