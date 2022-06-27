//
//  RealmService.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 21.06.2022.
//

import UIKit
import RealmSwift

class RealmService {

    static func save<T:Object>(
        items: [T],
        configuration: Realm.Configuration = .defaultConfiguration,
        update: Realm.UpdatePolicy = .modified) throws {
            let realm = try Realm(configuration: configuration)
//            print(configuration.fileURL ?? "")
            try realm.write {
                realm.add(
                    items,
                    update: update)
            }
        }

    static func load<T:Object>(typeOf: T.Type) throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(T.self)
    }

    static func delete<T: Object>(object: T) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(object)
        }
    }

    static func deleteAll() throws {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}
