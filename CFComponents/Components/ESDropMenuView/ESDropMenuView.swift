//
//  ESDropMenuView.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/5.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

enum DropListStyle: Int {
    case line = 0, grid = 1
}

class ESIndexPath: NSObject {
    
    var column: Int = 0
    var row: Int = 0
    
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
}

@objc protocol ESDropMenuViewDelegate: NSObjectProtocol {
    
    func menuView(_ menuView: ESDropMenuView, didSelectRowAtIndexPath indexPath: ESIndexPath)
    
    @objc optional func menuView(_ menuView: ESDropMenuView, didSelectMenuIndex index: Int, isShow: Bool)
}

@objc protocol ESDropMenuViewDataSource: NSObjectProtocol {

    @objc optional func menuView(_ menuView: ESDropMenuView, getColumnDropListStyle column: Int) -> Int
    
    func menuView(_ menuView: ESDropMenuView, numberOfRowsInColumn column: Int, row: Int) -> Int//每列下拉列表item数量
    func menuView(_ menuView: ESDropMenuView, titleForRowAtIndexPath indexPath: ESIndexPath) -> String//每列下拉列表点击返回的title
    func menuView(_ menuView: ESDropMenuView, titleForColumn column: Int) -> String//每列默认title
}

class ESDropMenuView: UIView {
    
    weak open var delegate: ESDropMenuViewDelegate?
    weak open var dataSource: ESDropMenuViewDataSource? {
        didSet { configColumnUI() } }
    
    let collectionItemCountForRow: Int = 3 //设置下拉列表每排item数量
    var font = UIFont.systemFont(ofSize: 15) //菜单title字体大小
    var cellHeight: Int = 34
    
    var numOfMenu: Int! ///有几列菜单
    var bgColor = UIColor.themeBackGround()
    var selectColor = UIColor.themeBlue()
    var textColor: UIColor?
    var indicatorColor: UIColor?
    var separatorColor: UIColor?
    var tapIndex: Int!
    var currentSelectedMenudIndex: Int!
    var show: Bool!
    var originPoint: CGPoint!
    var backGroundView: UIView!
    var collectionView: UICollectionView!
    var textLayers: [CATextLayer]!
    var indicators: [CAShapeLayer]!
    var bgLayers: [CALayer]!
    var selectIndexArrays: [Int]!
    var collectionWidth: CGFloat!
    
