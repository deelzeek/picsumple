//
//  PhotoViewModel.swift
//  Picsumple
//
//  Created by Dilz Osmani on 24/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation
import DynamicGallery

struct PhotoViewModel: DynamiceGalleryPhoto {

    // MARK: - Properties
    
    private var photo: Photo!
    
    var id: Int {
        return self.photo.id
    }
    
    var footerLabelText: String {
        return self.photo.author.capitalized
    }
    
    var thumbnailAddress: URL {
        let id = String(self.photo.id)
        let urlAddress: String = Api.shared.getConvertedUrl(.photoThumbnail(id: id))
        return URL(string: urlAddress)!
    }
    
    var imageAddress: URL {
        let id = String(self.photo.id)
        let urlAddress: String = Api.shared.getConvertedUrl(.uniquePhoto(id: id))
        return URL(string: urlAddress)!
    }
    
    // MARK: - Inits
    
    init(with photo: Photo) {
        self.photo = photo
    }
    

}
