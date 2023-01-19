//
//  PresentationController.swift
//  EasySell_iOS
//
//  Created by Jalon on 4/29/20.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

final class PresentationController: UIPresentationController {
    
    // MARK: - Properties
    private var dimmingView: UIView!
    private let direction: PresentationDirection
    private let compactHeight: CGFloat
    
    // MARK: - Initializers
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         direction: PresentationDirection,
         compactHeight: CGFloat) {
        self.direction = direction
        self.compactHeight = compactHeight
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width*(1.0/3.0)
        case .bottom:
            frame.origin.y = containerView!.frame.height - frame.size.height
        case .center:
            frame.origin.y = (containerView!.frame.height - frame.size.height)/2
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
          return
        }
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["dimmingView": dimmingView]))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
          dimmingView.alpha = 1.0
          return
        }
        
        coordinator.animate(alongsideTransition: { _ in
          self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
          dimmingView.alpha = 0.0
          return
        }
        
        coordinator.animate(alongsideTransition: { _ in
          self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
          return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
        case .bottom, .top, .center:
            return CGSize(width: parentSize.width, height: compactHeight)
        }
    }
}

// MARK: - Private
private extension PresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0

        let recognizer = UITapGestureRecognizer(target: self,
                                              action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
