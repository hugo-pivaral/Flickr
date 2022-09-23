//
//  HomeInteractor.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

class HomeInteractor: HomeInteractorInput {

    weak var output: HomeInteractorOutput!
    lazy var networkingClient: NetworkingClient = NetworkingClient()
    
    func fetchInterestingPhotos(page: Int) {
        let resource = APIResource.interesting(page).resource
        
        networkingClient.performRequest(to: resource, withType: PhotosList.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.output.didFetchInterestingPhotos(photos: response.photos, page: response.page)
                
            case .failure(let error):
                print(error)
                self?.output.didFailFetchingInterestingPhotos()
            }
        }
    }
}
