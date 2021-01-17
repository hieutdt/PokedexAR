//
//  DictionaryExtension.swift
//  ARFoody
//
//  Created by Trần Đình Tôn Hiếu on 1/15/21.
//

import Foundation

/// Json reader
extension Dictionary where Key == String {
    
    public static func dictionaryFromJsonFile(_ fileName: String) -> [String: Any]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    return jsonResult
                }
                
            } catch {
                // Handle error
                print("[Json parser] data is not json type.")
                return nil
            }
        }
        
        return nil
    }
}

extension Dictionary where Key == String {
    
    /// Safe `string` value getter from Dictionary
    /// - Parameter key: String key for get value.
    /// - Returns: Value type String. Default is "".
    func stringValueForKey(_ key: String) -> String {
        if let value = self[key] as? String {
            return value
        } else {
            return ""
        }
    }
    
    /// Safe `Int` value getter from Dictionary.
    /// - Parameter key: String key for get value.
    /// - Returns: Value type Int. Default is 0.
    func intValueForKey(_ key: String) -> Int {
        if let value = self[key] as? Int {
            return value
        } else {
            return 0
        }
    }
    
    /// Safe `Bool` value getter from Dictionary.
    /// - Parameter key: String key for get value.
    /// - Returns: Value type Bool. Default is false.
    func boolValueForKey(_ key: String) -> Bool {
        if let value = self[key] as? NSNumber {
            return value.boolValue
        } else if let value = self[key] as? NSString {
            return value.boolValue
        } else {
            return false
        }
    }
    
    /// Safe  `Array<String>` value getter from Dictionary.
    /// - Parameter key: String key for get value.
    /// - Returns: Value type [String]. Default is empty array.
    func stringArrayForKey(_ key: String) -> [String] {
        if let value = self[key] as? [String] {
            return value
        } else {
            return []
        }
    }
    
    func dictionaryForKey(_ key: String) -> [String: Any] {
        if let value = self[key] as? [String: Any] {
            return value
        } else {
            return [:]
        }
    }
    
    /// Safe `Array<[String: Any]` value getter from Dictionary.
    /// - Parameter key: String key for get value.
    /// - Returns: Value type array. Default is empty array.
    func dictionaryArrayForKey(_ key: String) -> [[String: Any]] {
        if let value = self[key] as? [[String: Any]] {
            return value
        } else {
            return []
        }
    }
    
    func numberForKey(_ key: String) -> NSNumber {
        if let value = self[key] as? NSNumber {
            return value
        } else {
            return 0;
        }
    }
    
    func JSON() -> String {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted) {
            
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText ?? ""
            
        } else {
            return ""
        }
    }
    
    var jsonRepresentation: String? {
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: self,
            options: [.prettyPrinted]
        ) else {
            return nil
        }
        
        return String(data: jsonData, encoding: .utf8)
    }
    
    func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
}

