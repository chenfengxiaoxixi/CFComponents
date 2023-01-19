//
//  PMSingleSelectController.swift
//  ParkManage
//
//  Created by 陈峰 on 2022/11/3.
//  Copyright © 2022 diligrp. All rights reserved.
//

import UIKit

@objc protocol PMSingleSelectDelegate: NSObjectProtocol {
    
    func singleTableView(_ singleTableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    func searchAction(_ text: String, andReload singleTableView: UITableView)
}

@objc protocol PMSingleSelectDataSource: NSObjectProtocol {
    
    func singleTableView(_ singleTableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func singleTableView(_ singleTableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath)
    -> UITableViewCell
    @objc optional func numberOfSectionsIn(mulTableView: UITableView) -> Int
}

class PMSingleSelectController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopCons: NSLayoutConstraint!
    
    weak open var delegate: PMSingleSelectDelegate?
    weak open var dataSource: PMSingleSelectDataSource?
    
    var isHiddenSearchText: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .themeBackGround()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .themeBackGround()
        
        let backBarItem = UIBarButtonItem(
            image: UIImage(named: "left_back_icon.png"),
            style: .plain,
            target: self,
            action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backBarItem
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        if isHiddenSearchText {
            tableViewTopCons.constant = 0
            textField.isHidden = true
        }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension PMSingleSelectController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSectionsIn?(mulTableView: tableView) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.singleTableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (dataSource?.singleTableView(tableView, cellForRowAtIndexPath: indexPath))!
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        return cell
    }
}

extension PMSingleSelectController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.singleTableView(tableView, didSelectRowAtIndexPath: indexPath)
        backAction()
    }
}

extension PMSingleSelectController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchAction(textField.text ?? "", andReload: tableView)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchAction(textField.text ?? "", andReload: tableView)
    }
}
