//
//  ESSearchController.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/8.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

@objc protocol ESSearchResultViewDelegate: NSObjectProtocol {
    
    func searchWith(_ keyword: String, andUpdate resultView: UICollectionView)
    func resultViewRegisterClass(_ resultView: UICollectionView)
    func resultView(_ resultView: UICollectionView, didSelectRowAtIndex index:Int)
    @objc optional func backToPreLevel(_ resultView: UICollectionView)
    @objc optional func resultViewRegisterHeader(_ resultView: UICollectionView)
}

@objc protocol ESSearchResultViewDataSource: NSObjectProtocol {

    func resultViewFlowLayout() -> UICollectionViewFlowLayout
    func resultView(_ resultView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func resultView(_ resultView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    @objc optional func numberOfSectionsIn(resultView: UICollectionView) -> Int
    @objc optional func resultView(_ resultView: UICollectionView,
                                   headerForSection atIndexPath: IndexPath) -> UICollectionReusableView
}

class ESSearchController: UIViewController {

    weak open var delegate: ESSearchResultViewDelegate?
    weak open var dataSource: ESSearchResultViewDataSource?
    
    var cachePath: PlistPath! /// 指定缓存业务
    var searchBgView: UIView!
    var textField: UITextField!
    var historyCollectionView: UICollectionView!
    var resultCollectionView: UICollectionView!
    var searchCacheDatas: [String]!
    var isDisplayEditMode: Bool!
    var searchPlaceholder: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        isDisplayEditMode = false
        setSearchUI()
        setCollectionView()
    }
    
    func setSearchUI() {
        
        searchCacheDatas = SearchCacheManager.getPlistDataWith(path: cachePath)
        
        searchBgView = UIView(frame: CGRect(x: 40,y: 0,
                                            width: view.width - 120, height: 34))
        searchBgView.backgroundColor = .white
        searchBgView.layer.cornerRadius = 8
        
        let searchImage = UIImageView(frame: (CGRect(x: 3, y: 4, width: 28, height: 28)))
        searchImage.image = UIImage(named: "search.png")?.withRenderingMode(.alwaysTemplate)
        searchImage.tintColor = .lightGray
        searchBgView.addSubview(searchImage)
        
        textField = UITextField(frame: CGRect(x: searchImage.frame.maxX + 2, y: 0,
                                                  width: searchBgView.width - searchImage.frame.maxX - 2, height: 34))
        textField.clearButtonMode = .always
        textField.placeholder = searchPlaceholder
        textField.font = .systemFont(ofSize: 15)
        textField.delegate = self
        textField.returnKeyType = .search
        textField.textColor = .black
        searchBgView.addSubview(textField)
        
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }

        navigationItem.titleView = searchBgView
        
        let rightBarItem = UIBarButtonItem(
            title: "搜索",
            style: .plain,
            target: self,
            action: #selector(searchAction))
        
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
    
    func showInCurrentVC(controller: UIViewController) {
        
        controller.navigationController?.pushViewController(self, animated: false)
    }
    
    func setCollectionView() {
        
        let layout = ESHistoryCollectionFlowLayout()
        layout.estimatedItemSize = CGSize(width: 30, height: 30)
        layout.headerReferenceSize = CGSize(width: view.width, height: 45)
        historyCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
            width: view.width,
            height: view.height - Configs.navBarWithStatusBarHeight - Configs.bottomSafeArea),
        collectionViewLayout: layout)
        historyCollectionView.backgroundColor = .white
        historyCollectionView.showsVerticalScrollIndicator = false
        historyCollectionView.dataSource = self
        historyCollectionView.delegate = self
        view.addSubview(historyCollectionView)

        historyCollectionView.register(UINib.init(nibName: "ESHistoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "historyCollectionCell")
        historyCollectionView.register(
            ESHistoryCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryHeader")
        
        let resultLayout = dataSource?.resultViewFlowLayout()
        resultCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
            width: view.width,
            height: view.height),
            collectionViewLayout: resultLayout!)
        //resultCollectionView.backgroundColor = .white
        resultCollectionView.showsVerticalScrollIndicator = false
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
        resultCollectionView.isHidden = true
        resultCollectionView.backgroundColor = .themeBackGround()
        view.addSubview(resultCollectionView)
        
        delegate?.resultViewRegisterClass(resultCollectionView)
        delegate?.resultViewRegisterHeader?(resultCollectionView)
    }
    
    @objc func searchAction() {
        
        if textField.text!.count > 0 {
            SearchCacheManager.savePlist(data: textField.text!, with: cachePath)
    
            searchCacheDatas = SearchCacheManager.getPlistDataWith(path: cachePath)
            historyCollectionView.reloadData()
            navigationItem.titleView?.endEditing(true)
            
            historyCollectionView.isHidden = true
            resultCollectionView.isHidden  = false
            
            delegate?.searchWith(textField.text!, andUpdate: resultCollectionView)
            
        }
    }
    
    @objc func backAction() {
        delegate?.backToPreLevel?(resultCollectionView)
        navigationController?.popViewController(animated: false)
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
}
