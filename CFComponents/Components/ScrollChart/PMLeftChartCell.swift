//
//  PMLeftChartCell.swift
//  ParkManage
//
//  Created by 陈峰 on 2023/3/15.
//  Copyright © 2023 diligrp. All rights reserved.
//

import UIKit

class PMLeftChartCell: UITableViewCell {

    var title1: UILabel!
    var title2: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        initUI()
    }
    
    func initUI() {
        
        title1 = UILabel(frame: CGRect(x: 0, y: 0, width: leftColumnW1, height: 50))
        title1.font = .systemFont(ofSize: 14)
        title1.textColor = .darkText
        title1.textAlignment = .center
        title1.numberOfLines = 2
        addSubview(title1)
        
//        title1.layer.borderWidth = 0.6
//        title1.layer.borderColor = UIColor.themeVeryLineGray().cgColor

        title2 = UILabel(frame: CGRect(x: title1.frame.maxX, y: 0, width: leftColumnW2, height: 50))
        title2.font = .systemFont(ofSize: 14)
        title2.textColor = .darkText
        title2.textAlignment = .center
        title2.numberOfLines = 2
        addSubview(title2)
        
//        title2.layer.borderWidth = 0.6
//        title2.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        let line = UIView(frame: CGRect(x: 0, y: 49.5, width: leftColumnW1 + leftColumnW2, height: 0.5))
        line.backgroundColor = .themeVeryLineGray()
        addSubview(line)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
