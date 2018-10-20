//
//  UIZoomableImageView.swift
//  Picsumple
//
//  Created by Dilz Osmani on 19/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

enum Zoom {
    case zoomIn, zoomOut
}

protocol UIZoomableImageViewDelegate: class {
    var viewWidth: CGFloat? { get }
    var viewHeight: CGFloat? { get }
    
    func setBackgroundColorWhileMovingVertically(_ alpha: CGFloat)
    func didReachDismissPosition()
    func didZoomInImageViewChanged(to zoom: Zoom)
}

class UIZoomableImageView: UIImageView {
    
    // MARK: - Properties
    
    private var initPoint : CGPoint?
    private var isOrientationLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    private var currentlyZoomedOut: Bool = false {
        didSet {
            // Turn on/off local pan gesture recognizer
            self.panGestureRecognizer.isEnabled = !currentlyZoomedOut
            self.delegate?.didZoomInImageViewChanged(to: currentlyZoomedOut ? Zoom.zoomOut : Zoom.zoomIn)
        }
    }
    
    /// input
    weak var delegate: UIZoomableImageViewDelegate?
    
    // Recognizers
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHangler(_:)))
        //recognizer.delaysTouchesBegan = true
        //recognizer.delegate = self
        return recognizer
    }()
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler(_:)))
        //recognizer.delegate = self
        return recognizer
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        //recognizer.delegate = self
        return recognizer
    }()
    
    // MARK: - Inits
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func configRecognizers() {
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(pinchGestureRecognizer)
        
        self.panGestureRecognizer.isEnabled = false
        //self.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Pan Gesture regonizer handler
    
    @objc private func panGestureHangler(_ sender: UIPanGestureRecognizer) {
        guard let picture = sender.view, let superview = self.superview else { return }
        
        let translation = sender.translation(in: superview)
        
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
            self.delegate?.setBackgroundColorWhileMovingVertically(alphaValue)
        }
    }
    
    private func panGestureDidEnd(_ view: UIView) {
        let verticalDistance: CGFloat = getVerticalDistanceFromCenter(for: view)
        
        // If alpha has reached 0, and user let it go on that moment -> dismiss
        if verticalDistance >= 200 {
            self.delegate?.didReachDismissPosition()
            return
        }
        
        /// Animate picture back to init position
        UIView.animate(withDuration: 0.2, animations: {
            // Return to original centre
            view.center = self.initPoint!
            self.delegate?.setBackgroundColorWhileMovingVertically(1.0)
            self.layoutIfNeeded()
        })
        
    }
    
    private func getVerticalDistanceFromCenter(for view: UIView) -> CGFloat {
        guard let superview = self.superview else { return 0 }
        let y = superview.center.y
        let viewY = view.center.y
        
        if viewY == 0 {
            return 0
        }
        
        return (viewY >= y) ? (viewY - y) : (y - viewY)
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
                guard
                    let height = self.delegate?.viewWidth,
                    let width = self.delegate?.viewWidth
                else { return false}
                
                let heightIsLess = (transformedSize?.height ?? 0 < height)
                let widthIsLess = (transformedSize?.width ?? 0 < width)
                return self.isOrientationLandscape ? heightIsLess : widthIsLess
            }()
            
            // Update zoom value
            self.currentlyZoomedOut = shouldReturnToOriginal
            
            if shouldReturnToOriginal {
                UIView.animate(withDuration: 0.2) {
                    gestureRecognizer.view?.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    // MARK: - Tap Gesture regonizer handler
    
    @objc private func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        debugPrint("tapGestureHandler: not implemented")
    }

}

extension UIZoomableImageView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        debugPrint(gestureRecognizer)
        
        if gestureRecognizer === self.panGestureRecognizer {
            debugPrint("Local pan gesture recognizer")
//            if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
//                let velocity = recognizer.velocity(in: recognizer.view)
//                return abs(velocity.y) > abs(velocity.x)
//            }
        }
        
//        if let _ = gestureRecognizer as? UIPanGestureRecognizer {
//            return !self.panGestureRecognizer.isEnabled
//        }

        return true
    }
}
