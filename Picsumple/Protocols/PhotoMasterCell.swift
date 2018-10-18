//
//  PhotoMasterCell.swift
//  Picsumple
//
//  Created by Dilz Osmani on 18/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation

protocol PhotoMasterCell {
    var id: Int { get set }
    var author: String { get set }
    var thumbnailAddress: URL { get}
    var originalImageAddress: URL { get }
}
