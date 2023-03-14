//
//  ViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 19/02/2023.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var mabView: MKMapView!
    private var perviousLocation : CLLocation? = nil
    var addressDelegate : AddressDelegate?
    var flag = false
    var userAddress : Address = Address()
    private var locationManager = CLLocationManager()
    let indicator = UIActivityIndicatorView(style: .large)
    let addressVM = AddressViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor(named: "Green") ?? .green
        mabView.delegate = self
        configureLocation()
        configureAuthority()
        configureView()
    }
    
    @IBAction func done_btn(_ sender: Any) {
        setUserAddressInfo()
        if flag {
            if UserDefaultsManager.sharedInstance.getUserID() != nil
            {
                putAddress()
            }
        }
        else{
            setUserAddressInfo()
            self.navigationController?.popViewController(animated: true)
            
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
    func configureView(){
       // city.text = userAddress.city
       // street.text = userAddress.address1
        //country.text = userAddress.country
        setLocation(destination: userAddress.address1 ?? "")
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
        let destination = street.text
        if destination != "" {
            setLocation(destination: destination ?? "")
        }
        else{
            showAlert(msg: "enter valid data")
        }
    }
}

    // MARK: - peremssion
    extension ViewController {
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
extension ViewController {
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
    extension ViewController {
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
extension ViewController : MKMapViewDelegate {
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
        geoCoder.reverseGeocodeLocation(location) { [self] places , error in
            guard let place = places?.first , error == nil else {return}

            
            print("name \(place.name ?? "no name")")
            print("name \(place.country ?? "no country")")
            print("name \(String(describing: place.location?.coordinate.longitude))")
            print("name \(String(describing: place.location?.coordinate.latitude) )")
            print("name \(place.postalCode ?? "no postal code")")
            print("name \(place.locality ?? "no locality")")
            city.text = place.locality
            country.text = place.country
            street.text = place.name
           
        }
    }
}
    // MARK: - Alert
extension ViewController{
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
        present(alert , animated: true , completion: nil)
        
    }
}
extension ViewController {
    
    func setUserAddressInfo(){
        let address = getAdress()
        addressDelegate?.getAddressInfo(Address: address)
    }
}
    
extension ViewController {
    func getAdress() -> Address {
        var address : Address = Address()
        address.address1 = street.text
        address.customer_id = UserDefaultsManager.sharedInstance.getUserID()
        address.city = city.text
        address.country = country.text
        address.id = userAddress.id
        return address
    }
    
    func putAddress(){
        let address = getAdress()
        print(address)
        addressVM.updateAddress(address: address) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print ("Address Error \n \(error?.localizedDescription ?? "")" )
                }
                return
            }
            
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                DispatchQueue.main.async {
                    print ("Address Response \n \(response ?? HTTPURLResponse())" )
                    
                }
                return
            }
            print("Editted")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

