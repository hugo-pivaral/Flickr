//
//  PhotoLoader.swift
//  Flickr
//
//  Created by Hugo Pivaral on 21/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

typealias PhotoCache = [URL : UIImage]
typealias RequestManager = [UUID : URLSessionDataTask]

class PhotoLoadManager {
    
    // MARK: - Properties
    
    private var cachedImages: PhotoCache
    private var runningRequests: RequestManager
    private var compressionEnabled: Bool
    
    
    // MARK: - Initializer
    
    init(compressionEnabled: Bool = true) {
        self.runningRequests = [:]
        self.cachedImages = [:]
        self.compressionEnabled = compressionEnabled
    }
    
    
    // MARK: - Helper methods
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = cachedImages[url] {
            completion(.success(image))
            
            return nil
        }
        
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
        
            defer {
                self?.runningRequests.removeValue(forKey: uuid)
            }
            
            if let data = data,
               let image = UIImage(data: data),
               let compressedData = image.jpegData(compressionQuality: 0),
               let compressedImage = UIImage(data: compressedData) {
                
                self?.cachedImages[url] = self?.compressionEnabled ?? true ?  compressedImage : image
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
                
                return
            }
            
            guard let error = error else {
                return print("No data & no error 😵‍💫")
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
        }
        
        task.resume()
        
        runningRequests[uuid] = task
        
        return uuid
    }
    
    func cancelImageLoad(for uuid: UUID?) {
        if let uuid = uuid, let runningRequest = runningRequests[uuid] {
            runningRequest.cancel()
            runningRequests.removeValue(forKey: uuid)
        }
    }
    
    func clearCache() {
        for request in runningRequests {
            request.value.cancel()
        }
        
        runningRequests = [:]
        cachedImages = [:]
    }
}


