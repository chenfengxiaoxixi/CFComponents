//
//  EDDropMenuAnimationFunc.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/7.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

extension ESDropMenuView {
    
    func calculatetextLayersize(with string: String!, font: UIFont!) -> CGSize {
        var dic: [NSAttributedString.Key : UIFont?]?
            if let font = font {
                dic = [
                    NSAttributedString.Key.font: font
                ]
            }
        let size = string?.boundingRect(
            with: CGSize(width: 280, height: 0),
            options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading],
            attributes: dic! as [NSAttributedString.Key : Any], context: nil).size
        return size ?? CGSize.zero
    }
    
    @objc func menuTapped(_ paramSender: UITapGestureRecognizer) {
        let touchPoint = paramSender.location(in: self)
        //calculate index
        tapIndex = Int(touchPoint.x / (frame.size.width / CGFloat(numOfMenu)))
           
        listStyle = DropListStyle(rawValue: dataSource?.menuView?(self, getColumnDropListStyle: tapIndex) ?? 0)
        
        cellHeight = listStyle == DropListStyle.line ? 44 : 34
        
        for i in 0..<numOfMenu where i != tapIndex {
            animateIndicator(indicators[i], forward: false, complete: {

            })
        }
           
        let collectionView = self.collectionView

        if tapIndex == currentSelectedMenudIndex && show {
            animateIdicator(indicators[currentSelectedMenudIndex],
                            background: backGroundView,
                            title: textLayers[currentSelectedMenudIndex],
                            forward: false, complecte: {
                self.currentSelectedMenudIndex = self.tapIndex
                self.show = false
            })

               //[(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:BackColor.CGColor];
        } else {

            currentSelectedMenudIndex = tapIndex
            collectionView?.reloadData()

            if currentSelectedMenudIndex != -1 {
                   
                animateIdicator(
                    indicators[tapIndex],
                    background: backGroundView,
                    title: textLayers[tapIndex],
                    forward: true, complecte: {
                    self.show = true
                    })
                   
            } else {
                animateIdicator(
                    indicators[tapIndex],
                    background: backGroundView,
                    title: textLayers[tapIndex],
                    forward: true, complecte: {
                    self.show = true
                })
            }
        }
        
        delegate?.menuView?(self, didSelectMenuIndex: tapIndex, isShow: show)
    }
    
    func operateMenuWithIndex(index: Int) {

        currentSelectedMenudIndex = index
        
        let title = textLayers[currentSelectedMenudIndex]
        title.string = dataSource?.menuView(
            self, titleForRowAtIndexPath:
            ESIndexPath(column: currentSelectedMenudIndex, row: 0))
        
        animateIdicator(
            indicators[currentSelectedMenudIndex],
            background: backGroundView,
            title: textLayers[currentSelectedMenudIndex],
            forward: false, complecte: {
            self.show = false
        })
        (bgLayers[currentSelectedMenudIndex]).backgroundColor = bgColor.cgColor
        
        let indicator = indicators[currentSelectedMenudIndex]
        indicator.position = CGPoint(x: (title.position.x + title.frame.size.width) / 2 + 40, y: indicator.position.y)
        
    }
    
    func closeSelectedMenuDropView(index: Int) {
        
        currentSelectedMenudIndex = index
        
        animateIdicator(
            indicators[currentSelectedMenudIndex],
            background: backGroundView,
            title: textLayers[currentSelectedMenudIndex],
            forward: false, complecte: {
            self.show = false
        })
    }
    
    @objc func backgroundTapped(_ paramSender: UITapGestureRecognizer!) {
          
        animateIdicator(
            indicators[currentSelectedMenudIndex],
            background: backGroundView,
            title: textLayers[currentSelectedMenudIndex],
            forward: false, complecte: {
            self.show = false
        })
    }
       
    func animateIndicator(_ indicator: CAShapeLayer!, forward: Bool, complete: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, _: 0.0, _: 0.2, _: 1.0))

        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.values = forward ?
            [NSNumber(value: 0), NSNumber(value: Double.pi)] :
            [NSNumber(value: Double.pi), NSNumber(value: 0)]

        if !anim.isRemovedOnCompletion {
            indicator?.add(anim, forKey: anim.keyPath)
        } else {
            indicator?.add(anim, forKey: anim.keyPath)
            indicator?.setValue(anim.values?.last, forKeyPath: anim.keyPath ?? "")
        }

        CATransaction.commit()

        complete()
    }
       
    func animateBackGroundView(_ view: UIView!, show: Bool, complete: @escaping () -> Void) {
        if show {
            if let view = view {
                superview?.addSubview(view)
            }
            view?.superview?.addSubview(self)
            
            UIView.animate(withDuration: 0.2, animations: {
                view?.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            })
        } else {
            
            let completion: ((Bool) -> Void) = { _ in
                view?.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                view?.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            }, completion: completion)
        }
        complete()
    }
       
    func animate(_ collectionView: UICollectionView!, show: Bool, complete: @escaping () -> Void) {

        if show {

            if collectionView != nil {
                calculateCollectionViewHeight()
            }
            
        } else {
         
            let completion: ((Bool) -> Void) = { _ in
                if (collectionView != nil) {
                    collectionView?.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                if (collectionView != nil) {
                    collectionView?.height = 0
                }
            }, completion: completion)
        }
        complete()
    }
       
    func calculateCollectionViewHeight() {
        
        var collectionViewHeight: CGFloat = 0
        
        collectionView?.height = 0
        if let collectionView = collectionView {
            superview?.addSubview(collectionView)
        }
        
        if listStyle == DropListStyle.grid {
            let num = (collectionView?.numberOfItems(inSection: 0))! % collectionItemCountForRow == 0 ?
                (collectionView?.numberOfItems(inSection: 0))! / collectionItemCountForRow :
                (collectionView?.numberOfItems(inSection: 0))! / collectionItemCountForRow + 1
            collectionViewHeight = CGFloat(num * (cellHeight + 8) + 30)
        } else {
            collectionViewHeight = CGFloat((collectionView?.numberOfItems(inSection: 0))! * cellHeight)
        }

        if collectionViewHeight >= Configs.screenHeight - origin.y - height {
            collectionViewHeight = Configs.screenHeight - origin.y - height
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            if (self.collectionView != nil) {
                if self.collectionView?.numberOfItems(inSection: 0) == 0 {
                    self.collectionView?.height = 0
                } else {
                    self.collectionView?.height = collectionViewHeight
                }
            }
        })
    }
       
    func animateTitle(_ title: CATextLayer!, show: Bool, complete: @escaping () -> Void) {
        
        let size = calculatetextLayersize(with: title?.string as? String, font: font)
        
        let sizeWidth = (size.width < (frame.size.width / CGFloat(numOfMenu)) - 25) ?
            size.width : frame.size.width / CGFloat(numOfMenu) - 25
        title?.bounds = CGRect(x: 0, y: 0, width: sizeWidth, height: size.height)

        if show {
            title?.foregroundColor = textColor?.cgColor
        } else {
            title?.foregroundColor = textColor?.cgColor
        }

        complete()
    }
       
    func animateIdicator(
        _ indicator: CAShapeLayer!,
        background: UIView!,
        title: CATextLayer!,
        forward: Bool, complecte complete: @escaping () -> Void) {

        animateIndicator(indicator, forward: forward, complete: {
            self.animateTitle(title, show: forward, complete: {
                self.animateBackGroundView(background, show: forward, complete: {
                    self.animate(self.collectionView, show: forward, complete: {
                    })
                })
            })
        })
        complete()
    }
}
