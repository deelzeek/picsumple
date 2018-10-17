//
//  ListPicturesViewController.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

protocol ListPicturesView: ViewProtocol {
    
}

final class ListPicturesViewController: UIViewController, MVPViewController {
    typealias P = ListPicturesPresenter
    
    // MARK: - Properties
    lazy var presenter: P = .init(self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - View extension

extension ListPicturesViewController : ListPicturesView {
    var vc: UIViewController {
        return self
    }
}
