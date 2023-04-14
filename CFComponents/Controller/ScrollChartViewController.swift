//
//  ScrollChartViewController.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/4/14.
//

import UIKit

class ScrollChartViewController: BaseViewController {

    var chart: PMLinkedChart!
    var num = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chart = PMLinkedChart(frame: CGRect(x: 0,
                                            y: Configs.navBarWithStatusBarHeight,
                                            width: Configs.screenWidth,
                                            height: Configs.screenHeight - Configs.navBarWithStatusBarHeight))
        chart.dataSource = self
        chart.delegate = self
        view.addSubview(chart)

        chart.setEmptyView()
        chart.setLoadMoreView()
    }
}

extension ScrollChartViewController: PMLinkedChartDataSource {
    
    func numberOfRowsInChart() -> Int {
        return 10 * num
    }
    
    func leftTableViewColumnTitle() -> [String] {
        return ["序号", "商品分类"]
    }
    
    func rightTableViewColumnTitle() -> [String] {
        return ["规格","批发价","对比昨日","销量（公斤）","产地","供应时间","最高价","最低价"]
    }
    
    func leftTableViewColumnContentWith(indexPath: IndexPath) -> [String] {
        
        return ["\(indexPath.row + 1)", "苹果"]
    }
    
    func rightTableViewColumnContentWith(indexPath: IndexPath) -> [String] {
        return ["10kg"
                ,"1000"
                ,"+100%"
                ,"200"
                ,"chengdu"
                ,"2023-09-02"
                ,"1000"
                ,"200"]
    }
    
    func leftTableViewColumnTitleColorWith(indexPath: IndexPath) -> [UIColor] {
        return [.darkText, .darkText]
    }
    
    func rightTableViewColumnTitleColorWith(indexPath: IndexPath) -> [UIColor] {
        
//        let rise = viewModel.model?.records[indexPath.row].rise ?? "+"
//        var color = UIColor.themeRed()
//        if rise.contains("-") {
//            color = UIColor.themeGreen()
//        }
        
        return [.darkText, .darkText, UIColor.themeGreen(), .darkText, .darkText, .darkText, .darkText, .darkText]
    }
}

extension ScrollChartViewController: PMLinkedChartDelegate {
    
    func loadMoreChartData() {
        
        num += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if self.num == 4 {
                self.chart.setLoadAllData()
            } else {
                self.chart.setEndLoadMore()
            }
            
            self.chart.reloadChartData()
        }
    }
    
    func reloadChartData() {}
}
