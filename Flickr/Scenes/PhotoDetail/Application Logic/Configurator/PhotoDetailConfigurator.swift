//
//  PhotoDetailPhotoDetailConfigurator.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 22/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit

class PhotoDetailModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? PhotoDetailViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: PhotoDetailViewController) {

        let router = PhotoDetailRouter()

        let presenter = PhotoDetailPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = PhotoDetailInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
