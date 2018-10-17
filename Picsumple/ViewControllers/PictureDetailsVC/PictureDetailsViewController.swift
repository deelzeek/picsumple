//
//  PictureDetailsViewController.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

protocol PictureDetailsView: ViewProtocol {
    
}

final class PictureDetailsViewController: UIViewController, MVPViewController {
    typealias P = PictureDetailsPresenter
    
    // MARK: - Properties
    lazy var presenter: P = .init(self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - View extension

extension PictureDetailsViewController : PictureDetailsView {
    var vc: UIViewController {
        return self
    }
}
