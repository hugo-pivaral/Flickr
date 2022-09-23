//
//  APIResource.swift
//  Flickr
//
//  Created by Hugo Pivaral on 21/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

enum APIResource {
    
    /// - Associated values:
    ///   - Int: The page number of results to return
    ///   - String: A free text search. Photos who's title, description or tags contain the text will be returned
    case search(Int, String)
    
    /// - Associated values:
    ///   - String: The id of the photo to get information for.
    case info(String)
    
    /// - Associated values:
    ///   - Int: The page number of results to return
    case interesting(Int)
    
    var resource: URL {
        switch self {
        case .search(let page, let query):
            return makeResource(queryItems: [URLQueryItem(name: "page", value: String(page)),
                                             URLQueryItem(name: "text", value: query),
                                             URLQueryItem(name: "sort", value: "relevance"),
                                             URLQueryItem(name: "method", value: "flickr.photos.search")])
            
        case .info(let photoId):
            return makeResource(queryItems: [URLQueryItem(name: "photo_id", value: photoId),
                                             URLQueryItem(name: "method", value: "flickr.photos.getInfo")])
            
        case .interesting(let page):
            return makeResource(queryItems: [URLQueryItem(name: "page", value: String(page)),
                                             URLQueryItem(name: "method", value: "flickr.interestingness.getList")])
        }
    }
    
    private var apiKey: String {
        guard let url = Bundle.main.url(forResource: "Configuration", withExtension: "plist"),
              let config = NSDictionary(contentsOf: url) as? [String: Any],
              let apiKey = config["apiKey"] as? String else {
            
            fatalError("Please go to `https://www.flickr.com/services/api/flickr.photos.getPopular.html` to configure your API key. Then save it in the Configuration.plist file.")
        }
        
        return apiKey
    }
    
    private func makeResource(queryItems: [URLQueryItem]?) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path =  "/services/rest"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "per_page", value: "50"),
        ]
        
        if let queryItems = queryItems {
            components.queryItems?.append(contentsOf: queryItems)
        }
        
        return components.url!
    }
}
