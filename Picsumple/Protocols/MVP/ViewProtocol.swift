//
//  ViewProtocol.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

protocol ViewProtocol: class {
    var view: UIView! { get set }
    var vc: UIViewController { get }
}
