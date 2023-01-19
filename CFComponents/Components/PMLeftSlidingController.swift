//
//  PMLeftSlidingController.swift
//  ParkManage
//
//  Created by 陈峰 on 2022/5/11.
//  Copyright © 2022 diligrp. All rights reserved.
//

import UIKit

@objc protocol PMLeftSlidingDelegate: NSObjectProtocol {
    
    func listView(_ listView: UITableView, didSelectRowAtIndex index:Int)
    @objc optional func listViewCancelAction()
    @objc optional func searchActionWith(keyWord: String, listView: UITableView)
}

protocol PMLeftSlidingDataSource: NSObjectProtocol {

    func numberOfRowsInSection(_ listView: UITableView) -> Int
    func listView(_ listView: UITableView, titleForRowAtIndex index: Int) -> String
}

class PMLeftSlidingController: UIViewController {

    weak open var delegate: PMLeftSlidingDelegate?
    weak open var dataSource: PMLeftSlidingDataSource?
    
    var bgGrayView: UIButton!
    var tableView: UITableView!
    var tableViewBgView: UIView!
    
    let tableViewWidth: CGFloat = Configs.screenWidth * 0.55
    
    var isShowSearchView: Bool = false
    var placeholder: String = "输入内容"
    
    var textField: UITextField!
    
    var selectedName: String = "-1"
    
    // MARK: - deinit
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgGrayView = UIButton(type: .custom)
        bgGrayView.frame = view.bounds
        bgGrayView.alpha = 0
        bgGrayView.backgroundColor = .black
        bgGrayView.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        view.addSubview(bgGrayView)
        
        tableView = UITableView(frame: CGRect(x: -tableViewWidth,
                                              y: Configs.navBarWithStatusBarHeight + 10,
                                              width: tableViewWidth,
                                              height: view.height - (Configs.navBarWithStatusBarHeight + 10)),
                                style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        //tableView.contentInsetAdjustmentBehavior = .always
        tableView.showsHorizontalScrollIndicator = false
        
        tableViewBgView = UIView(frame: CGRect(x: -tableViewWidth,
                                               y: 0,
                                               width: tableViewWidth,
                                               height: view.height))
        tableViewBgView.backgroundColor = .themeBackGround()
        view.addSubview(tableViewBgView)

        tableView.backgroundColor = .themeBackGround()
        view.addSubview(tableView)

//        if #available(iOS 15.0, *) {
//            self.tableView.sectionHeaderTopPadding = 0
//        } else {
//            // Fallback on earlier versions
//        }

        if isShowSearchView {
            textField = UITextField()
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 15)
            textField.leftViewMode = .always
            textField.delegate = self
            textField.returnKeyType = .done
            textField.backgroundColor = UIColor.init(
                red: 232.0/255.0, green: 233.0/255.0, blue: 234.0/255.0, alpha: 1)
            textField.layer.cornerRadius = 18
            textField.placeholder = placeholder
            view.addSubview(textField)
        }
    }
    
    func displayLeftSlidingVC(in controller: UIViewController) {
        
        controller.addChild(self)
        self.didMove(toParent: controller)
        self.view.frame = controller.view.bounds
        controller.view.addSubview(view)
        
        UIView.animate(withDuration: 0.3) {
            self.bgGrayView.alpha = 0.5
            self.tableView.x = 0
            self.tableViewBgView.x = 0
        }
    }
    
    @objc func cancelAction() {
        UIView.animate(withDuration: 0.3) {
            self.bgGrayView.alpha = 0
            self.tableView.x = -self.tableViewWidth
            self.tableViewBgView.x = -self.tableViewWidth
            self.delegate?.listViewCancelAction?()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}

extension PMLeftSlidingController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        delegate?.searchActionWith?(keyWord: text, listView: tableView)
        
        return true
    }
}

extension PMLeftSlidingController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource?.numberOfRowsInSection(tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "marketIdentifier") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.textLabel?.text = dataSource?.listView(tableView, titleForRowAtIndex: indexPath.row)
        cell.textLabel?.textColor = .label
        
        if selectedName == cell.textLabel?.text {
            cell.textLabel?.textColor = .themeBlue()
        }
        
        return cell
    }
}

extension PMLeftSlidingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        
        if header == nil {
            header?.backgroundView?.backgroundColor = .white
            header = UITableViewHeaderFooterView(reuseIdentifier: "header")
            if isShowSearchView {
                textField.frame = CGRect(x: 10, y: 9, width: tableViewWidth - 20, height: 34)
                textField.backgroundColor = .white
                header?.addSubview(textField)
            }
        }

        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer")
        
        if footer == nil {
            footer = UITableViewHeaderFooterView(reuseIdentifier: "footer")
            footer?.backgroundColor = .clear
        }

        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isShowSearchView ? 50 : 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.listView(tableView, didSelectRowAtIndex: indexPath.row)
        cancelAction()
    }
}
