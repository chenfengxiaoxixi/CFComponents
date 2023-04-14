//
//  BaseViewController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/4/14.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackGround()
        
        let backBarItem = UIBarButtonItem(
            image: UIImage(named: "left_back_icon.png"),
            style: .plain,
            target: self,
            action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backBarItem
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
