//
//  PMMultipleSelectController.swift
//  ParkManage
//
//  Created by cf on 2021/1/15.
//  Copyright © 2021 diligrp. All rights reserved.
//

import UIKit

@objc protocol PMMultipleSelectDelegate: NSObjectProtocol {
    
    func mulTableView(_ mulTableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    func sureAction(_ mulTableView: UITableView)
}

@objc protocol PMMultipleSelectDataSource: NSObjectProtocol {
    
    func mulTableView(_ mulTableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func mulTableView(_ mulTableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath)
    -> UITableViewCell
    @objc optional func numberOfSectionsIn(mulTableView: UITableView) -> Int
}

class PMMultipleSelectController: UIViewController {

    weak open var delegate: PMMultipleSelectDelegate?
    weak open var dataSource: PMMultipleSelectDataSource?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "选择"

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .themeBackGround()

        let rightBarItem = UIBarButtonItem(
            title: "确定",
            style: .plain,
            target: self,
            action: #selector(sure))
        
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        let backBarItem = UIBarButtonItem(
            image: UIImage(named: "left_back_icon.png"),
            style: .plain,
            target: self,
            action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backBarItem
        navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    @objc func sure() {
        delegate?.sureAction(tableView)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func popInCurrentVc(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: self)
        vc.present(nav, animated: true, completion: nil)
    }
}

extension PMMultipleSelectController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSectionsIn?(mulTableView: tableView) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.mulTableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (dataSource?.mulTableView(tableView, cellForRowAtIndexPath: indexPath))!
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        return cell
    }
}

extension PMMultipleSelectController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.mulTableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
}
