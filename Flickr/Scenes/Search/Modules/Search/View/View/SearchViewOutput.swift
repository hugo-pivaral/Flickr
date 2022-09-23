//
//  SearchSearchViewOutput.swift
//  flickrUIKit
//
//  Created by Hugo Pivaral on 21/09/2022.
//  Copyright © 2022 CIDENET. All rights reserved.
//

protocol SearchViewOutput {
    
    func didTapSearchBarSearchButton()
    func didTapSearchBarCancelButton()
    func searchBarTextDidChange(searchText: String)
    func didSelectRow(with photo: Photo)
    func viewIsReady()
    func willDisplayRow(at index: Int)
}
