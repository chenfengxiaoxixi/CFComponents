//
//  ViewController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/17.
//

import UIKit

enum ClickType {
    case showInVc, enterNextVc
}

struct DisplayModel {
    var title: String
    var content: String?
    var type: ClickType
}

struct ComponentsTestModel {
    var title: String
    var isSelected: Bool = false
}

class ViewController: UIViewController {
    
    var mainTableView: UITableView!
    
    var clickIndexPath: IndexPath!
    
    var displayList: [DisplayModel] = []
    
    var testArray: [ComponentsTestModel] = []
    var testArray2: [ComponentsTestModel] = []
    var testArray3: [ComponentsTestModel] = []
    var testArray4: [ESDropListView.DropTypeItem] = []
    
    var startTime: String = Date().toString(withFormatter: "yyyy.MM.dd")
    var endTime: String = Date().toString(withFormatter: "yyyy.MM.dd")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "主页"
        view.backgroundColor = .white
        
        configDisplayList()
        configTestList()
        
        mainTableView = UITableView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.width,
                                              height: view.height), style: .grouped)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 55
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.backgroundColor = .themeBackGround()
        view.addSubview(mainTableView)
    }
    
    func configDisplayList() {
        
        displayList.append(DisplayModel(title: "弹窗1", type: .showInVc))
        displayList.append(DisplayModel(title: "弹窗2", type: .showInVc))
        displayList.append(DisplayModel(title: "单选组件", type: .enterNextVc))
        displayList.append(DisplayModel(title: "多选组件", type: .enterNextVc))
        displayList.append(DisplayModel(title: "弹出单选1", type: .showInVc))
        displayList.append(DisplayModel(title: "弹出单选2", type: .showInVc))
        displayList.append(DisplayModel(title: "时间段选择", content: startTime + "-" + endTime, type: .showInVc))
        displayList.append(DisplayModel(title: "下拉筛选组件", type: .enterNextVc))
        displayList.append(DisplayModel(title: "搜索组件", type: .enterNextVc))
        displayList.append(DisplayModel(title: "查看图片", type: .enterNextVc))
        displayList.append(DisplayModel(title: "下拉选项", type: .showInVc))
        displayList.append(DisplayModel(title: "复合组件", type: .enterNextVc))
        displayList.append(DisplayModel(title: "滚动图表", type: .enterNextVc))
    }
    
    func configTestList() {
        
        for i in 0..<10 {
            testArray.append(ComponentsTestModel(title: "单选test\(i)"))
            testArray2.append(ComponentsTestModel(title: "多选test\(i)"))
            testArray3.append(ComponentsTestModel(title: "弹出单选test\(i)"))
        }
        
        testArray4 = [ESDropListView.DropTypeItem(title: "客户1", key: "key1"),
                      ESDropListView.DropTypeItem(title: "客户2", key: "key2"),
                      ESDropListView.DropTypeItem(title: "客户3", key: "key3"),
                      ESDropListView.DropTypeItem(title: "客户4", key: "key4")]
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "marketIdentifier") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text = displayList[indexPath.row].title
        cell.detailTextLabel?.text = displayList[indexPath.row].content
        cell.detailTextLabel?.font = .systemFont(ofSize: 14)
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        cell.accessoryType = displayList[indexPath.row].type == .showInVc ?
            .none : .disclosureIndicator
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        clickIndexPath = indexPath
        
        clickAction(title: displayList[indexPath.row].title)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
 
