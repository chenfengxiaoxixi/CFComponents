//
//  CFAlertView.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/17.
//

import UIKit

enum AlertStyle {
    ///只显示确定按钮
    case defaultStyle
    ///显示确定和取消按钮
    case sureAndCancelStyle
}

class CFAlertView: UIView {

    private let scaleDisplayRatio: CGFloat = 0.5
    private let scaledisappearRatio: CGFloat = 0.5
    
    private var popView: UIView!
    private var popGreyView: UIButton!
    
    private var completeBtn: UIButton!
    private var alertMsgLabel: UILabel!
    
    private var msg: String!
    
    var btnActionCallBack: ((Int) -> Void)?
    
    var cancelBtn: UIButton!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    init(alertMsg: String) {
        
        super.init(frame: CGRect(x: 0, y: 0,
        width:Configs.screenWidth,
         height: Configs.screenHeight))
        
        msg = alertMsg
        setMainUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMainUI() {
        
        popGreyView = UIButton(type: .custom)
        popGreyView.frame = frame
        popGreyView.backgroundColor = .gray
        popGreyView.alpha = 0
        addSubview(popGreyView)
        
        let pageWidth = width - 80
        
        popView = UIView(frame: CGRect(x: 40, y: 0, width: pageWidth, height: 220))
        popView.backgroundColor = .white
        popView.center = self.center
        popView.layer.cornerRadius = 8
        popView.transform = popView.transform.scaledBy(x: scaleDisplayRatio, y: scaleDisplayRatio)
        popView.clipsToBounds = true
        addSubview(popView)
        
        let headGrayView = UIView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: 46))
        headGrayView.backgroundColor = .themeBackGround()
        popView.addSubview(headGrayView)
    
        let title = UILabel(frame: CGRect(x: 15, y: 16, width: 200, height: 14))
        title.font = .systemFont(ofSize: 15)
        title.textColor = .gray
        title.text = "提示"
        headGrayView.addSubview(title)
    
        cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: headGrayView.width - 30 - 8, y: 7, width: 30, height: 30)
        cancelBtn.setImage(UIImage(named: "cancel_gray.png"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        headGrayView.addSubview(cancelBtn)
        
        alertMsgLabel = UILabel(frame: CGRect(x: 20, y: headGrayView.frame.maxY + 30, width: pageWidth - 40, height: 60))
        alertMsgLabel.font = UIFont.systemFont(ofSize: 16)
        alertMsgLabel.textAlignment = .center
        alertMsgLabel.numberOfLines = 3
        alertMsgLabel.text = msg.count > 0 ? msg : "未知错误"
        popView.addSubview(alertMsgLabel)
        
        let animation = CABasicAnimation(keyPath: "bounds.size")
        animation.toValue = NSValue()
        animation.duration = 3.0
        
        UIView.animate(withDuration: 0.3) {
            self.popGreyView.alpha = 0.6
            self.popView.transform = CGAffineTransform.identity
        }
    }
    
    func showAlert(style: AlertStyle) {
        
        if style == .defaultStyle {
            
            let completeBtn = UIButton(type: .custom)
            completeBtn.frame = CGRect(x: 0, y: popView.height - 46, width: popView.width, height: 46)
            completeBtn.setTitle("确定", for: .normal)
            completeBtn.setTitleColor(.themeBlue(), for: .normal)
            completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            completeBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            completeBtn.tag = 101
            popView.addSubview(completeBtn)
            
            let lineView: UIView = UIView(frame: CGRect(x: 0, y: completeBtn.frame.minY - 1, width: popView.width, height: 1))
            lineView.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
            popView.addSubview(lineView)
            
        } else {
            
            let cancelBtn = UIButton(type: .custom)
            cancelBtn.frame = CGRect(x: 0, y: popView.height - 46, width: popView.width/2, height: 46)
            cancelBtn.setTitle("取消", for: .normal)
            cancelBtn.setTitleColor(.gray, for: .normal)
            cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            cancelBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            cancelBtn.tag = 100
            popView.addSubview(cancelBtn)
            
            let completeBtn = UIButton(type: .custom)
            completeBtn.frame = CGRect(x: popView.width/2, y: popView.height - 46, width: popView.width/2, height: 46)
            completeBtn.setTitle("确定", for: .normal)
            completeBtn.setTitleColor(.themeBlue(), for: .normal)
            completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            completeBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            completeBtn.tag = 101
            popView.addSubview(completeBtn)
            
            let lineView1: UIView = UIView(frame: CGRect(x: 0, y: cancelBtn.frame.minY - 1, width: popView.width, height: 1))
            lineView1.backgroundColor =
                UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
            popView.addSubview(lineView1)
                    
            let lineView2: UIView = UIView(frame: CGRect(x: cancelBtn.width, y: cancelBtn.frame.minY + 9, width: 1, height: 26))
            lineView2.backgroundColor =
                UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
            popView.addSubview(lineView2)
            
        }
        
        Configs.AppWindow.rootViewController?.view.addSubview(self)
    }
    
    @objc private func btnAction(btn: UIButton) {
        
        if (btnActionCallBack != nil) {
            btnActionCallBack!(btn.tag)
        }
        
        let complete:((Bool) -> Void)! = { (_) in
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
    
            self.popGreyView.alpha = 0
            self.popView.alpha = 0
            self.popView.transform = self.popView.transform.scaledBy(x: self.scaledisappearRatio, y: self.scaledisappearRatio)
    
        }, completion: complete)
    }

}
