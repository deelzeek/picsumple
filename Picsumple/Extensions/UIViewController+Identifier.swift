//
//  UIViewController+Identifier.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

extension UIViewController {
    static var storyboardIdentifier : String {
        return String(describing: self)
    }
}