//
//  PhotoDetailPhotoDetailInitializer.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 22/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit

class PhotoDetailModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var photodetailViewController: PhotoDetailViewController!

    override func awakeFromNib() {

        let configurator = PhotoDetailModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: photodetailViewController)
    }

}