    var listStyle: DropListStyle!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        originPoint = frame.origin
        currentSelectedMenudIndex = -1
        tapIndex = 0
        show = false
        collectionWidth = Configs.screenWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(
            x: origin.x, y: frame.origin.y + frame.size.height,
            width: Configs.screenWidth, height: 0), collectionViewLayout: flowLayout)

        collectionView.register(ESDropCollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuTapped(_:)))
        addGestureRecognizer(tapGesture)

        //background init and tapped
        backGroundView = UIView(frame: CGRect(x: originPoint.x, y: frame.maxY,
                                              width: Configs.screenWidth,
                                              height: Configs.screenHeight - frame.maxY))
        backGroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        backGroundView.isOpaque = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        backGroundView.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configColumnUI() {
        
        let textLayerInterval: CGFloat = frame.size.width / (CGFloat(numOfMenu) * 2)
        let separatorLineInterval: CGFloat = frame.size.width / CGFloat(numOfMenu)
        let bgLayerInterval: CGFloat = frame.size.width / CGFloat(numOfMenu)

        textLayers = Array()
        indicators = Array()
        bgLayers = Array()

        selectIndexArrays = Array()
        
        for i in 0..<numOfMenu {
            //bgLayer
            let bgLayerPosition = CGPoint(x: (CGFloat(i) + 0.5) * bgLayerInterval, y: frame.size.height / 2)
            let bgLayer = createBgLayer(with: bgColor, andPosition: bgLayerPosition)
            if let bgLayer = bgLayer {
                layer.addSublayer(bgLayer)
            }
            if let bgLayer = bgLayer {
                bgLayers.append(bgLayer)
            }
            //title
            let titlePosition = CGPoint(x: CGFloat((i * 2 + 1)) * textLayerInterval, y: frame.size.height / 2)
            let textLayerstring = dataSource?.menuView(self, titleForColumn: i)
            let title = createTextLayer(withNSString: textLayerstring, with: textColor, andPosition: titlePosition)
            if let title = title {
                layer.addSublayer(title)
            }
            if let title = title {
                textLayers.append(title)
            }
            
            //indicator
            let indicator = createIndicator(with: indicatorColor, andPosition: CGPoint(
                x: titlePosition.x + (title?.bounds.size.width ?? 0.0) / 2 + 8,
                y: frame.size.height / 2))
            layer.addSublayer(indicator!)
            indicators.append(indicator!)
        
            //默认每个column选中下标为0
            selectIndexArrays.append(0)
            
            if i != numOfMenu - 1 {
                let separatorPosition = CGPoint(x: CGFloat((i + 1)) * separatorLineInterval, y: frame.size.height / 2)
                let separator = createSeparatorLine(with: self.separatorColor, andPosition: separatorPosition)
                if let separator = separator {
                    layer.addSublayer(separator)
                }
            }
        }
    }
    
    func createBgLayer(with color: UIColor?, andPosition position: CGPoint) -> CALayer? {
        let layer = CALayer()

        layer.position = position
        layer.bounds = CGRect(x: 0, y: 0, width: frame.size.width / CGFloat(numOfMenu), height: frame.size.height - 1)
        layer.backgroundColor = color?.cgColor

        return layer
    }
    
    func createIndicator(with color: UIColor?, andPosition point: CGPoint) -> CAShapeLayer? {
        let layer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 8, y: 0))
        path.addLine(to: CGPoint(x: 4, y: 5))
        path.close()

        layer.path = path.cgPath
        layer.lineWidth = 1.0
        layer.fillColor = color?.cgColor

        let bound = layer.path?.copy(
            strokingWithWidth: layer.lineWidth,
            lineCap: .butt, lineJoin: .miter,
            miterLimit: layer.miterLimit,
            transform: .identity)
        layer.bounds = bound?.boundingBox ?? CGRect.zero

        layer.position = point

        return layer
    }
    
    func createSeparatorLine(with color: UIColor?, andPosition point: CGPoint) -> CAShapeLayer? {
        let layer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 160, y: 0))
        path.addLine(to: CGPoint(x: 160, y: frame.size.height))

        layer.path = path.cgPath
        layer.lineWidth = 1.0
        layer.strokeColor = color?.cgColor

        let bound = layer.path?.copy(
            strokingWithWidth: layer.lineWidth,
            lineCap: .butt, lineJoin: .miter,
            miterLimit: layer.miterLimit,
            transform: .identity)
        layer.bounds = bound?.boundingBox ?? CGRect.zero

        layer.position = point

        return layer
    }
    
    func createTextLayer(withNSString string: String!, with color: UIColor?, andPosition point: CGPoint) -> CATextLayer? {

        let size = calculatetextLayersize(with: string, font: font)

        let layer = CATextLayer()
        let sizeWidth = (size.width < (frame.size.width / CGFloat(numOfMenu)) - 25) ?
            size.width : frame.size.width / CGFloat(numOfMenu) - 25
        layer.bounds = CGRect(x: 0, y: 0, width: sizeWidth, height: size.height)
        layer.string = string
        layer.alignmentMode = .center
        layer.foregroundColor = color?.cgColor

        layer.contentsScale = UIScreen.main.scale

        layer.position = point
        layer.fontSize = font.pointSize

        //    UIFont *font = BOLDSYSTEMFONT(14);
        //    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        //    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
        //    layer.font = fontRef;
        //    layer.fontSize = font.pointSize;
        //    CGFontRelease(fontRef);

        return layer
    }
}
