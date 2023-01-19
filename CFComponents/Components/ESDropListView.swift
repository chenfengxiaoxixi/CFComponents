//
//  ESDropListView.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/24.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESDropListView: UIView {

    struct DropTypeItem {
        var title: String
        var key: String?
        var state: Int?
    }
    
    var shadowView: UIView!
    var popGreyView: UIButton!
    var tableView: UITableView!
    var datas: [DropTypeItem]! = []
    var rowHeight = 46
    var cellColor: UIColor = .white
    
    var didSelectedRowCallback: ((Int) -> Void)!
    var cancelCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMainUI()
    }
    
    init(datas: [DropTypeItem]) {
        super.init(frame: CGRect(x: 0, y: 0,
        width:Configs.screenWidth,
         height: Configs.screenHeight))
        
        self.datas = datas
        
        setMainUI()
    }
    
    func setMainUI() {
        
        popGreyView = UIButton(type: .custom)
        popGreyView.frame = frame
        popGreyView.backgroundColor = .clear
        popGreyView.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        addSubview(popGreyView)
        
        shadowView = UIView(frame: CGRect(
                                x: 0,
                                y: 0,
                                width: 120,
                                height: CGFloat(rowHeight * datas.count)))
        shadowView.alpha = 0
        addSubview(shadowView)
        shadowView.setShadowWith(bounds: CGRect(x: 0, y: 0, width: 120, height: CGFloat(rowHeight * datas.count)))
        
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: 0,
            width: 120,
            height: CGFloat(rowHeight * datas.count)))
        tableView.rowHeight = CGFloat(rowHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.height = 0
        addSubview(tableView)
        
        UIView.animate(withDuration: 0.15) {
            self.tableView.height = CGFloat(self.rowHeight * self.datas.count)
            self.shadowView.alpha = 1
        }
    }
    
    func setCellColor(color: UIColor) {
        cellColor = color
        tableView.layer.cornerRadius = 4
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelAction() {
        let complete:((Bool) -> Void)! = { (_) in
            if self.cancelCallback != nil {
                self.cancelCallback!()
            }
            
            self.removeFromSuperview()
        }

        UIView.animate(withDuration: 0.15, animations: {
            self.tableView.height = 0
            self.shadowView.alpha = 0
        }, completion: complete)
    }
    
    func show(x: CGFloat, y: CGFloat) {

        tableView.y = y
        tableView.x = x
        
        shadowView.center = tableView.center
        Configs.AppWindow.rootViewController?.view.addSubview(self)
    }
}

extension ESDropListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "marketIdentifier") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        let item = datas[indexPath.row]
        
        cell.contentView.backgroundColor = cellColor
        cell.selectionStyle = .none
        cell.textLabel?.text = item.title
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        return cell
    }
}

extension ESDropListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedRowCallback(indexPath.row)
        cancelAction()
    }
}
