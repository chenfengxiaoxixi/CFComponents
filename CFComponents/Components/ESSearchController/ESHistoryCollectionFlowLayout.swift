//
//  ESHistoryCollectionFlowLayout.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/9.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESHistoryCollectionFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()

        sectionHeadersPinToVisibleBounds = true
        
        minimumLineSpacing = 12
        sectionInset = UIEdgeInsets(top: 5, left: 14, bottom: 10, right: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes  = super.layoutAttributesForElements(in: rect)
        // 设置的最大间距，根据需要修改
        let maximumSpacing: CGFloat = 8

        if (attributes?.count ?? 0) > 0 {
            let firstAttributes = attributes?[0]
            var frame = firstAttributes?.frame
            frame?.origin.x = maximumSpacing
            firstAttributes?.frame = frame ?? CGRect.zero
        } else {
            return attributes
        }
        
        for i in 1..<attributes!.count {
            // 当前的attribute
            let currentLayoutAttributes: UICollectionViewLayoutAttributes = attributes![i]
            // 上一个attribute
            let prevLayoutAttributes: UICollectionViewLayoutAttributes = attributes![i - 1]
            // 前一个cell的最右边
            let origin = prevLayoutAttributes.frame.maxX
            //如果当前一个cell的最右边加上我们的想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
            //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有的cell的x值都被加到第一行最后一个元素的后面了
            if origin + maximumSpacing + (currentLayoutAttributes.frame.size.width) < collectionViewContentSize.width - 30 {
                var frame = currentLayoutAttributes.frame
                frame.origin.x = origin + maximumSpacing
                currentLayoutAttributes.frame = frame
            } else {
                var frame = currentLayoutAttributes.frame
                frame.origin.x = maximumSpacing
                currentLayoutAttributes.frame = frame
            }
        }

        return attributes
    }
}
