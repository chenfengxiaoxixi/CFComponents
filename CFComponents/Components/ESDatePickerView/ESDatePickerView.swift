//
//  ESDatePickerView.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/16.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESDatePickerView: UIView {

    var bgGrayView: UIButton!
    var headerUI: BusinessDataDateHeaderView!
    var datePicker: UIDatePicker!
    var animationView: UIView!
    
    var btnCallback: ((Bool) -> Void)!
    var leftBtnCallback: ((String, String) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgGrayView = UIButton(type: .custom)
        bgGrayView.frame = bounds
        bgGrayView.alpha = 0
        bgGrayView.backgroundColor = .black
        bgGrayView.addTarget(self, action: #selector(hiddenDateView), for: .touchUpInside)
        addSubview(bgGrayView)
        
        headerUI = BusinessDataDateHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: 82))
        headerUI.setBtnTitle(title: "确定")
        headerUI.delegate = self

        let minDate = "2000.01.01".toDate()
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 82, width: width, height: 218))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.init(identifier:"zh_CN")
        datePicker.backgroundColor = .white
        datePicker.maximumDate = Date()
        datePicker.minimumDate = minDate
        datePicker.addTarget(self, action:#selector(datePickerValueChange(datePicker:)), for: .valueChanged)
        //datePicker.setDate(Date(), animated:true)
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            
        }
        
        animationView = UIView(frame: CGRect(x: 0, y: height, width: width, height: headerUI.height + datePicker.height))
        animationView.backgroundColor = .white
        addSubview(animationView)
        
        animationView.addSubview(headerUI)
        animationView.addSubview(datePicker)
        
        displayDateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func hiddenDateView() {
        
        let completion: ((Bool) -> Void) = { _ in
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bgGrayView.alpha = 0
            self.animationView.y = self.height
        }, completion: completion)
    }
    
    @objc func displayDateView() {
        UIView.animate(withDuration: 0.3) {
            self.bgGrayView.alpha = 0.5
            self.animationView.y = self.height - self.animationView.height
        }
    }
    
    @objc func datePickerValueChange(datePicker: UIDatePicker) {
        
        if headerUI.isSelectedStartTime {
            headerUI.setStartTimeLabel(startTime: datePicker.date.toString())
        } else {
            headerUI.setEndTimeLabel(endTime: datePicker.date.toString())
        }
    }
    
    func setDate() {
        if headerUI.isSelectedStartTime {
            datePicker.setDate(headerUI.startTimeLabel.text?.toDate() ?? Date(), animated:true)
            
        } else {
            datePicker.setDate(headerUI.endTimeLabel.text?.toDate() ?? Date(), animated:true)
        }
    }
}

extension ESDatePickerView: BusinessDataDateHeaderViewDelegate {
    
    func headerView(_ headerView: BusinessDataDateHeaderView, didSelectStartTimeOrEnd isStart: Bool) {
        
        btnCallback(isStart)
        setDate()
    }
    
    func headerViewDidSelectLeftBtn(_ headerView: BusinessDataDateHeaderView) {
        
        if (headerView.startTimeLabel.text?.ToTimeInterval())! - (headerView.endTimeLabel.text?.ToTimeInterval())! > 0 {
            
            let alertView = CFAlertView(alertMsg: "起始日期不能大于结束日期！")
            alertView.showAlert(style: .defaultStyle)
            
            return
        }
        
        leftBtnCallback(headerView.startTimeLabel.text!, headerView.endTimeLabel.text!)
        hiddenDateView()
    }
}
