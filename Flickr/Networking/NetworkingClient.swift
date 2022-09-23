//
//  NetworkingClient.swift
//  Flickr
//
//  Created by Hugo Pivaral on 21/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

class NetworkingClient {
    
    /// Performs an http GET request to the specified endpoint URL.
    func performRequest<T: Decodable>(to url: URL, withType responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                
                return
            }
            
            #if DEBUG
            guard let json = String(data: data, encoding: .utf8) else { return }
            print("⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃")
            print("‣ URL : \(url)")
            print("‣ RESPONSE : \(json)")
            print("⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃⁃")
            #endif
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            }
            
            catch (let error) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
