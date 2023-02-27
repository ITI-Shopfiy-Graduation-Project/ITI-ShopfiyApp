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
   
    @IBOutlet weak var searchTF: UITextField!
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
        
       
        func zoomToUserLocation(location : CLLocation)
        {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mabView.setRegion(region, animated: true)
        }
    
    
    @IBAction func search(_ sender: Any) {
        let destination = searchTF.text
        if destination != "" {
            searchForDestination(destination: destination ?? "")
        }
        else{
            showAlert(msg: "error")
        }
    }
}

// MARK: - peremssion
extension AddressViewController {
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
}

// MARK: - map setup
extension AddressViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Location: \(location.coordinate)")
            zoomToUserLocation(location: location)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
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
        default:
            print ("default state of map")
        }
    }
}

//MARK: - search
extension AddressViewController {
    func searchForDestination(destination: String)
    {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(destination) { places, error in
            guard let place = places?.first , error == nil else {
                self.showAlert(msg: "error")
                return
            }
            guard  let location = place.location else {
                return
            }
            self.searchTF.text = ""
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            pin.title = "\(place.name ?? destination) "
            pin.subtitle = "\(place.locality ?? destination)"
            self.mabView.addAnnotation(pin)
            self.zoomToUserLocation(location: location)
        }
    }
    
}


// MARK: - Alert
extension AddressViewController{
    func showAlert(msg: String , type: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "close", style: .cancel))
        alert.addAction(UIAlertAction(title: "settings", style: .default , handler: { action in
            if type == "locationService"
            {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
               // UIApplication.shared.open(URL(string: "App-prefs:Privacy&path=LOCATION")!)

            }
            else if type == "authSettings" {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }))
        present(alert , animated: true , completion: nil)

    }

    func showAlert(msg: String ) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "close", style: .cancel))
        present(alert , animated: true , completion: nil)
    }

}
