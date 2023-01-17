//
//  UIColor+Extension.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/17.
//

import UIKit

extension UIColor {
    
    // MARK: - Methods
    // App theme color
    static func themeBackGround() -> UIColor {
        return UIColor(red: 243.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 1)
    }
    
    static func themeBlue() -> UIColor {
        return UIColor(red: 80.0/255.0, green: 126.0/255.0, blue: 237.0/255.0, alpha: 1)
    }
    
    static func themeLightBlue() -> UIColor {
        return UIColor(red: 240.0/255.0, green: 243.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func themeOrange() -> UIColor {
        return UIColor(red: 225.0/255.0, green: 93.0/255.0, blue: 44.0/255.0, alpha: 1)
    }

    static func themeGreen() -> UIColor {
        return UIColor(red: 76.0/255.0, green: 176.0/255.0, blue: 44.0/255.0, alpha: 1)
    }
    
    static func themeLineGray() -> UIColor {
        return UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1)
    }
    
    static func themeVeryLineGray() -> UIColor {
        return UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)
    }
}
