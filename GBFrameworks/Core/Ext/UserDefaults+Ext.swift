//
//  UserDefaults+Ext.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 22.06.2022.
//

import Foundation

extension UserDefaults {
    static var isLogin: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
    }
}
