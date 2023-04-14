//
//  PMLinkedChart.swift
//  ParkManage
//
//  Created by 陈峰 on 2023/3/15.
//  Copyright © 2023 diligrp. All rights reserved.
//

import UIKit

let leftColumnW1 = 55.0
let leftColumnW2 = 110.0

let rightColumnW1 = 90.0
let rightColumnW2 = 90.0
let rightColumnW3 = 90.0
let rightColumnW4 = 110.0
let rightColumnW5 = 110.0
let rightColumnW6 = 110.0
let rightColumnW7 = 110.0
let rightColumnW8 = 110.0

protocol PMLinkedChartDataSource: NSObjectProtocol {
    
    func numberOfRowsInChart() -> Int
    func leftTableViewColumnTitle() -> [String]
    func rightTableViewColumnTitle() -> [String]
    func leftTableViewColumnContentWith(indexPath: IndexPath) -> [String]
    func rightTableViewColumnContentWith(indexPath: IndexPath) -> [String]
    func leftTableViewColumnTitleColorWith(indexPath: IndexPath) -> [UIColor]
    func rightTableViewColumnTitleColorWith(indexPath: IndexPath) -> [UIColor]
}

@objc protocol PMLinkedChartDelegate: NSObjectProtocol {
    @objc optional func loadMoreChartData()
    @objc optional func reloadChartData()
}

class PMLinkedChart: UIView {

    weak open var dataSource: PMLinkedChartDataSource?
    weak open var delegate: PMLinkedChartDelegate?
    
    var leftTableView: UITableView!
    var rightScrollView: UIScrollView!
    var rightTableView: UITableView!
    var loadMoreButton: UIButton?
    var activity: UIActivityIndicatorView?
    var transparentImageView: UIImageView!
    var emptyView: UIView?
    
