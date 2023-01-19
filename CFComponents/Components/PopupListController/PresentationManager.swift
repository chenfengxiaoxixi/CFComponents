//
//  PresentationManager.swift
//  EasySell_iOS
//
//  Created by Jalon on 4/29/20.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
    case center
}

class PresentationManager: NSObject {
    // MARK: - Properties
    var direction: PresentationDirection = .bottom
    // 视图展示高度
    var compactHeight: CGFloat = 320
}

extension PresentationManager: UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = PresentationController(
            presentedViewController: presented,
            presenting: presenting,
            direction: direction,
            compactHeight: compactHeight
        )
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator(direction: direction, isPresentation: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator(direction: direction, isPresentation: false)
    }
}
