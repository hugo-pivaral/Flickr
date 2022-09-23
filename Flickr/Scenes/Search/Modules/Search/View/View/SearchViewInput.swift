//
//  SearchSearchViewInput.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit

protocol SearchViewInput: AnyObject {

    var moduleInput: SearchModuleInput { get }

    func showActivityIndicator()
    func hideActivityIndicator()
    func showEmtpySateView(message: String)
    func hideEmptyStateView()
    func setupInitialState(photoManager: PhotoLoadManager)
    func setPhotosList(_ list: [Photo])
    func appendToPhotosList(_ list: [Photo])
}
