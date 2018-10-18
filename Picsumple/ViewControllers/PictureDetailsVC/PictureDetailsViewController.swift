//
//  PictureDetailsViewController.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit
import SnapKit

protocol PictureDetailsView: ViewProtocol {
    var footerView: UIView? { get set }
    var authorLabel: UILabel? { get set }
    var imageView: UIImageView? { get set }
    var photo: PhotoMasterCell? { get set }
    var backgroundView: UIView? { get set }
}

final class PictureDetailsViewController: UIViewController, MVPViewController {
    typealias P = PictureDetailsPresenter
    
    // MARK: - Properties
    lazy var presenter: P = .init(self)
    weak var footerView: UIView?
    weak var authorLabel: UILabel?
    weak var imageView: UIImageView?
    weak var backgroundView: UIView?
    
    /// Input
    var photo: PhotoMasterCell?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    /// Hide status bar for full screen
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - UI setup
    
    private func setupViews() {
        self.title = "Photo \(self.photo?.id ?? 1)"
        self.view.backgroundColor = .clear
        
        let backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.backgroundColor = .black
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.backgroundView = backgroundView
        
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.imageView = imageView
        
        let footerView = UIView()
        self.view.addSubview(footerView)
        footerView.backgroundColor = self.navigationController?.navigationBar.tintColor
        footerView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(60.0)
        }
        self.footerView = footerView
        
        let authorLabel = UILabel()
        self.footerView?.addSubview(authorLabel)
        authorLabel.textColor = UIColor.white
        authorLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.authorLabel = authorLabel
        
        // Fill values
        self.presenter.fillValues()
    }
    
    
    // MARK: - User actions
    
}

// MARK: - View extension

extension PictureDetailsViewController : PictureDetailsView {
    var vc: UIViewController {
        return self
    }
}
