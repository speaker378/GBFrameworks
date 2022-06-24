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
        newRoutePath()
        locationManager?.startUpdatingLocation()
        realmRoutePathManager.start()
    }

    @IBAction func finishTrackButtonTap(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        realmRoutePathManager.stop()
    }

    @IBAction func lastTrackButtonTap(_ sender: Any) {
        guard !realmRoutePathManager.isTracking else {
            showAlert("Сначала необходимо остановить слежение", handler: finishTrackButtonTap(_:))
            return
        }

        newRoutePath()

        realmRoutePathManager.loadLastTrack { items in
            items?.forEach {
                let coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                self.routePath?.add(coordinate)
                self.route?.path = self.routePath
            }

            let bounds = GMSCoordinateBounds(path: self.routePath!)
            let position = GMSCameraUpdate.fit(bounds, withPadding: 48)
            self.mapView.animate(with: position)
        }
    }

    @IBAction func logoutButtonTap(_ sender: Any) {
        getOut?()
    }

    private var beginLocation: CLLocation?
    private let cameraZoom: Float = 17
    private var locationManager: CLLocationManager?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private let realmRoutePathManager = RealmRoutePathManager()
    var getOut: (() -> Void)?

    
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

    private func newRoutePath() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
    }

    private func showAlert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        present(alert, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        routePath?.add(location.coordinate)
        route?.path = routePath
        realmRoutePathManager.add(coordinate: location.coordinate)

        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: cameraZoom)
        guard beginLocation != nil else {
            beginLocation = location
            mapView.animate(to: camera)
            return
        }

        if beginLocation!.distance(from: location) > 100.0 {
            beginLocation = location
            mapView.animate(to: camera)
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

