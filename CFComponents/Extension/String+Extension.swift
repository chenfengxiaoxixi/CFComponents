//
//  String+Extension.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/18.
//

import UIKit

extension String {
    
    /**
     string转date，默认格式为yyyy.MM.dd
     */
    func toDate(withFormatter: String = "yyyy.MM.dd") -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormatter
        guard let date = dateFormatter.date(from: self) else { return Date() }
        
        return date
    }
    
    /**
     string转时间戳，默认格式为yyyy.MM.dd
     */
    func ToTimeInterval(withFormatter: String = "yyyy.MM.dd") -> TimeInterval {
        
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.dateFormat = withFormatter
        
        let date = format.date(from: self)
        
        return date?.timeIntervalSince1970 ?? NSDate().timeIntervalSince1970
    }
    
    /**
     计算字符串宽高
     */
    func sizeWithText(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
}
