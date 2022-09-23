//
//  NavigationBarStyle.swift
//  Flickr
//
//  Created by Hugo Pivaral on 22/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

protocol NavigationBarStyle {
    
    func primaryStyle()
    func clearStyle()
}

extension NavigationBarStyle where Self: UIViewController {
    
    func primaryStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func clearStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
