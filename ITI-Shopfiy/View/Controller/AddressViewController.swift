//
//  AddressViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import MapKit
import CoreLocation
class AddressViewController: UIViewController , CLLocationManagerDelegate {
   
    @IBOutlet weak var mabView: MKMapView!
    private var locationManager = CLLocationManager()
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // accuracy best is not better for battery
            locationManager.allowsBackgroundLocationUpdates = true
            configureAuthority()
            
            
        }
        func configureAuthority(){
            DispatchQueue.global().async { [self] in
                if isLocationServiceEnabled()
                {
                    checkAuthorization()
                }
                else {
                    showAlert(msg: "Please enable location service", type: "locationService")
                }
            }
        }
        func isLocationServiceEnabled() -> Bool{
            return CLLocationManager.locationServicesEnabled()
        }

        func checkAuthorization(){
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mabView.showsUserLocation = true
                break
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                mabView.showsUserLocation = true
                break
                
            case .denied:
                showAlert(msg: "Please authorize access to location", type: "authSettings")
                break
            case .restricted:
                showAlert(msg: "Authorization restricted", type: "default")
                break
            default:
                print ("default state of map")
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                print("Location: \(location.coordinate)")
                zoomToUserLocation(location: location)
            }
            locationManager.stopUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mabView.showsUserLocation = true
                break
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                mabView.showsUserLocation = true
                break
                
            case .denied:
                showAlert(msg: "Please authorize access to location", type: "authSettings")
                break
            default:
                print ("default state of map")
            }
        }
        
        func zoomToUserLocation(location : CLLocation)
        {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mabView.setRegion(region, animated: true)
        }
        
        func showAlert(msg: String , type: String) {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .cancel))
            alert.addAction(UIAlertAction(title: "settings", style: .default , handler: { action in
                if type == "locationService"
                {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                else if type == "authSettings" {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }))
        }

    }
