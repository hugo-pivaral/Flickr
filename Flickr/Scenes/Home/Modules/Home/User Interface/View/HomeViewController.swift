//
//  HomeViewController.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, NavigationBarStyle {
    
    // MARK: Views
    
    private var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
            
            let refreshControl = UIRefreshControl()
            collectionView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
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

    var output: HomeViewOutput!
    
    private var photoManager: PhotoLoadManager!
    
    private var photosList: [Photo] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.refreshControl?.endRefreshing()
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
        
        primaryStyle()
        setUpViews()
        
        output.viewIsReady()
    }
    
    
    // MARK: Actions
    
    @objc private func didPullToRefresh() {
        output.didPullToRefresh()
    }
    
    @objc private func didTapRetryButton(_ sender: UIButton) {
        output.didTapRetryButton()
    }
    
    
    // MARK: Helper methods
    
    private func setUpViews() {
        flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: CollectionView Delegate & Data Source

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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


// MARK: HomeViewInput methods

extension HomeViewController: HomeViewInput {
    
    var moduleInput: HomeModuleInput {
        output as! HomeModuleInput
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
        
        let button = UIButton(configuration: UIButton.Configuration.plain())
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didTapRetryButton(_:)), for: .touchUpInside)
        emptyStateContainerView.addArrangedSubview(button)
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
    
    func showAlert(title: String, message: String, primaryAction: UIAlertAction) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(primaryAction)
        
        present(alertController, animated: true)
    }
}
