//
//  MVPViewController.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

protocol MVPViewController: class {
    associatedtype P
    var presenter: P { get set }
}
