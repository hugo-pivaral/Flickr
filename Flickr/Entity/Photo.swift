//
//  Photo.swift
//  Flickr
//
//  Created by Hugo Pivaral on 22/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    let id: String
    let farm: Int
    let server: String
    let secret: String

    var thumbnailUrl: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_t.jpg")
    }
    
    var largeUrl: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg")
    }
    
    init(id: String, farm: Int, server: String, secret: String) {
        self.id = id
        self.farm = farm
        self.server = server
        self.secret = secret
    }
}
