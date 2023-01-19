//
//  ESPopupBottomListController.swift
//  EasySell_iOS
//
//  Created by Jalon on 4/30/20.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

protocol ESPopupBottomListDelegate: NSObjectProtocol {
    
    func listView(_ listView: UIScrollView, didSelectRowAtIndex index:Int)
}

@objc protocol ESPopupBottomListDataSource: NSObjectProtocol {

    func numberOfRowsInSection(_ listView: UIScrollView) -> Int
    func listView(_ listView: UIScrollView, titleForRowAtIndex index: Int) -> String
    func listViewWithSectiontitle(_ listView: UIScrollView) -> String
}

class ESPopupBottomListHeader: UIView {
    
    var titleLabel: UILabel!
    var cancelButton: UIButton!
    
    var cancelCallback: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .themeBackGround()
        
        titleLabel = UILabel(frame: CGRect(x: 14, y: 15, width: 200, height: 15))
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .darkText
        addSubview(titleLabel)
        
        cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: width - 30 - 6, y: 6, width: 30, height: 30)
        cancelButton.setImage(UIImage(named: "cancel_gray.png"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        addSubview(cancelButton)
    }
    
    @objc func cancel() {
        cancelCallback()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PMPopupCollectionCell: UICollectionViewCell {

    var title: UILabel!
    
    override init(frame: CGRect) {
            
        super.init(frame: frame)
        
        layer.cornerRadius = 8

        backgroundColor = .themeBackGround()
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        title.font = .systemFont(ofSize: 15)
        title.textAlignment = .center
        title.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ESPopupViewStyle {
    case line, grid
}

class ESPopupBottomListController: UIViewController {
    
    weak open var delegate: ESPopupBottomListDelegate?
    weak open var dataSource: ESPopupBottomListDataSource?
    
    var collectionView: UICollectionView!
    var tableView: UITableView!
    var selectedIndex: Int! = -1
    var style: ESPopupViewStyle = .line
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slideInTransitioning = PresentationManager()
    
        if style == ESPopupViewStyle.line {
            
            tableView = UITableView(frame: CGRect(x: 0, y: 0,
                width: view.width,
                height: slideInTransitioning.compactHeight),
                                  style: .plain)
            tableView.rowHeight = 44
            tableView.delegate = self
            tableView.dataSource = self
            tableView.showsHorizontalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.backgroundColor = .themeBackGround()
            view.addSubview(tableView)
        } else {
            
            let width = Configs.screenWidth - 40 - 45
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: width/2, height: 40)
            layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 13, right: 15)
            layout.minimumLineSpacing = 15
            layout.minimumInteritemSpacing = 15
            layout.headerReferenceSize = CGSize(width: Configs.screenWidth,
                                                height: 50)
            layout.sectionHeadersPinToVisibleBounds = true
            collectionView = UICollectionView(frame: CGRect(x: 20, y: 0,
                    width: Configs.screenWidth - 40,
                    height: slideInTransitioning.compactHeight),
            collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.showsVerticalScrollIndicator = false
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.layer.cornerRadius = 8
            view.addSubview(collectionView)
            
            collectionView.register(UICollectionReusableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeader")
            collectionView.register(PMPopupCollectionCell.self, forCellWithReuseIdentifier: "PMPopupCollectionCell")
        }
    }
    
    func setListViewHeight(height: CGFloat) {
        
        if style == ESPopupViewStyle.line {
            tableView.height = height
        } else {
            collectionView.height = height
        }
    }
}

extension ESPopupBottomListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsInSection(tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "marketIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        let text = dataSource?.listView(tableView, titleForRowAtIndex: indexPath.row)
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 2
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        if selectedIndex == indexPath.row {
            let accessoryImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            accessoryImage.image = UIImage(named: "custom_selected.png")
            cell.accessoryView = accessoryImage
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}

extension ESPopupBottomListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let accessoryImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        accessoryImage.image = UIImage(named: "custom_selected.png")
        
        cell?.accessoryView = accessoryImage
        
        delegate?.listView(tableView, didSelectRowAtIndex: indexPath.row)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ESPopupBottomListHeader(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 50))
        view.titleLabel.text = dataSource?.listViewWithSectiontitle(tableView)
        view.cancelCallback = { [unowned self] in
            
            self.dismiss(animated: true, completion: nil)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Configs.bottomSafeArea
    }
}

extension ESPopupBottomListController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int)
        -> Int {
        return dataSource?.numberOfRowsInSection(collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        var reusableview: UICollectionReusableView!

        if kind == UICollectionView.elementKindSectionHeader {

            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "CustomHeader",
                for: indexPath)
            reusableview = headerView
            
            let view = ESPopupBottomListHeader(frame: CGRect(x: 0, y: 0,
                                                             width: collectionView.width, height: 50))
            view.titleLabel.text = dataSource?.listViewWithSectiontitle(collectionView)
            view.cancelCallback = { [unowned self] in
                
                self.dismiss(animated: true, completion: nil)
            }
            reusableview.addSubview(view)
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PMPopupCollectionCell",
            for: indexPath) as? PMPopupCollectionCell

        let text = dataSource?.listView(collectionView, titleForRowAtIndex: indexPath.row)
        
        cell!.title.text = text
        
        if selectedIndex == indexPath.row {
            cell!.title.textColor = .themeBlue()
        } else {
            cell!.title.textColor = .label
        }
        return cell!
    }
}

extension ESPopupBottomListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.listView(collectionView, didSelectRowAtIndex: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}