    var oldY: CGFloat = 0.0
    var isDragging = false
    var isLoadMore = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createChart()
    }
    
    func createChart() {
        
        let totalW = rightColumnW1 + rightColumnW2 + rightColumnW3 +
        rightColumnW4 + rightColumnW5 + rightColumnW6
        + rightColumnW7 + rightColumnW8
        
        leftTableView = UITableView(frame: CGRect(
            x: 0,
            y: 0,
            width: leftColumnW1 + leftColumnW2,
            height: height), style: .plain)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.rowHeight = 50
        leftTableView.showsHorizontalScrollIndicator = false
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.separatorStyle = .none
        leftTableView.backgroundColor = .themeBackGround()
        addSubview(leftTableView)
        
        leftTableView.register(cellWithClass: PMLeftChartCell.self)
        
        rightScrollView = UIScrollView(frame: CGRect(x: leftTableView.frame.maxX,
                                                     y: 0,
                                                     width: Configs.screenWidth - leftTableView.width,
                                                     height: leftTableView.height))
        rightScrollView.delegate = self
        rightScrollView.backgroundColor = .white
        rightScrollView.contentSize = CGSize(width: totalW, height: 200)
        rightScrollView.bounces = false
        rightScrollView.showsVerticalScrollIndicator = false
        rightScrollView.showsHorizontalScrollIndicator = false
        addSubview(rightScrollView)
        
        rightTableView = UITableView(frame: CGRect(
            x: 0,
            y: 0,
            width: rightScrollView.contentSize.width,
            height: rightScrollView.height), style: .plain)
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.rowHeight = 50
        rightTableView.showsHorizontalScrollIndicator = false
        rightTableView.showsVerticalScrollIndicator = false
        rightTableView.separatorStyle = .none
        rightTableView.backgroundColor = .themeBackGround()
        rightScrollView.addSubview(rightTableView)
        
        rightTableView.register(cellWithClass: PMRightChartCell.self)
        
        if #available(iOS 15.0, *) {
            self.leftTableView.sectionHeaderTopPadding = 0
            self.rightTableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        transparentImageView = UIImageView(frame: CGRect(
            x: rightScrollView.frame.size.width - 50,
            y: 0,
            width: 50,
            height: 50))
        transparentImageView.image = UIImage(named: "newPriceTransparent.png")
        transparentImageView.alpha = 0.8
        rightScrollView.addSubview(transparentImageView)

        rightScrollView.bringSubviewToFront(transparentImageView)

        let arrowImageView = UIImageView(frame: CGRect(x: 33, y: 20, width: 12, height: 11))
        arrowImageView.image = UIImage(named: "newPriceDoubleRightArrow.png")
        arrowImageView.alpha = 0.8
        transparentImageView.addSubview(arrowImageView)
    }
    
    func setLoadMoreView() {
        
        if loadMoreButton == nil {
            leftTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            rightTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            
            loadMoreButton = UIButton(type: .custom)
            loadMoreButton?.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
            loadMoreButton?.backgroundColor = .clear
            loadMoreButton?.setTitle("点击或者上拉加载更多...", for: .normal)
            loadMoreButton?.setTitleColor(.gray, for: .normal)
            //loadMoreButton?.isHidden = true
            loadMoreButton?.titleLabel?.font = .systemFont(ofSize: 14)
            loadMoreButton?.addTarget(self, action: #selector(loading), for: .touchUpInside)
            addSubview(loadMoreButton!)
            
            activity = UIActivityIndicatorView(style: .medium)
            activity?.hidesWhenStopped = true
            activity?.frame.origin.y = (loadMoreButton?.frame.origin.y ?? 0) + 10
            addSubview(activity!)
            
            updateLoadMoreLocation()
        }
    }
    
    func setEmptyView() {
        
        if emptyView == nil {
            emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 180))
            emptyView?.center = center
            emptyView?.centerY = emptyView!.centerY - 150
            emptyView?.backgroundColor = .clear
            emptyView?.isHidden = true
            addSubview(emptyView!)
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 80, height: 80))
            imageView.image = UIImage(named: "empty_data_error.png")
            emptyView!.addSubview(imageView)
            
            let desLabel = UILabel(frame: CGRect(x: 0,
                                                 y: imageView.frame.maxY + 10,
                                                 width: (emptyView?.frame.size.width)!,
                                                 height: 20))
            desLabel.text = "暂时没有数据~"
            desLabel.font = .systemFont(ofSize: 14)
            desLabel.textColor = .gray
            desLabel.textAlignment = .center
            emptyView!.addSubview(desLabel)
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: desLabel.frame.maxY + 10, width: (emptyView?.frame.size.width)!, height: 40)
            button.setTitle("重新加载", for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(reload), for: .touchUpInside)
            emptyView!.addSubview(button)
        } else {
            emptyView?.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLoadMoreLocation() {
        //loadMoreButton?.isHidden = false
        loadMoreButton?.frame.origin.y = CGFloat(50 * (dataSource?.numberOfRowsInChart() ?? 0) + 50)
        activity?.frame.origin.y = (loadMoreButton?.frame.origin.y ?? 0) + 10
    }
    
    @objc func reload() {
        delegate?.reloadChartData?()
    }
    
    @objc func loading() {
        
        if !isLoadMore {
            isLoadMore = true
            isDragging = true
            loadMoreButton?.setTitle("正在加载更多数据...", for: .normal)
            activity?.center.x = loadMoreButton?.center.x ?? 0
            activity?.centerX -= 80
            activity?.startAnimating()
            delegate?.loadMoreChartData?()
        }
    }
    
    func setEndLoadMore() {
        isLoadMore = false
        loadMoreButton?.setTitle("点击或者上拉加载更多...", for: .normal)
        activity?.stopAnimating()
        
        updateLoadMoreLocation()
    }
    
    func setLoadAllData() {
        
        isLoadMore = true
        activity?.stopAnimating()
        loadMoreButton?.setTitle("全部数据加载完成", for: .normal)
    }
    
    func reloadChartData() {
        
        leftTableView.reloadData()
        rightTableView.reloadData()
        emptyView?.isHidden = (dataSource?.numberOfRowsInChart() ?? 0) > 0 ? true : false

        if (dataSource?.numberOfRowsInChart() ?? 0) == 0 {
            isLoadMore = true
            loadMoreButton?.isHidden = true
        } else {
            loadMoreButton?.isHidden = false
        }
        
        updateLoadMoreLocation()
    }
}

