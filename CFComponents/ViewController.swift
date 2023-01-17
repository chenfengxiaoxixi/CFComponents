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
    var type: ClickType
}

class ViewController: UIViewController {
    
    var tableView: UITableView!
    
    var displayList: [DisplayModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "主页"
        view.backgroundColor = .white
        
        configDisplayList()
        
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.width,
                                              height: view.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    func configDisplayList() {
        displayList.append(DisplayModel(title: "弹窗", type: .showInVc))
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "marketIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = displayList[indexPath.row].title
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        cell.accessoryType = displayList[indexPath.row].type == .showInVc ?
            .none : .disclosureIndicator
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickAction(title: displayList[indexPath.row].title)
    }
}


extension ViewController {
    
    func clickAction(title: String) {
        
        switch title {
        case "弹窗":
            
            let alertView = CFAlertView(alertMsg: "这是一个提示框")
            alertView.showAlert(style: .defaultStyle)
            
        default:()
            
        }
    }
}
 
