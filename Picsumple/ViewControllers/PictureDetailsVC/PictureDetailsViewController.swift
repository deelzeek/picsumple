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
    
}

final class PictureDetailsViewController: UIViewController, MVPViewController {
    typealias P = PictureDetailsPresenter
    
    // MARK: - Properties
    lazy var presenter: P = .init(self)
    weak var footerView: UIView?
    weak var authorLabel: UILabel?
    weak var imageView: UIImageView?
    
    /// Input
    var photo: PhotoMasterCell?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationController?.navigationBar.alpha = 0
            self.footerView?.alpha = 0
        }, completion: { _ in
            self.navigationController?.navigationBar.alpha = 1
            self.footerView?.alpha = 1
        })
        
    }
    
    private func setupViews() {
        self.title = "Photo"
        self.view.backgroundColor = UIColor.white
        
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
        
        authorLabel.text = "Author"
        self.authorLabel = authorLabel
        
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(300.0)
            make.width.equalToSuperview()
        }
        self.imageView = imageView
        
        guard let url = photo?.originalImageAddress else { return }
        self.imageView?.kf.setImage(with: url,
                                    options: [.transition(.fade(0.2))],
            progressBlock: {
                receivedSize, totalSize in
                let percentage = (Float(receivedSize) / Float(totalSize)) * 100.0
                print("downloading progress: \(percentage)%")
        },
                                    completionHandler: nil)
    }
    
    
}

// MARK: - View extension

extension PictureDetailsViewController : PictureDetailsView {
    var vc: UIViewController {
        return self
    }
}
