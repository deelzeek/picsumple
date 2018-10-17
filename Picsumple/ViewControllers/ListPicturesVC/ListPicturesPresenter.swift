//
//  ListPicturesPresenter.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

final class ListPicturesPresenter: NSObject, PresenterProtocol {
    typealias V = ListPicturesView
    
    // MARK: - Properties
    
    unowned var view: V
    
    // MARK: - Init
    
    init(_ view: V) {
        self.view = view
        super.init()
    }
}
