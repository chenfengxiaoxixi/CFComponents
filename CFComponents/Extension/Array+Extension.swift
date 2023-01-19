//
//  Array+Extension.swift
//  CFComponents
//
//  Created by 陈峰 on 2023/1/18.
//

import Foundation

extension Array where Element: Hashable {
    /**
    去除重复项
    */
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
