//
//  BusinessDataDateHeaderView.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/16.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

protocol BusinessDataDateHeaderViewDelegate: NSObjectProtocol {
    
    func headerView(_ headerView: BusinessDataDateHeaderView,
                    didSelectStartTimeOrEnd isStart: Bool)
    func headerViewDidSelectLeftBtn(_ headerView: BusinessDataDateHeaderView)
}

class BusinessDataDateHeaderView: UIView {

    weak open var delegate: BusinessDataDateHeaderViewDelegate?
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startLine: UIView!
    
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endLine: UIView!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    var isSelectedStartTime: Bool! {
        didSet {changeThemeColor()}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 加载xib
        let nibView = (Bundle.main.loadNibNamed("BusinessDataDateHeaderView", owner: self, options: nil)?.last as? UIView)!
        nibView.frame = bounds
        nibView.backgroundColor = .themeBackGround()
        addSubview(nibView)
        
        startLabel.textColor = .themeBlue()
        startTimeLabel.textColor = .darkText
        startLine.backgroundColor = .themeBlue()
        leftBtn.backgroundColor = .themeBlue()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStartTimeLabel(startTime: String) {
        
        startTimeLabel.text = startTime
    }
    
    func setEndTimeLabel(endTime: String) {
        
        endTimeLabel.text = endTime
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setBtnTitle(title: String) {
        leftBtn.setTitle("确定", for: .normal)
    }
    
    @IBAction func startDateAction(_ sender: UIButton) {
        
        isSelectedStartTime = true
        
        delegate?.headerView(self, didSelectStartTimeOrEnd: isSelectedStartTime)
    }
    
    @IBAction func endDateAction(_ sender: UIButton) {
        
        isSelectedStartTime = false
        
        delegate?.headerView(self, didSelectStartTimeOrEnd: isSelectedStartTime)
    }
    
    @IBAction func leftBtnAction(_ sender: UIButton) {
        delegate?.headerViewDidSelectLeftBtn(self)
    }
    
    func changeThemeColor() {
        
        startLabel.textColor = isSelectedStartTime ? UIColor.themeBlue() : UIColor.lightGray
        startTimeLabel.textColor = isSelectedStartTime ? UIColor.darkText : UIColor.lightGray
        startLine.backgroundColor = isSelectedStartTime ? UIColor.themeBlue() : UIColor.lightGray
        
        endLabel.textColor = !isSelectedStartTime ? UIColor.themeBlue() : UIColor.lightGray
        endTimeLabel.textColor = !isSelectedStartTime ? UIColor.darkText : UIColor.lightGray
        endLine.backgroundColor = !isSelectedStartTime ? UIColor.themeBlue() : UIColor.lightGray
    }
}
