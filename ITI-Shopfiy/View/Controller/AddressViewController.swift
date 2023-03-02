//
//  AddressViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 22/02/2023.
//

import UIKit
import MapKit
import CoreLocation
import DropDown

class AddressViewController: UIViewController , CLLocationManagerDelegate {
   
    let dropDown = DropDown()
    var addressArray = ["cairo" , "belbias" , "new capital" , "octaber" , "ميدان التحرير"]
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var mabView: MKMapView!
    private var perviousLocation : CLLocation? = nil
    var locationManager = CLLocationManager()
        override func viewDidLoad() {
            super.viewDidLoad()
            mabView.delegate = self
            configureLocation()
            configureAuthority()
            dropDown.anchorView = searchTF
            dropDown.dataSource = addressArray
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)

            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.direction = .bottom
            dropDown.selectionAction = { [unowned self] (index, item) in
                
                self.searchTF.text = addressArray[index]
            }
        }
    
    
    func configureLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // accuracy best is not better for battery
        locationManager.allowsBackgroundLocationUpdates = true
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
        
       
    @IBAction func show3(_ sender: Any) {
        print("1")
        dropDown.show()

    }
    @IBAction func show1(_ sender: Any) {
        dropDown.show()
        print("2")

    }
    @IBAction func show(_ sender: Any) {
        dropDown.show()
        print("3")

    }
    @IBAction func showDropDown(_ sender: Any) {
        dropDown.show()
        print("4")

    }
  
    func zoomToUserLocation(location : CLLocation)
        {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mabView.setRegion(region, animated: true)
        }
    

    @IBAction func search(_ sender: Any) {
        let destination = searchTF.text
        if destination != "" {
            setLocation(destination: destination ?? "")
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
    func setLocation(destination: String)
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

// MARK: - get location info
extension AddressViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newLocation =  CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        if perviousLocation == nil || perviousLocation!.distance(from: newLocation) > 50 {
            if perviousLocation != nil
            {
                print ("Destination \(perviousLocation!.distance(from: newLocation))")
            }
            getLocationInfo(location: newLocation)
        }
    }
    
    
    func getLocationInfo(location : CLLocation)
    {
        perviousLocation = location
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { places , error in
            guard let place = places?.first , error == nil else {return}
            
            print("name \(place.name ?? "no name")")
            print("name \(place.country ?? "no country")")
            print("name \(String(describing: place.location?.coordinate.longitude))")
            print("name \(String(describing: place.location?.coordinate.latitude) )")
            print("name \(place.postalCode ?? "no postal code")")
            print("name \(place.locality ?? "no locality")")
            
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
