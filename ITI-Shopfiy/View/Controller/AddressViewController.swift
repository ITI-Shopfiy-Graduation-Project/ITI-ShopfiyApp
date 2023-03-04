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
    @IBOutlet weak var addressHisoryTable: UITableView!
    var addressHistoryArray: [Address] = [Address()]
    var address : Address = Address()
    let addressVM = AddressViewModel()
    let dropDown = DropDown()
    var addressArray: [String] = []
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var mabView: MKMapView!
    private var perviousLocation : CLLocation? = nil
    private var userAddress : Address?
    var addressDelegate : AddressDelegate?
    private var locationManager = CLLocationManager()
        override func viewDidLoad() {
            super.viewDidLoad()
            mabView.delegate = self
            configureLocation()
            configureAuthority()
           // getAllAddresses()
            renderView()
            dropDown.anchorView = searchTF
            dropDown.dataSource = addressArray
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)

            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.direction = .bottom
            dropDown.selectionAction = { [unowned self] (index, item) in
                
                self.searchTF.text = addressArray[index]
            }
        }
    
    @IBAction func saveAddress_btn(_ sender: Any) {
        postAddress()
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
        geoCoder.reverseGeocodeLocation(location) { [self] places , error in
            guard let place = places?.first , error == nil else {return}
            
            userAddress?.country = place.country
            userAddress?.city = place.locality
            userAddress?.address1 = place.name
            
            print("name \(place.name ?? "no name")")
            print("name \(place.country ?? "no country")")
            print("name \(String(describing: place.location?.coordinate.longitude))")
            print("name \(String(describing: place.location?.coordinate.latitude) )")
            print("name \(place.postalCode ?? "no postal code")")
            print("name \(place.locality ?? "no locality")")
            address.address1 = place.name
            address.customer_id = 6860199723289
            address.city = place.locality
            address.country = place.country
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

extension AddressViewController {
    
    func setUserAddressInfo(){
        addressDelegate?.getAddressInfo(Address: userAddress!)
    }
}

extension AddressViewController {
    func renderView(){
      
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = self.view.center
            self.view.addSubview(indicator)
            indicator.startAnimating()
            self.addressVM.getAllUserAddress(userId:6860199723289)
        DispatchQueue.main.async {
            self.addressHistoryArray = self.addressVM.addressList ?? [Address()]
            self.addressHisoryTable.reloadData()
            indicator.stopAnimating()
        }
    }
  /*  func getAllAddresses(){
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        self.addressVM.getAllUserAddress(userId:6860199723289)
        self.addressVM.bindingAddress = {
            self.renderView()
            indicator.stopAnimating()
        }
    }
    */
    func postAddress(){
        let customerAddress : PostAddress = PostAddress(customer_address: address)
        self.addressVM.postNewAddress(userAddress: customerAddress) { data, response, error in
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
            
                print("address was added successfully")
                
                DispatchQueue.main.async {
                    print("Address Saved")
                }
            }
    }
}

extension AddressViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView : UIView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
}

extension AddressViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressHistoryArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for:indexPath) as? AddressHistoryTableViewCell ?? AddressHistoryTableViewCell()
        addressArray.append(addressHistoryArray[indexPath.row].address1 ?? "")
        cell.street.text = addressHistoryArray[indexPath.row].address1
        cell.city.text = addressHistoryArray[indexPath.row].city
        cell.country.text = addressHistoryArray[indexPath.row].country
    return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Address History"
    }
    
}
