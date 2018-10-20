//
//  PictureDetailsPresenter.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit
import SnapKit

final class PictureDetailsPresenter: NSObject, PresenterProtocol {
    typealias V = PictureDetailsView
    
    // MARK: - Properties
    
    unowned var view: V
    
    private var initPoint : CGPoint?
    private var lastContentOffset: CGPoint?
    private var addedImageViews = [UIZoomableImageView]()
    private (set) var currentPosition: Int = 1 {
        didSet {
            self.currentPositionDidChange()
        }
    }
    
    var isOrientationLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    // MARK: - Init
    
    init(_ view: V) {
        self.view = view
        super.init()
    }
    
    func fillValues() {
        guard let startingNumber = self.view.numberInArray else { return }
        let photo = self.view.photos[startingNumber]
        
        self.view.authorLabel?.text = photo.author
        self.view.imageView?.kf.setImage(with: photo.originalImageAddress,
                                         options: [.transition(.fade(0.2))])
        
        /// Add one more imageview by default
        if startingNumber > 0 {
            self.addImageView(at: self.currentPosition + 1)
        }
    }
    
    /// Create next image and prepare it for usage, before reaching it
    func addImageView(at position: Int) {
        let imageView = UIZoomableImageView()
        self.view.scrollView?.addSubview(imageView)
        
        // Adjust new view's frame center
        // Formula: x = y * (n+(n-1))
        // n - number of image in current sequence
        // x - image's x position by frame
        // y - default view.center.x
        let xPos = self.view.view.center.x * CGFloat(position + (position - 1))
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(xPos)
            make.centerY.equalToSuperview()
            let _ = self.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
        }
        
        imageView.delegate = self
        
        // Set image to download
        let resource = self.view.photos[self.view.numberInArray + position].originalImageAddress
        imageView.kf.setImage(with: resource,
                              options: [.transition(.fade(0.2))])
        
        // Add to array
        self.addedImageViews.append(imageView)
        
        // Update scrollView frame
        self.view.scrollView?.contentSize = CGSize(width: self.view.view.frame.width * CGFloat(position),
                                                   height: self.view.view.frame.height)
    }
    
    func orientationDidChange() {
        
        /// Very first
        self.view.imageView?.snp.remakeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            let _ = self.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
        })
        
        /// Dynamically added ones
        
        for (pos, image) in addedImageViews.enumerated() {
            let correction = pos + 2
            let xPos = self.view.view.center.y * CGFloat(correction + (correction - 1))
            image.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(xPos)
                make.centerY.equalToSuperview()
                let _ = self.isOrientationLandscape ? make.height.equalToSuperview() : make.width.equalToSuperview()
            })
        }
        
        // Update scrollView frame
        self.view.scrollView?.contentSize = CGSize(width: self.view.view.frame.height * CGFloat(addedImageViews.count + 1),
                                                   height: self.view.view.frame.width)
        
        // Update the scroll view scroll position to the appropriate page.
        let minX = self.view.view.frame.minX
        let minY = self.view.view.frame.height * CGFloat(currentPosition - 1)
        let offsetPoint = CGPoint(x: minY, y: minX)
        self.view.scrollView?.setContentOffset(offsetPoint, animated: true)
    }
    
    /// Update value on the screen according to what is being shown e.g. author name
    private func currentPositionDidChange() {
        if !self.view.photos.indices.contains(self.view.numberInArray + currentPosition - 1) {
            return
        }
        
        let authorName = self.view.photos[self.view.numberInArray + currentPosition - 1].author
        self.view.authorLabel?.text = authorName
    }
    
}

// MARK: - UIScrollViewDelegate methods

extension PictureDetailsPresenter: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let last = lastContentOffset else { return }
        
        // did swipe right
        if last.x < scrollView.contentOffset.x {
            if self.currentPosition != self.view.photos.count {
                currentPosition += 1
                if self.currentPosition >= (self.addedImageViews.count + 1) {
                    self.addImageView(at: self.currentPosition + 1)
                }
            }
        }   // did swipe left
        else if last.x > scrollView.contentOffset.x {
            if self.currentPosition != 1 {
                self.currentPosition -= 1
            }
        }
        
    }
}

// MARK: - UIZoomableImageViewDelegate methods

extension PictureDetailsPresenter: UIZoomableImageViewDelegate {
    var viewWidth: CGFloat? {
        return self.view.view.bounds.width
    }
    
    var viewHeight: CGFloat? {
        return self.view.view.bounds.height
    }
    
    func setBackgroundColorWhileMovingVertically(_ alpha: CGFloat) {
        self.view.backgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
    }
    
    func didReachDismissPosition() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.view.alpha = 0
        }, completion: { _ in
            self.view.vc.dismiss(animated: false, completion: nil)
        })
    }
}
