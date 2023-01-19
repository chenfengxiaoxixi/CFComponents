//
//  ESPictureZoomController.swift
//  EasySaleiOS
//
//  Created by cf on 2020/8/10.
//  Copyright © 2020 diligrp. All rights reserved.
//

import UIKit

class ESPictureZoomController: UIViewController {

    private var bgScrolleView: UIScrollView!
    private var imageScrolleView: UIScrollView!
    private var imageViewArray: [UIImageView]!
    private var countLabel: UILabel!
    var selectedIndex: Int = 0
    var imageArray: [Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "查看图片"
        
        view.backgroundColor = .themeBackGround()
        
        bgScrolleView = UIScrollView(frame: CGRect(x: 0,
                                                   y: Configs.navBarWithStatusBarHeight,
                                                 width: view.width,
                                                 height: view.height - Configs.navBarWithStatusBarHeight))
        bgScrolleView.contentSize = CGSize(
            width: bgScrolleView.width * CGFloat(imageArray.count),
            height: bgScrolleView.height)
        bgScrolleView.showsVerticalScrollIndicator = false
        bgScrolleView.showsHorizontalScrollIndicator = false
        bgScrolleView.isPagingEnabled = true
        bgScrolleView.delegate = self
        view.addSubview(bgScrolleView)
        
        let backBarItem = UIBarButtonItem(
            image: UIImage(named: "left_back_icon.png"),
            style: .plain,
            target: self,
            action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backBarItem
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        setImageView()
        setCountLabel()
        setPhotoIndex(index: selectedIndex)
    }
    
    func setImageView() {
        
        imageViewArray = []
        
        for i in 0..<imageArray.count {
            
            let scrolleView = UIScrollView(frame: CGRect(x: bgScrolleView.width * CGFloat(i),
                                                         y: 0,
                                                         width: view.width,
                                                         height: view.height - Configs.navBarWithStatusBarHeight))
            scrolleView.delegate = self
            scrolleView.showsVerticalScrollIndicator = false
            scrolleView.showsHorizontalScrollIndicator = false
            bgScrolleView.addSubview(scrolleView)
            
            let imageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: view.width,
                                                      height: view.width))
            imageView.contentMode = .scaleAspectFit
            
            let object = imageArray[i]
            
            if object is String {
                
                imageView.image = UIImage(named: (object as? String)!)
                
            } else if object is UIImage {

                imageView.image = object as? UIImage
                
            } else if object is URL {
//                imageView.kf.setImage(with: object as? URL,
//                                      placeholder: R.image.icon_placehold_large())
            }
            
            centerShow(scrollview: scrolleView, imageview: imageView)
            scrolleView.addSubview(imageView)
            
            scrolleView.contentSize = CGSize(width: view.width,
                                             height: view.width)
            
            scrolleView.maximumZoomScale = 2
            scrolleView.minimumZoomScale = 1
            
            imageViewArray.append(imageView)
        }
    }
    
    func setCountLabel() {
        
        countLabel = UILabel(frame: CGRect(x: 0,
                                           y: bgScrolleView.height - 20,
                                           width: view.width,
                                           height: 20))
        countLabel.font = .systemFont(ofSize: 16)
        countLabel.textAlignment = .center
        countLabel.textColor = .label
        view.addSubview(countLabel)
    }
    
    func setPhotoIndex(index: Int) {
        
        countLabel.text = String(index + 1) + "/" + String(imageArray.count)
        
        bgScrolleView.setContentOffset(CGPoint(x: index * Int(bgScrolleView.width), y: 0), animated: false)
    }
    
    func showInCurrentVC(controller: UIViewController) {
        
        controller.navigationController?.pushViewController(self, animated: true)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func centerShow(scrollview: UIScrollView, imageview: UIImageView) {

        let offsetX = (scrollview.width > scrollview.contentSize.width) ?
            (scrollview.width - scrollview.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollview.height > scrollview.contentSize.height) ?
            (scrollview.height - scrollview.contentSize.height) * 0.5 : 0.0
        imageview.center = CGPoint(x: scrollview.contentSize.width * 0.5 + offsetX,
                                   y: scrollview.contentSize.height * 0.5 + offsetY)
    }
}

extension ESPictureZoomController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        let index = bgScrolleView.contentOffset.x / bgScrolleView.width

        return imageViewArray[Int(index)]
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let index = bgScrolleView.contentOffset.x / bgScrolleView.width

        centerShow(scrollview: scrollView, imageview: imageViewArray[Int(index)])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index: Int = Int(bgScrolleView.contentOffset.x / bgScrolleView.width)
        
        countLabel.text = String(index + 1) + "/" + String(imageArray.count)
    }
}
