# CFComponents
自定义弹窗、左滑列表、单选多选列表、下拉列表、搜索等常用组件集合。

## 版本1.0.0

效果图：

![演示图1](https://github.com/chenfengxiaoxixi/CFComponents/blob/main/演示图/演示图1.gif)
![演示图2](https://github.com/chenfengxiaoxixi/CFComponents/blob/main/演示图/演示图2.gif)
![演示图3](https://github.com/chenfengxiaoxixi/CFComponents/blob/main/演示图/演示图3.gif)
![演示图4](https://github.com/chenfengxiaoxixi/CFComponents/blob/main/演示图/演示图4.gif)
![演示图5](https://github.com/chenfengxiaoxixi/CFComponents/blob/main/演示图/演示图5.gif)

弹窗：

```
    let alertView = CFAlertView(alertMsg: "这是一个提示框")
    alertView.showAlert(style: .defaultStyle)


```

单选组件：

```
    let vc = PMSingleSelectController()
    vc.delegate = self
    vc.dataSource = self
    vc.title = "单选"
    navigationController?.pushViewController(vc, animated: true)
    
    // MARK: 单选代理实现
    extension ViewController: PMSingleSelectDelegate {
    
        func singleTableView(_ singleTableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        }
    
        func searchAction(_ text: String, andReload singleTableView: UITableView) {

        }
    }

    extension ViewController: PMSingleSelectDataSource {
        func singleTableView(_ singleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        }
    
        func singleTableView(_ singleTableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        }
    }


```

下拉筛选组件

```
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
}
        
extension DropMenuController: ESDropMenuViewDelegate {
    func menuView(_ menuView: ESDropMenuView, didSelectRowAtIndexPath indexPath: ESIndexPath) {
        print("选择条件，更新数据")
    }
}

```
其他组件使用请查看项目代码
