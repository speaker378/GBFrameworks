//
//  MapViewController.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 13.06.2022.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func newTrackButtonTap(_ sender: Any) {
        newRoutePath()
        locationManager.startUpdatingLocation()
        realmRoutePathManager.start()
    }

    @IBAction func finishTrackButtonTap(_ sender: Any) {
        locationManager.stopUpdatingLocation()
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

    @IBAction func takeASelfie(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()

        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }

    @IBAction func logoutButtonTap(_ sender: Any) {
        getOut?()
    }

    private let disposeBag = DisposeBag()
    private var beginLocation: CLLocation?
    private let cameraZoom: Float = 17
    private var locationManager = LocationManager.instance
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var marker: GMSMarker?
    private let markerImageView = UIImageView()
    private let realmRoutePathManager = RealmRoutePathManager()
    var getOut: (() -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
        updateLocation()
        configureMarkerImageView()
    }

    private func configureMarkerImageView() {
        markerImageView.contentMode = .scaleToFill
        markerImageView.clipsToBounds = true
        markerImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        markerImageView.layer.cornerRadius = 15
    }

    private func configureMap() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    private func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                self?.realmRoutePathManager.add(coordinate: location.coordinate)
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
                self?.setMarker(location.coordinate)
            }
            .disposed(by: disposeBag)
    }

    private func updateLocation() {
        locationManager.requestLocation()
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

    private func setMarker(_ coordinate: CLLocationCoordinate2D) {
        if marker == nil { marker = GMSMarker(position: coordinate) }
        marker?.position = coordinate
        marker?.iconView = markerImageView
        marker?.map = mapView
    }
}


extension MapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let image = self?.extractImage(from: info) else { return }
            self?.onTakeAndSavePicture(image)
        }
    }

    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }

    private func onTakeAndSavePicture(_ image: UIImage) {
        markerImageView.image = image
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileName = "image.jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let data = image.jpegData(compressionQuality:  1),
               !FileManager.default.fileExists(atPath: fileURL.path) {
                try data.write(to: fileURL)
                print("file saved")
            }
        } catch {
            print("error:", error)
        }
    }
}
