//
//  RealmRoutePath.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 21.06.2022.
//

import CoreLocation
import RealmSwift

class RealmRoutePath: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted(indexed: true) var unixTime: Date
    @Persisted var latitude: Double
    @Persisted var longitude: Double

    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        id = UUID()
        unixTime = Date.now
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}
