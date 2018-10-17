//
//  Storyboards.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

enum Storyboards: CustomStringConvertible {
    case main
    
    var description : String {
        switch self {
        case .main: return "Main"
        }
    }
}
