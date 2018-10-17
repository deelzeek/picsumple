//
//  UnsplashApi.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case cannotCast
}

final class Api {
    
    // MARK: - Properties
    static let shared = Api()
    
    // MARK: - Init
    private init() {
        
    }
    
    func getPhotosList() {
        let url = URL(string: "https://picsum.photos/list")!
        
    }
}
