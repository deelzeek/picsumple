//
//  PresenterProtocol.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import Foundation

protocol PresenterProtocol: NSObjectProtocol {
    associatedtype V
    var view: V { get set }
}
