//
//  LocationManager.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 25.06.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    static let instance = LocationManager()

    private override init() {
        super.init()
        configureLocationManager()
    }

    let locationManager = CLLocationManager()
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)

    func startUpdatingLocation() { locationManager.startUpdatingLocation() }
    func stopUpdatingLocation() { locationManager.stopUpdatingLocation() }
    func requestLocation() { locationManager.requestLocation() }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { self.location.accept(locations.last)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
