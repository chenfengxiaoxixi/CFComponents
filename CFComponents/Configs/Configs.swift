//
//  Configs.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/17.
//

import UIKit

struct Configs {

    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    static let APPDELEGATE  = UIApplication.shared.delegate as? AppDelegate
    static var AppWindow = UIApplication.shared.windows[0]
    static let navBarWithStatusBarHeight: CGFloat = AppWindow.windowScene?.statusBarManager?
        .statusBarFrame.height ?? 0 > 20 ? 88 : 64
    static let statusBarHeight: CGFloat = AppWindow.windowScene?.statusBarManager?
        .statusBarFrame.height ?? 0
    static let bottomSafeArea: CGFloat = AppWindow.windowScene?.statusBarManager?
        .statusBarFrame.height ?? 0 > 20 ? 34 : 0
}
