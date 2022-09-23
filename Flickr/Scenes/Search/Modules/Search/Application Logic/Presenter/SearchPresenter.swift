//
//  SearchSearchPresenter.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import UIKit

class SearchPresenter {

    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!
    
    var currentPage: Int!
    var searchText: String?
    var photoManager: PhotoLoadManager!
    var networkingTaskIsRunning: Bool!
}


// MARK: HomeModuleInput methods

extension SearchPresenter: SearchModuleInput {
    
    func initializeModule() {
        photoManager = PhotoLoadManager(compressionEnabled: false)
        networkingTaskIsRunning = false
        currentPage = 0
    }
}


// MARK: HomeViewOutput methods

extension SearchPresenter: SearchViewOutput {
    
    func didTapSearchBarSearchButton() {
        guard let searchText = searchText, !networkingTaskIsRunning else { return }
        currentPage = 0
        photoManager.clearCache()
        view.setPhotosList([])
        view.hideEmptyStateView()
        view.showActivityIndicator()
        networkingTaskIsRunning = true
        interactor.fetchFilteredPhotos(query: searchText, page: currentPage + 1)
    }
    
    func didTapSearchBarCancelButton() {
        currentPage = 0
        searchText = nil
        photoManager.clearCache()
        view.setPhotosList([])
        view.hideEmptyStateView()
        view.showEmtpySateView(message: "Type something to start searching!")
    }
    
    func searchBarTextDidChange(searchText: String) {
        self.searchText = searchText
    }
    
    func didSelectRow(with photo: Photo) {
        router.routeToPhotoDetail(photo: photo)
    }
    
    func viewIsReady() {
        view.setupInitialState(photoManager: photoManager)
        view.showEmtpySateView(message: "Type something to start searching!")
    }
    
    func willDisplayRow(at index: Int) {
        guard let searchText = searchText, !networkingTaskIsRunning else { return }
        
        let pageSize = 50
        let scrollingThreshold = (currentPage * pageSize) - 10
        
        if index == scrollingThreshold {
            networkingTaskIsRunning = true
            interactor.fetchFilteredPhotos(query: searchText, page: currentPage + 1)
        }
    }
}


// MARK: HomeInteractorOutput methods

extension SearchPresenter: SearchInteractorOutput {
    
    func didFetchFilteredPhotos(photos: [Photo], page: Int) {
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
    
    func didFailFetchingFilteredPhotos() {
        networkingTaskIsRunning = false
        
        if currentPage == 0 {
            view.hideActivityIndicator()
            view.showEmtpySateView(message: "We've searched high and low, but we can't seem to find what you are looking for right now.")
        }
    }
}
