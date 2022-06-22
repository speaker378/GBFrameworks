//
//  RealmUser.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 22.06.2022.
//

import Foundation
import RealmSwift

class RealmUser: Object {
    @Persisted(primaryKey: true) var login: String
    @Persisted var password: String

    convenience init(login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
