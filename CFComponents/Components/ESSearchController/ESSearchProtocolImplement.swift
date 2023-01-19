//
//  ESSearchProtocolImplement.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/8.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESHistoryCollectionHeader: UICollectionReusableView {
    
    var btnView: UIView!
    var btnActionWithBlock: ((Int) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let title = UILabel.init(frame: CGRect(x: 14, y: 17, width: width, height: 15))
        title.textColor = .darkText
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = "最近搜索"
        addSubview(title)
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.tag = 100
        deleteBtn.frame = CGRect(x: width - 22 - 20, y: 15, width: 20, height: 20)
        deleteBtn.setImage(UIImage(named: "delete.png") , for: .normal)
        deleteBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        addSubview(deleteBtn)
        
        btnView = UIView(frame: CGRect(x: width, y: 15, width: 120, height: 20))
        btnView.backgroundColor = .white
        btnView.layer.cornerRadius = 4
        addSubview(btnView)
        
        let allDeleteBtn = UIButton(type: .custom)
        allDeleteBtn.tag = 101
        allDeleteBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        allDeleteBtn.setTitle("全部删除", for: .normal)
        allDeleteBtn.setTitleColor(.black, for: .normal)
        allDeleteBtn.titleLabel?.font = .systemFont(ofSize: 12)
        allDeleteBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        btnView.addSubview(allDeleteBtn)
        
        let completeBtn = UIButton(type: .custom)
        completeBtn.tag = 102
        completeBtn.frame = CGRect(x: 60, y: 0, width: 60, height: 20)
        completeBtn.setTitle("完成", for: .normal)
        completeBtn.setTitleColor(.red, for: .normal)
        completeBtn.titleLabel?.font = .systemFont(ofSize: 12)
        completeBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        btnView.addSubview(completeBtn)
        
        let verticalLine = UIView(frame: CGRect(x: 60, y: 4, width: 1, height: 12))
        verticalLine.backgroundColor = UIColor.init(red: 221, green: 221, blue: 221, alpha: 1)
        btnView.addSubview(verticalLine)
    }
    
    func hiddenEditView() {
        UIView.animate(withDuration: 0.25) {
            self.btnView.x = self.width
        }
    }
    
    @objc func btnAction(sender: UIButton) {
        
        if sender.tag == 100 {
            
            UIView.animate(withDuration: 0.25) {
                self.btnView.x = self.width - 120 - 12
            }
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.btnView.x = self.width
            }
        }
        btnActionWithBlock(sender.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ESSearchController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == historyCollectionView {
            return 1
            
        } else {
            
            return dataSource?.numberOfSectionsIn?(resultView: collectionView) ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int {
            
            if collectionView == historyCollectionView {
                return searchCacheDatas.count
                
            } else {
                
                return dataSource?.resultView(resultCollectionView, numberOfItemsInSection: section) ?? 0
            }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        var reusableview : UICollectionReusableView!

        if kind == UICollectionView.elementKindSectionHeader &&
            collectionView == historyCollectionView {

            let headerView: ESHistoryCollectionHeader! = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "HistoryHeader",
                for: indexPath) as? ESHistoryCollectionHeader
                reusableview = headerView

            if !isDisplayEditMode {
                headerView.hiddenEditView()
            }

            headerView.btnActionWithBlock = { [weak self] (tag) in

                self?.navigationItem.titleView?.endEditing(true)

                self?.isDisplayEditMode = !(self?.isDisplayEditMode)!

                if tag == 101 {
                    SearchCacheManager.deletePlistAllData(with: self!.cachePath)
                    self?.searchCacheDatas = SearchCacheManager.getPlistDataWith(path: self!.cachePath)
                }
                collectionView.reloadData()
            }
        } else if kind == UICollectionView.elementKindSectionHeader &&
            collectionView == resultCollectionView {
            reusableview = dataSource?.resultView!(resultCollectionView, headerForSection: indexPath)
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == historyCollectionView {
            let cell: ESHistoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCollectionCell",for: indexPath) as! ESHistoryCollectionCell

            cell.backgroundColor = UIColor.themeBackGround()
            cell.titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            cell.titleLabel.text = searchCacheDatas[indexPath.row]

            if isDisplayEditMode {
                cell.deleteBtn.isHidden = false
            } else {
                cell.deleteBtn.isHidden = true
            }
            
            return cell
        } else {
            
            let cell = (dataSource?.resultView(resultCollectionView, cellForItemAtIndexPath: indexPath))!

            return cell
        }
    }
}
 
extension ESSearchController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == historyCollectionView {
            
            if isDisplayEditMode {
                SearchCacheManager.deletePlistData(at: indexPath.row, with: cachePath)
                searchCacheDatas = SearchCacheManager.getPlistDataWith(path: cachePath)
                collectionView.reloadData()
            } else {
                
                textField.text = searchCacheDatas[indexPath.row]
                historyCollectionView.isHidden = true
                resultCollectionView.isHidden = false
                navigationItem.titleView?.endEditing(true)
                
                delegate?.searchWith(textField.text!, andUpdate: resultCollectionView)
            }
        } else {
            
            delegate?.resultView(resultCollectionView, didSelectRowAtIndex: indexPath.row)
        }
    }
}

extension ESSearchController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 0 {
            SearchCacheManager.savePlist(data: textField.text!, with: cachePath)
            searchCacheDatas = SearchCacheManager.getPlistDataWith(path: cachePath)
            historyCollectionView.reloadData()
            navigationItem.titleView?.endEditing(true)
            
            historyCollectionView.isHidden = true
            resultCollectionView.isHidden  = false
            delegate?.searchWith(textField.text!, andUpdate: resultCollectionView)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        isDisplayEditMode = false
        historyCollectionView.reloadData()
        historyCollectionView.isHidden = false
        resultCollectionView.isHidden  = true
    }
    
}
