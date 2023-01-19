//
//  CompoundComponentController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/19.
//

import UIKit

class CompoundComponentController: UIViewController {

    var dropMenuView: ESDropMenuView!
    var dropMenuViewTwo: ESDropMenuView!
    var interVarDropView: ESDropMenuView!
    
    var menuTapIndex: Int!
    var data1: [ComponentsTestModel] = []
    var data2: [ComponentsTestModel] = []
    var data3: [ComponentsTestModel] = []
    var data4: [ComponentsTestModel] = []
    var data5: [ComponentsTestModel] = []
    
    var marketName: String = "全部市场"
    var areaName: String = "全部区域"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackGround()
        
        configDropData()
        
        setUpDropView()
    }
    
    func configDropData() {
        data1.append(ComponentsTestModel(title: "全部市场"))
        data2.append(ComponentsTestModel(title: "全部员工"))
        data3.append(ComponentsTestModel(title: "全部状态"))
        data4.append(ComponentsTestModel(title: "全部区域"))
        data5.append(ComponentsTestModel(title: "全部货位"))
        
        for i in 0..<5 {
            data1.append(ComponentsTestModel(title: "市场\(i)"))
            data2.append(ComponentsTestModel(title: "员工\(i)"))
            data3.append(ComponentsTestModel(title: "状态\(i)"))
            data4.append(ComponentsTestModel(title: "区域\(i)"))
            data5.append(ComponentsTestModel(title: "货位\(i)"))
        }
        
    }
    
    func setUpDropView() {
        dropMenuView = ESDropMenuView(
            frame: CGRect(x: 0,
                          y: Configs.navBarWithStatusBarHeight + 10,
                          width: Configs.screenWidth,
                          height: 40
            )
        )
        dropMenuView.bgColor = .white
        dropMenuView.numOfMenu = 3
        dropMenuView.textColor = .gray
        dropMenuView.font = .systemFont(ofSize: 14)
        dropMenuView.selectColor = .themeBlue()
        dropMenuView.indicatorColor = .black
        dropMenuView.delegate = self
        dropMenuView.dataSource = self
        view.addSubview(dropMenuView)
        
        dropMenuViewTwo = ESDropMenuView(
            frame: CGRect(x: 0,
                          y: Configs.navBarWithStatusBarHeight + 49,
                          width: Configs.screenWidth/3*2,
                          height: 40
            )
        )
        dropMenuViewTwo.bgColor = .white
        dropMenuViewTwo.numOfMenu = 2
        dropMenuViewTwo.textColor = .gray
        dropMenuViewTwo.font = .systemFont(ofSize: 14)
        dropMenuViewTwo.selectColor = .themeBlue()
        dropMenuViewTwo.indicatorColor = .black
        dropMenuViewTwo.delegate = self
        dropMenuViewTwo.dataSource = self
        view.addSubview(dropMenuViewTwo)
        
        let rightPaddingView = UIView(frame: CGRect(x: dropMenuViewTwo.frame.maxX,
                                                    y: dropMenuViewTwo.frame.minY,
                                                    width: Configs.screenWidth/3,
                                                    height: 40))
        rightPaddingView.backgroundColor = .white
        view.addSubview(rightPaddingView)
    }
    
    func getMarkets() {
        
        let childVc = PMLeftSlidingController()
        childVc.dataSource = self
        childVc.delegate = self
        childVc.isShowSearchView = true
        childVc.selectedName = marketName
        childVc.displayLeftSlidingVC(in: self)
    }
    
    func getAreas() {
        
        let childVc = PMLeftSlidingController()
        childVc.dataSource = self
        childVc.delegate = self
        childVc.isShowSearchView = true
        childVc.selectedName = areaName
        childVc.displayLeftSlidingVC(in: self)
    }
}

extension CompoundComponentController: ESDropMenuViewDataSource {
    func menuView(_ menuView: ESDropMenuView, getColumnDropListStyle column: Int) -> Int {

        return DropListStyle.line.rawValue
    }

    func menuView(_ menuView: ESDropMenuView, numberOfRowsInColumn column: Int, row: Int) -> Int {
        if column == 0 {
            return 0
        } else if column == 1 {
            
            if menuView == dropMenuView {
                return data2.count
            }
            return data5.count
        } else if column == 2 {
            return data3.count
        }
        return 0
    }

    func menuView(_ menuView: ESDropMenuView, titleForRowAtIndexPath indexPath: ESIndexPath) -> String {
        if indexPath.column == 0 {
            
            if menuView == dropMenuView {
                return marketName
            }
            return areaName
        } else if indexPath.column == 1 {
            if menuView == dropMenuView {
                return data2[indexPath.row].title
            }
            return data5[indexPath.row].title
        } else if indexPath.column == 2 {
            return data3[indexPath.row].title
        }
        return ""
    }

    func menuView(_ menuView: ESDropMenuView, titleForColumn column: Int) -> String {
        if column == 0 {
            
            if menuView == dropMenuView {
                return marketName
            }
            return areaName
        } else if column == 1 {
            if menuView == dropMenuView {
                return "全部员工"
            }
            return "全部货位"
        } else if column == 2 {
            return "全部状态"
        }
        return ""
    }
}

extension CompoundComponentController: ESDropMenuViewDelegate {
    
    func menuView(_ menuView: ESDropMenuView, didSelectRowAtIndexPath indexPath: ESIndexPath) {
        
    }
    
    func menuView(_ menuView: ESDropMenuView, didSelectMenuIndex index: Int, isShow: Bool) {
        
        if isShow && interVarDropView != menuView && interVarDropView != nil {
            interVarDropView.closeSelectedMenuDropView(index: menuTapIndex)
        }
        
        interVarDropView = menuView
        
        if index == 0 && isShow {
            if menuView == dropMenuView {
                getMarkets()
            } else {
                getAreas()
            }
        }
        
        menuTapIndex = index
    }
}

extension CompoundComponentController: PMLeftSlidingDataSource {
    
    func numberOfRowsInSection(_ listView: UITableView) -> Int {
        
        if interVarDropView == dropMenuView {
            return data1.count
        }
        
        return data4.count
    }
    
    func listView(_ listView: UITableView, titleForRowAtIndex index: Int) -> String {
        
        if interVarDropView == dropMenuView {
            return data1[index].title
        }
        
        return data4[index].title
    }
}

extension CompoundComponentController: PMLeftSlidingDelegate {
    
    func listView(_ listView: UITableView, didSelectRowAtIndex index: Int) {
        
        if interVarDropView == dropMenuView {
            marketName = data1[index].title
        } else {
            areaName = data4[index].title
        }
        interVarDropView.operateMenuWithIndex(index: 0)
    }
    
    func listViewCancelAction() {
        interVarDropView.operateMenuWithIndex(index: 0)
    }
    
    // 搜索更新数据
    func searchActionWith(keyWord: String, listView: UITableView) {
        
//        self.areaDatas?.insert(ApproachManageAreaModel(name: "全部区域", id: nil), at: 0)
//        listView.reloadData()
    }
}
