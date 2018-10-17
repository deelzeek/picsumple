//
//  UIViewController+Init.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    static func instantiateWith(story: Storyboards, identifier: String) -> UIViewController {
        return UIStoryboard.getStoryboard(story).instantiateViewController(withIdentifier: identifier)
    }
}
