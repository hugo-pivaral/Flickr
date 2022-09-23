//
//  SearchSearchInteractorOutput.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

protocol SearchInteractorOutput: AnyObject {

    func didFetchFilteredPhotos(photos: [Photo], page: Int)
    func didFailFetchingFilteredPhotos()
}
