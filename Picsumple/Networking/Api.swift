//
//  UnsplashApi.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit
import Alamofire

fileprivate typealias RequestSessionParam = (String, HTTPMethod) -> DataRequest

final class Api: ApiMethods {
    
    // MARK: - Singleton
    
    static let shared = Api()
    
    // MARK: - Properties
    
    private lazy var manager: SessionManager = {
        let memoryCapacity = 100 * 1024 * 1024; // 100 MB
        let diskCapacity = 100 * 1024 * 1024; // 100 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = cache
        
        return SessionManager(configuration: configuration)
    }()
    
    private lazy var requestSession: RequestSessionParam = {
        return self.manager.request($0,
                                    method: $1)
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Convert url
    
    private func getConvertedUrl(_ endpoint: Endpoint) -> String {
        return endpoint.format(BASE_URL)
    }
    
    // MARK: - Requests
    
    func getListOfPhotos(_ completion: @escaping Result) {
        
        requestSession(getConvertedUrl(.listOfPictures),
                       .get)
            .response { (response) in
                debugPrint(response)
                
                guard let data = response.data else {
                    completion(.error(NSError(domain: "Error occured", code: 404, userInfo: nil)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let photos = try decoder.decode([Photo].self, from: data)
                    
                    completion(.success(photos))
                } catch let error {
                    completion(.error(error))
                }
        }
    }
    
    func getThumbnailFor(id: String, _ completion: @escaping Result) {
        
    }
    
    func getPhotoWith(id: String, _ completion: @escaping Result) {
        requestSession(getConvertedUrl(.uniquePhoto(id: id)),
                       .get)
            .response { (response) in
                
            }
    }
}
