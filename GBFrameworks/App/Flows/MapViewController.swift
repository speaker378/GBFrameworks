//
//  MapViewController.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 13.06.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func newTrackButtonTap(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }

    @IBAction func finishTrackButtonTap(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
    }

    private var beginLocation: CLLocation?
    private let cameraZoom: Float = 17
    private var locationManager: CLLocationManager?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
        updateLocation()
    }

    private func configureMap() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.distanceFilter = 10
    }

    private func updateLocation() {
        locationManager?.requestLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        routePath?.add(location.coordinate)
        route?.path = routePath

        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: cameraZoom)
        guard beginLocation != nil else {
            beginLocation = location
            mapView.animate(to: camera)
            return
        }
        
        if beginLocation!.distance(from: location) > 100.0 {
            beginLocation = location
            mapView.animate(to: camera) }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

