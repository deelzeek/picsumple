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
    
    // MARK: - Gesture regonizer handler
    
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
    }
    
    private func panGestureDidEnd(_ view: UIView) {
        /// Animate picture back to init position
        UIView.animate(withDuration: 0.2, animations: {
            view.center = self.initPoint!
            self.view.view.layoutIfNeeded()
        })
        
    }
    
    @objc private func pinchGestureHandler(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }
    }
    
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

extension PictureDetailsPresenter: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
}
