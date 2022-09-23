//
//  HomeRouter.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit

class HomeRouter: HomeRouterInput {
    
    var viewController: HomeViewController!
    
    func routeToPhotoDetail(photo: Photo) {
        let photoDetailConfigurator = PhotoDetailModuleConfigurator()
        let photoDetailViewController = PhotoDetailViewController()
        photoDetailConfigurator.configureModuleForViewInput(viewInput: photoDetailViewController)
        photoDetailViewController.moduleInput.initializeModule(photo: photo)
        
        let navigationController = UINavigationController(rootViewController: photoDetailViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        
        viewController.present(navigationController, animated: true)
    }
}
