//
//  PhotoDetailPhotoDetailViewController.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 22/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit
import SnapKit

class PhotoDetailViewController: UIViewController, NavigationBarStyle {
    
    // MARK: Views
    
    private var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 6.0
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    private var imageView: LoadableImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    private var closeBarButtonItem: UIBarButtonItem! {
        didSet {
            closeBarButtonItem.tintColor = .white
            closeBarButtonItem.image = UIImage(systemName: "xmark")
            closeBarButtonItem.target = self
            closeBarButtonItem.action =  #selector(didTapCloseButton(_:))
        }
    }
    
    // MARK: Properties

    var output: PhotoDetailViewOutput!

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.9)
        setUpViews()
        clearStyle()
        
        output.viewIsReady()
    }
    
    
    // MARK: Actions
    
    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        output.didTapCloseButton()
    }
    
    
    // MARK: Helper methods
    
    private func setUpViews() {
        closeBarButtonItem = UIBarButtonItem()
        navigationItem.setRightBarButton(closeBarButtonItem, animated: false)
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView = LoadableImageView()
        scrollView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.center = scrollView.center
    }
}

// MARK: PhotoDetailViewInput methods

extension PhotoDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


// MARK: PhotoDetailViewInput methods

extension PhotoDetailViewController: PhotoDetailViewInput {
    
    var moduleInput: PhotoDetailModuleInput {
        output as! PhotoDetailModuleInput
    }
    
    func dismissModule() {
        dismiss(animated: true)
    }
    
    func setupInitialState(photoURL: URL) {
        imageView.loadImage(from: photoURL, with: PhotoLoadManager())
    }
}
