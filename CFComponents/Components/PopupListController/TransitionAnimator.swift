//
//  TransitionAnimator.swift
//  EasySell_iOS
//
//  Created by Jalon on 4/29/20.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

final class TransitionAnimator: NSObject {
    // MARK: - Properties
    let direction: PresentationDirection
    let isPresentation: Bool

    // MARK: - Initializers
    init(direction: PresentationDirection, isPresentation: Bool) {
      self.direction = direction
      self.isPresentation = isPresentation
      super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        case .center:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }, completion: { finished in
            if !self.isPresentation {
              controller.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        })
    }
}
