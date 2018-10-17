//
//  ApiMethods.swift
//  Picsumple
//
//  Created by Dilz Osmani on 18/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

typealias Result = (RequestResult) -> ()

protocol ApiMethods: class {
    var BASE_URL: String { get }
    
    func getListOfPhotos(_ completion: @escaping Result)
    func getPhotoWith(id: String, _ completion: @escaping Result)
    func getThumbnailFor(id: String, _ completion: @escaping Result)
}

extension ApiMethods {
    var BASE_URL: String {
        return "https://picsum.photos/"
    }
}
