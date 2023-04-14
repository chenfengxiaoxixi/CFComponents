//
//  DropMenuController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/18.
//

import UIKit

class DropMenuController: BaseViewController {

    var dropView: ESDropMenuView!
    var options1: [ComponentsTestModel] = []
    var options2: [ComponentsTestModel] = []
    var options3: [ComponentsTestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configOptionsData()
        
        dropView = ESDropMenuView(frame: CGRect(x: 0,
                                                y:Configs.navBarWithStatusBarHeight + 10,
                                                width: Configs.screenWidth,
                                                height: 40))
        dropView.bgColor = .white
        dropView.numOfMenu = 3
        dropView.textColor = .black
        dropView.selectColor = .themeBlue()
        dropView.indicatorColor = .lightGray
        dropView.delegate = self
        dropView.dataSource = self
        view.addSubview(dropView)
    }
    
    func configOptionsData() {
        
        options1.append(ComponentsTestModel(title: "全部员工"))
        options2.append(ComponentsTestModel(title: "全部市场"))
        options3.append(ComponentsTestModel(title: "全部状态"))
        
        for i in 0..<5 {
            options1.append(ComponentsTestModel(title: "员工\(i)"))
            options2.append(ComponentsTestModel(title: "市场\(i)"))
            options3.append(ComponentsTestModel(title: "状态\(i)"))
        }
    }
}

extension DropMenuController: ESDropMenuViewDataSource {
    
    func menuView(_ menuView: ESDropMenuView, getColumnDropListStyle column: Int) -> Int {
        return DropListStyle.line.rawValue
    }
    
    func menuView(_ menuView: ESDropMenuView, titleForColumn column: Int) -> String {
        switch column {
        case 0: return options1[0].title
        case 1: return options2[0].title
        case 2: return options3[0].title
        default: return ""
        }
    }
    
    func menuView(_ menuView: ESDropMenuView, numberOfRowsInColumn column: Int, row: Int) -> Int {
            
        switch column {
        case 0: return options1.count
        case 1: return options2.count
        case 2: return options3.count
        default: return 0
        }
    }
        
    func menuView(_ menuView: ESDropMenuView, titleForRowAtIndexPath indexPath: ESIndexPath) -> String {
            
        switch indexPath.column {
        case 0: return options1[indexPath.row].title
        case 1: return options2[indexPath.row].title
        case 2: return options3[indexPath.row].title
        default: return ""
        }
    }
}
        
extension DropMenuController: ESDropMenuViewDelegate {
    func menuView(_ menuView: ESDropMenuView, didSelectRowAtIndexPath indexPath: ESIndexPath) {
        print("选择条件，更新数据")
    }
}
