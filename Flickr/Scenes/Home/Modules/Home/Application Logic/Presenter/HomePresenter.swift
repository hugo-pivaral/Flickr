//
//  HomePresenter.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit

class HomePresenter {

    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!

    var currentPage: Int!
    var photoManager: PhotoLoadManager!
    var networkingTaskIsRunning: Bool!
}


// MARK: HomeModuleInput methods

extension HomePresenter: HomeModuleInput {
    
    func initializeModule() {
        photoManager = PhotoLoadManager(compressionEnabled: false)
        networkingTaskIsRunning = false
        currentPage = 0
    }
}


// MARK: HomeViewOutput methods

extension HomePresenter: HomeViewOutput {
    
    func didPullToRefresh() {
        currentPage = 0
        photoManager.clearCache()
        networkingTaskIsRunning = true
        interactor.fetchInterestingPhotos(page: currentPage + 1)
    }
    
    func didTapRetryButton() {
        currentPage = 0
        view.hideEmptyStateView()
        view.showActivityIndicator()
        networkingTaskIsRunning = true
        interactor.fetchInterestingPhotos(page: currentPage + 1)
    }
    
    func didSelectRow(with photo: Photo) {
        router.routeToPhotoDetail(photo: photo)
    }
    
    func viewIsReady() {
        view.setupInitialState(photoManager: photoManager)
        view.showActivityIndicator()
        networkingTaskIsRunning = true
        interactor.fetchInterestingPhotos(page: currentPage + 1)
    }
    
    func willDisplayRow(at index: Int) {
        guard !networkingTaskIsRunning else { return }
        
        let pageSize = 50
        let scrollingThreshold = (currentPage * pageSize) - 10
        
        if index == scrollingThreshold {
            networkingTaskIsRunning = true
            interactor.fetchInterestingPhotos(page: currentPage + 1)
        }
    }
}


// MARK: HomeInteractorOutput methods

extension HomePresenter: HomeInteractorOutput {
    
    func didFetchInterestingPhotos(photos: [Photo], page: Int) {
        networkingTaskIsRunning = false
        currentPage = page
        view.hideActivityIndicator()
        view.hideEmptyStateView()
        
        if currentPage == 1 {
            view.setPhotosList(photos)
        } else {
            view.appendToPhotosList(photos)
        }
    }
    
    func didFailFetchingInterestingPhotos() {
        networkingTaskIsRunning = false
        
        if currentPage == 0 {
            view.hideActivityIndicator()
            view.showEmtpySateView(message: "We've encountered an unexpected error. Please try again later.")
        }
    }
}
