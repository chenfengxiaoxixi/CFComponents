//
//  PMRightChartCell.swift
//  ParkManage
//
//  Created by 陈峰 on 2023/3/15.
//  Copyright © 2023 diligrp. All rights reserved.
//

import UIKit

class PMRightChartCell: UITableViewCell {

    var title1: UILabel!
    var title2: UILabel!
    var title3: UILabel!
    var title4: UILabel!
    var title5: UILabel!
    var title6: UILabel!
    var title7: UILabel!
    var title8: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        initUI()
    }
    
    func initUI() {
        
        title1 = UILabel(frame: CGRect(x: 0, y: 0, width: rightColumnW1, height: 50))
        title1.font = .systemFont(ofSize: 14)
        title1.textColor = .darkText
        title1.textAlignment = .center
        title1.numberOfLines = 2
        addSubview(title1)
        
//        title1.layer.borderWidth = 0.6
//        title1.layer.borderColor = UIColor.themeVeryLineGray().cgColor

        title2 = UILabel(frame: CGRect(x: title1.frame.maxX, y: 0, width: rightColumnW2, height: 50))
        title2.font = .systemFont(ofSize: 14)
        title2.textColor = .darkText
        title2.textAlignment = .center
        title2.numberOfLines = 2
        addSubview(title2)
        
//        title2.layer.borderWidth = 0.6
//        title2.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        title3 = UILabel(frame: CGRect(x: title2.frame.maxX, y: 0, width: rightColumnW3, height: 50))
        title3.font = .systemFont(ofSize: 14)
        title3.textColor = .darkText
        title3.textAlignment = .center
        title3.numberOfLines = 2
        addSubview(title3)
        
//        title3.layer.borderWidth = 0.6
//        title3.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        title4 = UILabel(frame: CGRect(x: title3.frame.maxX, y: 0, width: rightColumnW4, height: 50))
        title4.font = .systemFont(ofSize: 14)
        title4.textColor = .darkText
        title4.textAlignment = .center
        title4.numberOfLines = 2
        addSubview(title4)
        
//        title4.layer.borderWidth = 0.6
//        title4.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        title5 = UILabel(frame: CGRect(x: title4.frame.maxX, y: 0, width: rightColumnW5, height: 50))
        title5.font = .systemFont(ofSize: 14)
        title5.textColor = .darkText
        title5.textAlignment = .center
        title5.numberOfLines = 2
        addSubview(title5)
        
//        title5.layer.borderWidth = 0.6
//        title5.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        title6 = UILabel(frame: CGRect(x: title5.frame.maxX, y: 0, width: rightColumnW6, height: 50))
        title6.font = .systemFont(ofSize: 14)
        title6.textColor = .darkText
        title6.textAlignment = .center
        title6.numberOfLines = 2
        addSubview(title6)
        
//        title6.layer.borderWidth = 0.6
//        title6.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        title7 = UILabel(frame: CGRect(x: title6.frame.maxX, y: 0, width: rightColumnW7, height: 50))
        title7.font = .systemFont(ofSize: 14)
        title7.textColor = .darkText
        title7.textAlignment = .center
        title7.numberOfLines = 2
        addSubview(title7)
        
//        title7.layer.borderWidth = 0.6
//        title7.layer.borderColor = UIColor.themeVeryLineGray().cgColor
        
        title8 = UILabel(frame: CGRect(x: title7.frame.maxX, y: 0, width: rightColumnW8, height: 50))
        title8.font = .systemFont(ofSize: 14)
        title8.textColor = .darkText
        title8.textAlignment = .center
        title8.numberOfLines = 2
        addSubview(title8)
        
//        title8.layer.borderWidth = 0.6
//        title8.layer.borderColor = UIColor.themeVeryLineGray().cgColor

        let totalW = rightColumnW1 + rightColumnW2 + rightColumnW3 +
        rightColumnW4 + rightColumnW5 + rightColumnW6
        + rightColumnW7 + rightColumnW8
        
        let line = UIView(frame: CGRect(x: 0, y: 49.5, width: totalW, height: 0.5))
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
