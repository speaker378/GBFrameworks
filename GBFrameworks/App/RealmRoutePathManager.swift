//
//  RealmRoutePathManager.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 21.06.2022.
//

import CoreLocation
import RealmSwift

class RealmRoutePathManager {
    private(set) var isTracking: Bool = false
    private var coordinates = [RealmRoutePath]()

    func start() {
        isTracking = true
        coordinates.removeAll()
    }

    func stop() {
        guard isTracking else { return }
        isTracking = false

        DispatchQueue.global(qos: .default).async {
            try? RealmService.deleteAll()
            try? RealmService.save(items: self.coordinates)
        }
    }

    func add(coordinate: CLLocationCoordinate2D) {
        guard isTracking else { return }
        let realmData = RealmRoutePath(coordinate: coordinate)
        coordinates.append(realmData)
    }

    func loadLastTrack(completion: @escaping (Results<RealmRoutePath>?) -> Void) {
        let data = try? RealmService.load(typeOf: RealmRoutePath.self)
        completion(data)
    }
}
