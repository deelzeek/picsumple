//
//  Photo.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation

struct Photo: Decodable, PhotoMasterCell {
    var format: String
    var width: Int
    var height: Int
    var filename: String
    var id: Int
    var author: String
    var authorUrl: String
    var postUrl: String
    var thumbnailAddress: URL {
        return URL(string: "https://picsum.photos/80/80?image=\(id)")!
    }
    
    var originalImageAddress: URL {
        return URL(string: "https://picsum.photos/1000/1000?image=\(id)")!
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case format
        case width
        case height
        case filename
        case author
        case authorUrl = "author_url"
        case postUrl = "post_url"
    }
}
