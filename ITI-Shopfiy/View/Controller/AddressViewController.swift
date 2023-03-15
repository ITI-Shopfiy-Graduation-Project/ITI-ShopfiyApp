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
import TTGSnackbar
import Reachability

class AddressViewController: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var addressHisoryTable: UITableView!
    var addressHistoryArray: [Address]?
    var address : Address = Address()
    let addressVM = AddressViewModel()
    var dropDown = DropDown()
    var addressArray: [String] = []
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var mabView: MKMapView!
    private var perviousLocation : CLLocation? = nil
    private var userAddress : Address?
    var addressDelegate : AddressDelegate?
    private var locationManager = CLLocationManager()
    private var deletedAddress : Address?
    private var addressFlag : Bool = true
    let indicator = UIActivityIndicatorView(style: .large)

        override func viewDidLoad() {
            super.viewDidLoad()
        }
    override func viewWillAppear(_ animated: Bool) {
        addressHistoryArray = []
        mabView.delegate = self
        addressHisoryTable.delegate = self
        addressHisoryTable.dataSource = self
        configureLocation()
        configureAuthority()
        // getAllAddresses()
        getAllHistory()
    }
    
    @IBAction func saveAddress_btn(_ sender: Any) {
        if Reachability.forInternetConnection().isReachable(){
            postAddress()
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
        
    }
    
    func setupDropDown(){
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

  
    func zoomToUserLocation(location : CLLocation)
        {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mabView.setRegion(region, animated: true)
        }
    

    @IBAction func search(_ sender: Any) {
        if Reachability.forInternetConnection().isReachable(){
            let destination = searchTF.text
            if destination != "" {
                setLocation(destination: destination ?? "")
            }
            else{
                showAlert(msg: "error")
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
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
            address.customer_id = UserDefaultsManager.sharedInstance.getUserID()
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

   /* func showAlert(msg: String ) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "close", style: .cancel))
        present(alert , animated: true , completion: nil)
    }
*/
}

extension AddressViewController {
    func getAllHistory(){
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
        self.indicator.startAnimating()
        //self.addressVM.getAllUserAddress(userId: UserDefaultsManager.sharedInstance.getUserID() ?? 0)
        self.addressVM.getAllUserAddress(userId: UserDefaultsManager.sharedInstance.getUserID() ?? 0)
        self.addressVM.bindingAddress = {()in
        self.renderView()
        }
    }
    func renderView(){
        DispatchQueue.main.async {
            self.addressHistoryArray = self.addressVM.addressList ?? []
            self.addressArray.removeAll()
            self.addressHistoryArray?.forEach({ address in
                if address.address2 == nil{
                    let location = "\(address.address1 ?? ""), \(address.city ?? ""), \(address.country ?? "")"
                    self.addressArray.append(location)
                }
            })
            print(self.addressArray)
            self.addressHisoryTable.reloadData()
            self.setupDropDown()
            self.indicator.stopAnimating()
        }
    }
  
    func postAddress(){
        let customerAddress : PostAddress = PostAddress()
        customerAddress.customer_address = address
        //(customer_address: address)
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
            DispatchQueue.main.async { [self] in
                print("address was added successfully")
                viewWillAppear(false)
                let snackbar = TTGSnackbar(message: "address was added successfully!", duration: .middle)
                snackbar.tintColor =  UIColor(named: "Green")
                snackbar.show()
            }
        }
    }
    
    
}

extension AddressViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = "\(addressHistoryArray?[indexPath.row].address1 ?? ""), \(addressHistoryArray?[indexPath.row].city ?? ""), \(addressHistoryArray?[indexPath.row].country ?? "")"
        setLocation(destination: location)
        print ("cell selected")
        setUserAddressInfo(address: addressHistoryArray?[indexPath.row] ?? Address())
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
               self.deleteAddressItem(indexPath: indexPath)
               completionHandler(true)
         }
           let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
               self.navigate(address: self.addressHistoryArray?[indexPath.row] ?? Address())
               completionHandler(true)
         }
           delete.backgroundColor = UIColor(named: "Red")
           edit.backgroundColor = UIColor(named: "Green")
           edit.image = UIImage(systemName: "pencil.circle.fill" )
          delete.image = UIImage(systemName: "trash.fill")
           let configuration = UISwipeActionsConfiguration(actions: [delete,edit])
           return configuration
       }
    
    
}

extension AddressViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressHistoryArray?.count ?? 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for:indexPath) as? AddressHistoryTableViewCell ?? AddressHistoryTableViewCell()
        if addressHistoryArray?[indexPath.row].address2 == nil
        {
            cell.street.text = addressHistoryArray?[indexPath.row].address1
            cell.city.text = addressHistoryArray?[indexPath.row].city
            cell.country.text = addressHistoryArray?[indexPath.row].country
        }
        else {
            cell.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Address History"
    }
    
}

extension AddressViewController  {
    func setUserAddressInfo(address: Address){
            addressDelegate?.getAddressInfo(Address: address)
        }
    
    func navigate (address : Address){
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "addressDetails") as! ViewController
        if !Reachability.forInternetConnection().isReachable(){
            self.showAlert(msg: "Please check your internet connection")
        }else{
            VC.userAddress = address
            VC.flag = true
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
}
extension AddressViewController {
    func deleteAddressItem(indexPath : IndexPath)
    {
        if (indexPath.row > 0)
        {
            deletedAddress = addressHistoryArray?[indexPath.row]
            addressHistoryArray?.remove(at: indexPath.row)
            addressHisoryTable.deleteRows(at: [indexPath], with: .automatic)
            showSnackBar(index: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
                if self.addressFlag == true {
                        self.deleteAddress(addressArray: self.deletedAddress!)
                }
            }
        }
        else
        {
            showAlert(msg: "You can't delete your default address")
        }
    }
    func showSnackBar(index : Int){
        let snackbar = TTGSnackbar(
            message: "address \(String(describing: deletedAddress?.address1)) was deleted successfully",
            duration: .middle,
            actionText: "Undo",
            actionBlock: { (snackbar) in
                print("snack bar Click action!")
                self.addressFlag = false
                if self.addressFlag == false{
                    self.undoDeleting(index: index)
                }
            }
        )
        snackbar.actionTextColor = .red
        //snackbar.borderColor = .clear
        snackbar.backgroundColor = .black
        snackbar.messageTextColor = .white
        snackbar.show()
    }
    
    private func undoDeleting(index: Int){
        if let lineItem = deletedAddress {
            addressHistoryArray?.insert(lineItem, at: index)
            addressHisoryTable.reloadData()
        }
    }
    
    func deleteAddress(addressArray : Address){
        let postAddress: PostAddress = PostAddress()
        postAddress.customer_address = addressArray
       // print("Data \(postAddress.customer_address )")
        self.addressVM.deleteAddress(userAddress: postAddress )
    }
    
}
extension AddressViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
