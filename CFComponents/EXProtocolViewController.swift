//
//  EXProtocolViewController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/18.
//

import UIKit

// MARK: 单选
extension ViewController: PMSingleSelectDelegate {
    
    func singleTableView(_ singleTableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        for i in 0..<testArray.count where testArray[i].isSelected == true {
            testArray[i].isSelected = false
            break
        }
        
        testArray[indexPath.row].isSelected = true
        
        displayList[clickIndexPath.row].content = testArray[indexPath.row].title
        
        mainTableView.reloadRows(at: [clickIndexPath], with: .automatic)
    }
    
    func searchAction(_ text: String, andReload singleTableView: UITableView) {
        print("搜索业务，更新显示数据")
    }
}

extension ViewController: PMSingleSelectDataSource {
    func singleTableView(_ singleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func singleTableView(_ singleTableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = singleTableView.dequeueReusableCell(
            withIdentifier: "identifier") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item = testArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        if item.isSelected == true {
            cell.accessoryView = UIImageView(image: UIImage(named: "custom_selected.png"))
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
}

// MARK: 多选
extension ViewController: PMMultipleSelectDataSource {
    
    func mulTableView(_ mulTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray2.count
    }
    
    func mulTableView(_ mulTableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mulTableView.dequeueReusableCell(
            withIdentifier: "identifier") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item = testArray2[indexPath.row]
        cell.textLabel?.text = item.title
        
        if item.isSelected == true {
            cell.accessoryView = UIImageView(image: UIImage(named: "custom_selected.png"))
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}

extension ViewController: PMMultipleSelectDelegate {
    
    func mulTableView(_ mulTableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let cell = mulTableView.cellForRow(at: indexPath)
        
        let item = testArray2[indexPath.row]
        
        if item.isSelected == true {
            testArray2[indexPath.row].isSelected = false
            cell?.accessoryView = nil
        } else {
            testArray2[indexPath.row].isSelected = true
            cell?.accessoryView = UIImageView(image: UIImage(named: "custom_selected.png"))
        }
    }
    
    func sureAction(_ mulTableView: UITableView) {
        
        let selectedDatas = testArray2.filter { $0.isSelected == true }
        
        let titles = selectedDatas.map { $0.title }
    
        displayList[clickIndexPath.row].content = titles.joined(separator: ",")
        
        mainTableView.reloadRows(at: [clickIndexPath], with: .automatic)
    }
}

// MARK: 弹出框
extension ViewController: ESPopupBottomListDataSource {
    
    func numberOfRowsInSection(_ listView: UIScrollView) -> Int {
        return testArray3.count
    }
    
    func listView(_ listView: UIScrollView, titleForRowAtIndex index: Int) -> String {
        return testArray3[index].title
    }
    
    func listViewWithSectiontitle(_ listView: UIScrollView) -> String {
        return "请选择"
    }
}

extension ViewController: ESPopupBottomListDelegate {
    
    func listView(_ listView: UIScrollView, didSelectRowAtIndex index: Int) {

        displayList[clickIndexPath.row].content = testArray3[index].title
        
        mainTableView.reloadRows(at: [clickIndexPath], with: .automatic)
    }
}

// MARK: 搜索
extension ViewController: ESSearchResultViewDataSource {
    
    func resultViewFlowLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Configs.screenWidth, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
        layout.minimumLineSpacing = 10
        
        return layout
    }
    
    func resultView(_ resultView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray.count
    }
    
    //传入自定义cell
    func resultView(_ resultView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PMPopupCollectionCell = resultView.dequeueReusableCell(
            withReuseIdentifier: "displayCell",
            for: indexPath) as! PMPopupCollectionCell
            
        cell.title.text = testArray[indexPath.row].title
        return cell
    }
}

extension ViewController: ESSearchResultViewDelegate {
    
    func resultViewRegisterClass(_ resultView: UICollectionView) {
        resultView.register(PMPopupCollectionCell.self, forCellWithReuseIdentifier: "displayCell")
    }
    
    //搜索更新数据
    func searchWith(_ keyword: String, andUpdate resultView: UICollectionView) {

    }
    
    func resultView(_ resultView: UICollectionView, didSelectRowAtIndex index: Int) {

    }
    
    func backToPreLevel(_ resultView: UICollectionView) {

    }
}
