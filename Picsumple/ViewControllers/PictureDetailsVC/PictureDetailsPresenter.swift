//
//  PictureDetailsPresenter.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

final class PictureDetailsPresenter: NSObject, PresenterProtocol {
    typealias V = PictureDetailsView
    
    // MARK: - Properties
    
    unowned var view: V
    
    private var initPoint : CGPoint?
    private (set) var isBarVisible: Bool = true
    
    var isOrientationLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHangler(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    // MARK: - Init
    
    init(_ view: V) {
        self.view = view
        super.init()
    }
    
    func fillValues() {
        guard let photo = self.view.photo else { return }
        
        self.view.authorLabel?.text = photo.author
        self.view.imageView?.kf.setImage(with: photo.originalImageAddress,
                                    options: [.transition(.fade(0.2))])
        
        self.configInteraction()
    }
    
    // MARK: - Interactions
    
    private func configInteraction() {
        guard let imageView = self.view.imageView else { return }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGestureRecognizer)
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Pan Gesture regonizer handler
    
    @objc private func panGestureHangler(_ sender: UIPanGestureRecognizer) {
        guard let picture = sender.view else { return }
        
        let translation = sender.translation(in: self.view.view)
        
        switch sender.state {
        case .began:
            panGestureDidStart(point: picture.center)
        case .changed:
            panGestureDidChange(point: translation, view: picture)
        case .ended:
            panGestureDidEnd(picture)
        case .cancelled, .failed, .possible:
            break
        }
    }
    
    private func panGestureDidStart(point: CGPoint) {
        self.initPoint = point
    }
    
    private func panGestureDidChange(point: CGPoint, view: UIView) {
        /// Move item around
        view.center = CGPoint(x: initPoint!.x + point.x, y: initPoint!.y + point.y)
        
        // Get distance change from initial center
        let verticalDistance: CGFloat = getVerticalDistanceFromCenter(for: view) + 50.0
        
        // If over 100, then for every +1 point reduce alpha for background
        if 100.0...200.0 ~= Double(verticalDistance) {
            let alphaValue: CGFloat = 1.0 - (verticalDistance.truncatingRemainder(dividingBy: 100.0) / 100.0)
            self.view.backgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaValue)
        }
    }
    
    private func panGestureDidEnd(_ view: UIView) {
        let verticalDistance: CGFloat = getVerticalDistanceFromCenter(for: view)
        
        // If alpha has reached 0, and user let it go on that moment -> dismiss
        if verticalDistance >= 200 {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.view.alpha = 0
            }, completion: { _ in
                self.view.vc.dismiss(animated: false, completion: nil)
            })
            return
        }
        
        /// Animate picture back to init position
        UIView.animate(withDuration: 0.2, animations: {
            // Return to original centre
            view.center = self.initPoint!
            self.view.backgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            self.view.view.layoutIfNeeded()
        })
        
    }
    
    private func getVerticalDistanceFromCenter(for view: UIView) -> CGFloat {
        let y = self.view.view.center.y
        if view.center.y > y {
            return view.center.y - y
        } else {
            return y - view.center.y
        }
    }
    
    // MARK: - Pinch Gesture regonizer handler
    
    @objc private func pinchGestureHandler(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
            
            return
        }
        
        if gestureRecognizer.state == .ended {
            let transformedSize = gestureRecognizer.view?.layer.frame.size
            
            // If transformed size has smaller width/height, then return it to the original width/height
            let shouldReturnToOriginal: Bool = {
                let heightIsLess = (transformedSize?.height ?? 0 < self.view.view.bounds.height)
                let widthIsLess = (transformedSize?.width ?? 0 < self.view.view.bounds.width)
                return self.isOrientationLandscape ? heightIsLess : widthIsLess
            }()
            
            if shouldReturnToOriginal {
                UIView.animate(withDuration: 0.2) {
                    gestureRecognizer.view?.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    // MARK: - Tap Gesture regonizer handler
    
    @objc private func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            let alphaValue: CGFloat = self.isBarVisible ? 0 : 1
            self.view.vc.navigationController?.navigationBar.alpha = alphaValue
            self.view.footerView?.alpha = alphaValue
        }, completion: { _ in
            self.isBarVisible = !self.isBarVisible
        })
    }
}

// MARK: - UIGestureRecognizerDelegate method

extension PictureDetailsPresenter: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
}
