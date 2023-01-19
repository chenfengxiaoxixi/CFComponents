//
//  EXFuncViewController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/18.
//

import Foundation

extension ViewController {
    
    func clickAction(title: String) {
        
        switch title {
        case "弹窗1":
            
            let alertView = CFAlertView(alertMsg: "这是一个提示框")
            alertView.showAlert(style: .defaultStyle)
            
        case "弹窗2":
            
            let alertView = CFAlertView(alertMsg: "这是一个提示框")
            alertView.showAlert(style: .sureAndCancelStyle)
            alertView.btnActionCallBack = { tag in
                if tag == 101 {
                    print("确定")
                }
            }
        case "单选组件":
            
            let vc = PMSingleSelectController()
            vc.delegate = self
            vc.dataSource = self
            vc.title = "单选"
            navigationController?.pushViewController(vc, animated: true)
            
        case "多选组件":
            
            let vc = PMMultipleSelectController()
            vc.delegate = self
            vc.dataSource = self
            vc.popInCurrentVc(vc: self)
            
        case "弹出单选1":
           
            let slideInTransitioning = PresentationManager()
            slideInTransitioning.compactHeight = 400
            let vc = ESPopupBottomListController()
            vc.delegate = self
            vc.dataSource = self
            vc.selectedIndex = testArray3.firstIndex{ $0.title == displayList[clickIndexPath.row].content }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = slideInTransitioning
            self.present(vc, animated: true, completion: nil)
            vc.setListViewHeight(height: 400)
            
        case "弹出单选2":
            
            let slideInTransitioning = PresentationManager()
            slideInTransitioning.direction = .center

            let vc = ESPopupBottomListController()
            vc.style = .grid
            vc.delegate = self
            vc.dataSource = self
            vc.selectedIndex = testArray3.firstIndex{ $0.title == displayList[clickIndexPath.row].content }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = slideInTransitioning
            self.present(vc, animated: true, completion: nil)
            
        case "时间段选择":
            let pickView = ESDatePickerView(frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: view.height))
            view.addSubview(pickView)
            pickView.headerUI.setStartTimeLabel(startTime: self.startTime)
            pickView.headerUI.setEndTimeLabel(endTime: self.endTime)
            pickView.headerUI.isSelectedStartTime = true
            pickView.setDate()
            pickView.btnCallback = { (isSelectedStartTime) in

                //headerView.isSelectedStartTime = isSelectedStartTime
            }
            pickView.leftBtnCallback = { [unowned self] (start, end) in
                self.startTime = start
                self.endTime = end
                
                displayList[clickIndexPath.row].content = start + "-" + end
                
                mainTableView.reloadRows(at: [clickIndexPath], with: .automatic)
            }
        case "下拉筛选组件":
            let dropVc = DropMenuController()
            dropVc.title = "下拉筛选组件"
            navigationController?.pushViewController(dropVc, animated: true)
        case "搜索组件":
            let vc = ESSearchController()
            vc.cachePath = .customerCache
            vc.searchPlaceholder = "请输入客户姓名"
            vc.delegate = self
            vc.dataSource = self
            vc.showInCurrentVC(controller: self)
        case "查看图片":
            
            let vc = ESPictureZoomController()
            vc.imageArray = ["10产品电子码的格式.png", "11EPC系统的构成.png", "12EPC系统工作流程图.png"]
            vc.selectedIndex = 0
            vc.showInCurrentVC(controller: self)
            
        case "下拉选项":
            let dropListView = ESDropListView(datas: testArray4)
            dropListView.show(x: 150, y: 240)
            dropListView.didSelectedRowCallback = { [unowned self] (row) in

                self.displayList[clickIndexPath.row].content = testArray4[row].title
                
                self.mainTableView.reloadRows(at: [clickIndexPath], with: .automatic)
            }
            dropListView.cancelCallback = {
                
            }
            
        case "复合组件":
            
            let vc = CompoundComponentController()
            vc.title = "复合组件"
            navigationController?.pushViewController(vc, animated: true)
            
        default:()
            
        }
    }
}

