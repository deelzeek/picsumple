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
    var imageView: UIZoomableImageView? { get set }
    var backgroundView: UIView? { get set }
    var scrollView: UIScrollView? { get set }
    
    var photos: [PhotoMasterCell]! { get set }
    var numberInArray: Int! { get }
}

final class PictureDetailsViewController: UIViewController, MVPViewController {
    typealias P = PictureDetailsPresenter
    
    // MARK: - Properties
    lazy var presenter: P = .init(self)
    weak var footerView: UIView?
    weak var authorLabel: UILabel?
    weak var imageView: UIZoomableImageView?
    weak var backgroundView: UIView?
    weak var scrollView: UIScrollView?
    
    /// Input
    var photos: [PhotoMasterCell]!
    var numberInArray: Int!
    
    // MARK: Inits
    
    init(photos: [PhotoMasterCell], numberInArray: Int) {
        self.photos = photos
        self.numberInArray = numberInArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    /// Hide status bar for full screen
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// Adjust orientation changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        imageView?.snp.remakeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            let _ = self.presenter.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
        })
    }
    
    // MARK: - UI setup
    
    private func setupViews() {
        self.view.backgroundColor = .clear
        
        let backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.backgroundColor = .black
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.backgroundView = backgroundView
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.scrollView = scrollView
        self.scrollView?.delegate = presenter
        
        let imageView = UIZoomableImageView()
        self.scrollView?.addSubview(imageView)
        imageView.delegate = presenter
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            let _ = self.presenter.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
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
    
}

// MARK: - View extension

extension PictureDetailsViewController : PictureDetailsView {
    var vc: UIViewController {
        return self
    }
}
