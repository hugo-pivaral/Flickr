//
//  PhotoCollectionViewCell.swift
//  Flickr
//
//  Created by Hugo Pivaral on 21/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    // MARK: Propeties
    
    var manager: PhotoLoadManager!
    
    
    // MARK: Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        manager.cancelImageLoad(for: photoImageView.uuid)
        photoImageView.image = nil
    }
    
    override var reuseIdentifier: String? {
        "PhotoCollectionViewCell"
    }
    
    
    // MARK: Views
    
    private var photoImageView: LoadableImageView! {
        didSet {
            photoImageView.clipsToBounds = true
            photoImageView.layer.cornerRadius = 1.0
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.backgroundColor = UIColor.secondarySystemBackground
        }
    }
    
    
    // MARK: Helpers
    
    func configure(with photo: Photo, manager: PhotoLoadManager) {
        self.manager = manager
        
        if let imageUrl = photo.thumbnailUrl {
            photoImageView.loadImage(from: imageUrl, with: manager)
        }
    }
    
    private func setUpViews() {
        photoImageView = LoadableImageView()
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2.5)
            make.height.greaterThanOrEqualTo(50)
        }
    }
}
