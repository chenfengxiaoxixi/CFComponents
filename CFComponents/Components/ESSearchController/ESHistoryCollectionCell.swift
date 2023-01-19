//
//  ESHistoryCollectionCell.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/9.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESHistoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteBtn.isUserInteractionEnabled = false
        deleteBtn.layer.cornerRadius = deleteBtn.width/2
        deleteBtn.layer.borderWidth = 0.5
        deleteBtn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {

        let att = super.preferredLayoutAttributesFitting(layoutAttributes)

        let string: String = titleLabel.text ?? ""

        var newFram: CGSize = (string.sizeWithText(
        font: .systemFont(ofSize: 15),
        size: CGSize(width: CGFloat(MAXFLOAT),
                     height: size.height)))

        newFram.height += 10
        newFram.width += 30
        att.frame.size = newFram

        return att
    }
    
}
