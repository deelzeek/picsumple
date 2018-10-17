//
//  RequestResult.swift
//  Picsumple
//
//  Created by Dilz Osmani on 18/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation

enum RequestResult {
    case success(Any)
    case error(Error)
    case noConnection
}
