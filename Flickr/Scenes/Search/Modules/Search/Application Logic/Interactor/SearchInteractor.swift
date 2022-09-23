//
//  SearchSearchInteractor.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

import Foundation

class SearchInteractor: SearchInteractorInput {

    weak var output: SearchInteractorOutput!
    lazy var networkingClient: NetworkingClient = NetworkingClient()

    func fetchFilteredPhotos(query: String, page: Int) {
        let resource = APIResource.search(page, query).resource
        
        networkingClient.performRequest(to: resource, withType: PhotosList.self) { [weak self] result in
            switch result {
            case .success(let response):
                if response.photos.isEmpty {
                    self?.output.didFailFetchingFilteredPhotos()
                } else {
                    self?.output.didFetchFilteredPhotos(photos: response.photos, page: response.page)
                }
                
                
            case .failure(_):
                self?.output.didFailFetchingFilteredPhotos()
            }
        }
    }
}
