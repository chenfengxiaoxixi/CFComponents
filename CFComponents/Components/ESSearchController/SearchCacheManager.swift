//
//  UserCacheManager.swift
//  EasySaleiOS
//
//  Created by cf on 2020/6/9.
//  Copyright © 2020 diligrp. All rights reserved.
//

import Foundation

enum PlistPath {
    /// 客户搜索缓存
    case customerCache
}

extension PlistPath {
    var plistName: String {
        switch self {
        case .customerCache:
            return "/Documents/customerCache.plist"
        }
    }
}

class SearchCacheManager {
    
    static func getPlistDataWith(path: PlistPath) -> [String] {
        
        let path = NSHomeDirectory() + path.plistName
        
        let filemanger = FileManager.default
         
        if filemanger.fileExists(atPath: path) {
            
            let datas: [String] = NSArray(contentsOfFile: path) as? [String] ?? [""]
            
            print(datas as Any)
            
            return datas
            
        } else {
            
            let array: [String] = Array()
            
            do {
                let datas = try PropertyListSerialization.data(
                    fromPropertyList: array, format: .xml , options: .zero)
                filemanger.createFile(atPath: path, contents: datas, attributes: nil)
            } catch {
                print("error")
            }
            
            return []
        }
    }
    
    static func savePlist(data: String,with path: PlistPath) {
        
        let path = NSHomeDirectory() + path.plistName
        
        guard var datas: [String] = NSArray(contentsOfFile: path) as? [String] else {
            return
       }
       do {

            datas.append(data)
            datas.removeDuplicates()
        
            do {
                
                let filemanger = FileManager.default
                let array = try PropertyListSerialization.data(
                fromPropertyList: datas, format: .xml , options: .zero)
                filemanger.createFile(atPath: path, contents: array, attributes: nil)
                
            } catch {
                print("error")
            }
        }
    }
    
    static func deletePlistData(at row: Int,with path: PlistPath) {
        
        let path = NSHomeDirectory() + path.plistName
        
        guard var datas: [String] = NSArray.init(contentsOfFile: path) as? [String] else {
            return
       }
       do {
            
            datas.remove(at: row)
        
            do {
                
                let filemanger = FileManager.default
                let array = try PropertyListSerialization.data(
                fromPropertyList: datas, format: .xml , options: .zero)
                filemanger.createFile(atPath: path, contents: array, attributes: nil)
                
            } catch {
                print("error")
            }
        }
    }
    
    static func deletePlistAllData(with path: PlistPath) {
        
        let path = NSHomeDirectory() + path.plistName
        
        guard var datas: [String] = NSArray.init(contentsOfFile: path) as? [String] else {
            return
       }
       do {
            
            datas.removeAll()
        
            do {
                
                let filemanger = FileManager.default
                let array = try PropertyListSerialization.data(
                fromPropertyList: datas, format: .xml , options: .zero)
                filemanger.createFile(atPath: path, contents: array, attributes: nil)
                
            } catch {
                print("error")
            }
        }
    }
}
