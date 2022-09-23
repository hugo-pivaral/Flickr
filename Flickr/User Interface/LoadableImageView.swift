//
//  LoadableImageView.swift
//  Flickr
//
//  Created by Hugo Pivaral on 21/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

class LoadableImageView: UIImageView {
    
    // MARK: Parameters
    
    var uuid: UUID!
    var manager: PhotoLoadManager!
    
    
    // MARK: Views
    
    var activityIndicator: UIActivityIndicatorView? {
        didSet {
            activityIndicator?.style = .medium
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    // MARK: Public helpers
    
    func loadImage(from url: URL, with manager: PhotoLoadManager) {
        showActivityIndicator()
        self.manager = manager
        
        self.uuid = manager.loadImage(from: url) { [weak self] result in
            self?.hideActivityIndicator()
            
            switch result {
            case .success(let image):
                self?.image = image
            case .failure(_):
                self?.image = nil
            }
        }
    }
    
    func cancelImageLoad() {
        guard let uuid = uuid else { return }
        manager?.cancelImageLoad(for: uuid)
        hideActivityIndicator()
    }
    
    
    // MARK: Private helpers
    
    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        self.addSubview(activityIndicator!)
        
        activityIndicator?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator?.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator?.removeFromSuperview()
    }
}

