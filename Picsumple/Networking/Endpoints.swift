//
//  Endpoints.swift
//  Picsumple
//
//  Created by Dilz Osmani on 18/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation

/// Provides existing enpoints as a converted string
enum Endpoint {
    
    // MARK: - ⎆ Pictures
    
    /// Retrieving list of pictures
    /// - Endpoint: GET https://picsum.photos/list
    case listOfPictures
    
    /// Get high res picture
    /// - Endpoint: GET https://picsum.photos/200/300?image=0
    case uniquePhoto(id: String)
    
    /// Get low res picture
    /// - Endpoint: GET https://picsum.photos/200/300?image=0
    case photoThumbnail(id: String)
    
    private var concat: String {
        return "%@%@"
    }
    
    /// Returns formatter URL according to the case
    /// Example: GET api/v1/subjects/1/traits
    func format(_ base: String) -> String {
        
        let endpoint: String = {
            switch self {
            case .listOfPictures:
                return "list"
            case .uniquePhoto(let id):
                return "1000/1000?image=\(id)"
            case .photoThumbnail(let id):
                return "80/80?image=\(id)"
            }
        }()
        
        return String(format: concat, base, endpoint)
    }
    
}

