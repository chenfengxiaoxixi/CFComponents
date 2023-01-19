//
//  ESDropMenuProtocolImplement.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/7.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESDropCollectionCell: UICollectionViewCell {

    var title: UILabel!
    var line: UIView!
    
    override init(frame: CGRect) {
            
        super.init(frame: frame)
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        title.font = .systemFont(ofSize: 15)
        title.textAlignment = .center
        title.numberOfLines = 2
        contentView.addSubview(title)
        //print(style)
      
        line = UIView(frame: CGRect(x: 0, y: height - 0.3, width: width, height: 0.3))
        line.backgroundColor = .themeLineGray()
        line.isHidden = true
        contentView.addSubview(line)
    }
        
    func setCellStyle(style: DropListStyle) {
        
        title.frame = CGRect(x: 0, y: 0, width: width, height: height)
        line.frame = CGRect(x: 0, y: height - 0.35, width: width, height: 0.35)
        
        line.isHidden = style == DropListStyle.line ? false : true
        
        if style == DropListStyle.grid {
            layer.cornerRadius = 17
            backgroundColor = .themeBackGround()
        } else {
            layer.cornerRadius = 0
            backgroundColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ESDropMenuView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dataSource?.menuView(self, numberOfRowsInColumn: currentSelectedMenudIndex, row: -1) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ESDropCollectionCell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionCell",
            for: indexPath) as? ESDropCollectionCell)!
        
        cell.title.text = dataSource?.menuView(
            self,
            titleForRowAtIndexPath: ESIndexPath(column: currentSelectedMenudIndex, row: indexPath.row))

        cell.title.font = font
        cell.title.textColor = textColor
        
        cell.setCellStyle(style: listStyle)
        
        if indexPath.row == selectIndexArrays[currentSelectedMenudIndex] {
            cell.title.textColor = selectColor
        }
        return cell
    }
}

extension ESDropMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectIndexArrays[currentSelectedMenudIndex] = indexPath.row

        confiMenu(withSelectRow: indexPath.row)

        delegate?.menuView(self, didSelectRowAtIndexPath: ESIndexPath(column: currentSelectedMenudIndex, row: indexPath.row))

        let title = textLayers[currentSelectedMenudIndex]
    
        let indicator = indicators[currentSelectedMenudIndex]
        indicator.position = CGPoint(x: title.position.x + title.frame.size.width / 2 + 8, y: indicator.position.y)
        
    }
    
    func confiMenu(withSelectRow row: Int) {

        let title = textLayers[currentSelectedMenudIndex]
        title.string = dataSource?.menuView(
            self, titleForRowAtIndexPath:
            ESIndexPath(column: currentSelectedMenudIndex, row: row))

        if show {
            animateIdicator(
                indicators[currentSelectedMenudIndex],
                background: backGroundView,
                title: textLayers[currentSelectedMenudIndex],
                forward: false, complecte: {
                self.show = false
            })
            (bgLayers[currentSelectedMenudIndex]).backgroundColor = bgColor.cgColor
        } else {
            animateTitle(title, show: true, complete: {

            })
            collectionView.reloadData()
        }

        let indicator = indicators[currentSelectedMenudIndex]
        indicator.position = CGPoint(x: (title.position.x + title.frame.size.width) / 2 + 8, y: indicator.position.y)
        
    }
    
}

extension ESDropMenuView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if listStyle == DropListStyle.grid {
            return 10
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if listStyle == DropListStyle.grid {
            return CGSize(width: (Int(collectionWidth) - 61) / collectionItemCountForRow, height: cellHeight)
        }
        return CGSize(width: collectionWidth, height: CGFloat(cellHeight))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if listStyle == DropListStyle.grid {
            return 10
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        if listStyle == DropListStyle.grid {
            return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