extension PMLinkedChart: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsInChart() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == leftTableView {
            
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? PMLeftChartHeader
            if header == nil {
                header = PMLeftChartHeader(reuseIdentifier: "header")
            }
            
            header?.title1.text = dataSource?.leftTableViewColumnTitle()[0]
            header?.title2.text = dataSource?.leftTableViewColumnTitle()[1]
            
            return header
            
        } else if tableView == rightTableView {
            
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header2") as? PMRightChartHeader
            
            if header == nil {
                header = PMRightChartHeader(reuseIdentifier: "header2")
            }
            
            header?.title1.text = dataSource?.rightTableViewColumnTitle()[0]
            header?.title2.text = dataSource?.rightTableViewColumnTitle()[1]
            header?.title3.text = dataSource?.rightTableViewColumnTitle()[2]
            header?.title4.text = dataSource?.rightTableViewColumnTitle()[3]
            header?.title5.text = dataSource?.rightTableViewColumnTitle()[4]
            header?.title6.text = dataSource?.rightTableViewColumnTitle()[5]
            header?.title7.text = dataSource?.rightTableViewColumnTitle()[6]
            header?.title8.text = dataSource?.rightTableViewColumnTitle()[7]
            
            return header
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == leftTableView {
         
            let cell = tableView.dequeueReusableCell(withClass: PMLeftChartCell.self)!
            
            cell.selectionStyle = .none
        
            cell.title1.text = dataSource?.leftTableViewColumnContentWith(indexPath: indexPath)[0]
            cell.title2.text = dataSource?.leftTableViewColumnContentWith(indexPath: indexPath)[1]
            
            cell.title1.textColor = dataSource?.leftTableViewColumnTitleColorWith(indexPath: indexPath)[0]
            cell.title2.textColor = dataSource?.leftTableViewColumnTitleColorWith(indexPath: indexPath)[1]
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withClass: PMRightChartCell.self)!
            
            cell.selectionStyle = .none

            cell.title1.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[0]
            cell.title2.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[1]
            cell.title3.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[2]
            cell.title4.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[3]
            cell.title5.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[4]
            cell.title6.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[5]
            cell.title7.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[6]
            cell.title8.text = dataSource?.rightTableViewColumnContentWith(indexPath: indexPath)[7]
            
            cell.title1.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[0]
            cell.title2.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[1]
            cell.title3.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[2]
            cell.title4.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[3]
            cell.title5.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[4]
            cell.title6.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[5]
            cell.title7.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[6]
            cell.title8.textColor = dataSource?.rightTableViewColumnTitleColorWith(indexPath: indexPath)[7]
            
            return cell
        }
    }
}

extension PMLinkedChart: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension PMLinkedChart: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == rightTableView {
            leftTableView.contentOffset.y = rightTableView.contentOffset.y
        } else if scrollView == leftTableView {
            rightTableView.contentOffset.y = leftTableView.contentOffset.y
        } else {
            transparentImageView.frame.origin.x = rightScrollView.contentOffset.x + rightScrollView.frame.size.width - 50
        }
        
        if scrollView == rightTableView || scrollView == leftTableView {
            if scrollView.contentOffset.y <= 0 {
                transparentImageView.frame.origin.y = -scrollView.contentOffset.y
            }
            
            loadMoreButton?.frame.origin.y = (rightTableView.contentSize.height -  rightTableView.contentOffset.y)
            activity?.frame.origin.y = (loadMoreButton?.frame.origin.y ?? 0) + 10

            let height = rightTableView.frame.size.height
            let contentYoffset = rightTableView.contentOffset.y
            let distanceFromBottom = rightTableView.contentSize.height - contentYoffset
            
            // 停止滚动
            if !isDragging && loadMoreButton != nil {
                if contentYoffset >= oldY {
                    if distanceFromBottom < height && !isLoadMore {
                        loading()
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == rightTableView || scrollView == leftTableView {
            isDragging = false
            oldY = scrollView.contentOffset.y
        }
    }
}
