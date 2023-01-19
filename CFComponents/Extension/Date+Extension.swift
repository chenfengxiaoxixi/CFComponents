//
//  Date+Extension.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/18.
//

import Foundation

extension Date {
    /**
     date转string，默认格式为yyyy.MM.dd
    */
    func toString(withFormatter: String = "yyyy.MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = withFormatter
        let date = formatter.string(from: self)
        return date
    }
}
