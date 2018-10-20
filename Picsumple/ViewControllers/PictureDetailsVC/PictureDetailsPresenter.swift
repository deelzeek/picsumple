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
    private (set) var currentPosition: Int = 1
    private var lastContentOffset: CGPoint?
    private var addedImageViews = [UIZoomableImageView]()
    
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
    
}

// MARK: - UIGestureRecognizerDelegate method

extension PictureDetailsPresenter: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = recognizer.velocity(in: recognizer.view)
            return abs(velocity.x) > abs(velocity.y)
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let imageView: UIZoomableImageView? = {
            if currentPosition == 1 {
                return self.view.imageView
            } else {
                if self.addedImageViews.indices.contains(currentPosition) {
                    return self.addedImageViews[currentPosition]
                }
            }

            return nil
        }()

        guard let view = imageView else { return true }

        if view.frame.contains(touch.location(in: view)) {
            return false
        }
        
        return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == self.panGesture && otherGestureRecognizer == self.swipeGesture {
//            return true
//        }
//        return false
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return (gestureRecognizer.view !== self.view.scrollView)
//    }
    
}

// MARK: - UIScrollViewDelegate methods

extension PictureDetailsPresenter: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        if currentPosition == 1 {
//            return self.view.imageView
//        } else {
//            return self.addedImageViews[currentPosition - 1]
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //debugPrint("scrollViewDidScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
        debugPrint("scrollViewWillBeginDragging")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDecelerating")
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
    
    func didZoomInImageViewChanged(to zoom: Zoom) {
        self.view.scrollView?.panGestureRecognizer.isEnabled = (zoom == .zoomOut)
    }
}
