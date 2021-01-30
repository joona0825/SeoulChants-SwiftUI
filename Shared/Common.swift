//
//  Common.swift
//  SeoulChants-SwiftUI
//
//  Created by Alfred Woo on 2021/01/28.
//

import Foundation

class Common {
    
    enum Keys: String {
        case isFirstLaunch
        case pushToken
        case didMapAlertDismissed
        case seasonTicket
        case sortAscending
    }
    
    static func loadUserDefault(forKey key: Keys) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    static func setUserDefault(forKey key: Keys, object: Any?) {
        UserDefaults.standard.set(object, forKey: key.rawValue)
    }
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "M월 d일 (E) a h시 m분"
        df.locale = Locale(identifier: "ko")
        return df
    }()
    
    static func dateString(from date: Date) -> String {
        var str = Common.dateFormatter.string(from: date)
        str = str.replacingOccurrences(of: " 0분", with: "")
        return str
    }
    
}
