//
//  UIView+Extension.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/17.
//

import UIKit

// 坐标相关
extension UIView {
    var x: CGFloat {
        get {
            frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return frame.maxX
        }
        set {
            frame.origin.x = newValue - frame.width
        }
    }

    var y: CGFloat {
        get {
            frame.origin.y
        }

        set {
            frame.origin.y = newValue
        }
    }

    var width: CGFloat {
        get {
            frame.width
        }

        set {
            frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            frame.height
        }

        set {
            frame.size.height = newValue
        }
    }

    var size: CGSize {
        get {
            frame.size
        }

        set {
            frame.size = newValue
        }
    }

    var origin: CGPoint {
        get {
            frame.origin
        }

        set {
            frame.origin = newValue
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }

    var bottom: CGFloat {
        self.frame.origin.y + self.frame.size.height
    }
}
