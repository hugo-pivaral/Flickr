//
//  PhotoDetailPhotoDetailPresenter.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 22/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

class PhotoDetailPresenter {

    weak var view: PhotoDetailViewInput!
    var interactor: PhotoDetailInteractorInput!
    var router: PhotoDetailRouterInput!
    
    var photo: Photo!
}

// MARK: PhotoDetailModuleInput mehtods

extension PhotoDetailPresenter: PhotoDetailModuleInput {
    
    func initializeModule(photo: Photo) {
        self.photo = photo
    }
}


// MARK: PhotoDetailViewOutput mehtods

extension PhotoDetailPresenter: PhotoDetailViewOutput {
    
    func didTapCloseButton() {
        view.dismissModule()
    }
    
    func viewIsReady() {
        view.setupInitialState(photoURL: photo.largeUrl!)
    }
}


// MARK: PhotoDetailInteractorOutput mehtods

extension PhotoDetailPresenter: PhotoDetailInteractorOutput {
    
    
}

