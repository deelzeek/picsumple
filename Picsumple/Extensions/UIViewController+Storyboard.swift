//
//  UIViewController+Storyboard.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit.UIStoryboard

extension UIStoryboard {
    static func getStoryboard(_ story: Storyboards) -> UIStoryboard {
        return UIStoryboard(name: story.description, bundle: nil)
    }
}

