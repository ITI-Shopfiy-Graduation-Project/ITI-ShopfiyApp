//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import Kingfisher
import CoreData
import Foundation

class ProductsViewController: UIViewController{
    @IBOutlet weak var like_btn: UIBarButtonItem!
    @IBOutlet weak var cart_btn: UIBarButtonItem!
    
    @IBOutlet weak var productSearchBar: UISearchBar!{
        didSet{
            productSearchBar.delegate = self
        }
    }
    
    @IBOutlet weak var productsCollectionView: UICollectionView!{
        didSet{
            productsCollectionView.dataSource = self
            productsCollectionView.delegate = self
        }
    }
    
    var productsArray: [Products]? = []
    var favoritesArray: [Products]? = []
    var searchArray: [Products]? = []
    var productsVM: ProductsVM?
    var favoritesVM: FavouritesVM?
    //
    var currentProduct = Products()
//    var likedProducts: [NSManagedObject] = []
//    var managedContext: NSManagedObjectContext!
//    var coreDataObject: CoreDataManager?
    //
    var url: String?
    var vendor: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    private var leagueState : Bool = false
    var indicator: UIActivityIndicatorView?
    var dataCaching: IDataCaching = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        view.addSubview(indicator!)
        indicator?.startAnimating()
        
        viewWillAppear(false)
//        coreDataObject = CoreDataManager.getInstance()
//        likedProducts = coreDataObject?.fetchData(userID: UserDefaultsManager.sharedInstance.getUserID() ?? -10) ?? []
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
                
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        coreDataObject = CoreDataManager.getInstance()
//        likedProducts = coreDataObject?.fetchData(userID: UserDefaultsManager.sharedInstance.getUserID() ?? -10) ?? []
        
        favoritesVM = FavouritesVM()
        favoritesVM?.bindingData = { favourites, error in
            if let favourites = favourites {
                self.favoritesArray = favourites
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
        //original
        productsVM = ProductsVM()
        navigationItem.title = vendor
        productsVM?.getProducts(URL: url ?? "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json")
        getProducts()
        checkFavouritesViewController()
        self.productsCollectionView.reloadData()
    }
    
    @IBAction func likesScreen(_ sender: UIBarButtonItem) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(favoritesVC, animated: true)
        }else{
            showLoginAlert(title: "UnAuthorized Action", message: "Please, try to login first")
        }
    }
    
    @IBAction func cartScreen(_ sender: UIBarButtonItem) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
        }else{
            showLoginAlert(title: "UnAuthorized Action", message: "Please, try to login first")
        }
    }
    
}

//MARK: Cell
extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productsArray?.count ?? 20
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    // MARK: Dimensions

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.width/2) - 8, height: (collectionView.frame.height / 3 ) - 15)
    }

    // MARK: Cells

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        cell.productsView = self
        cell.currentProduct = productsArray?[indexPath.row] ?? Products()
        cell.configureCell(product: productsArray?[indexPath.row] ?? Products())
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product_ID = productsArray?[indexPath.row].id
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
}

extension ProductsViewController{
    
    func getProducts(){
        productsVM?.bindingProducts = { result, error in
            if result != nil {
                self.renderView()
                self.indicator?.stopAnimating()
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    
    func renderView() {
        DispatchQueue.main.async {
            self.productsArray = self.productsVM?.productsResults ?? []
            self.searchArray = self.productsVM?.productsResults ?? []
            self.productsCollectionView.reloadData()
        }
    }

    
}

extension ProductsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        productsArray = []
        if searchText == "" {
            productsArray = searchArray
        }
        for product in searchArray ?? [] {
            if product.title!.uppercased().contains(searchText.uppercased()){
                productsArray?.append(product)
            }
        }
        self.productsCollectionView.reloadData()
    }
}


//MARK: Check cell
extension ProductsViewController: FavouriteActionProductScreen{
//    func addFavourite(product: Products) {
//        let userID: Int? = UserDefaultsManager.sharedInstance.getUserID()
//        coreDataObject?.saveData(Product: product, userID: userID ?? -1)
//        print(self.likedProducts.count)
//        showToastMessage(message: "Added !", color: .green)
//    }
    
    func showAlert(title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
//            let userID: Int? = UserDefaultsManager.sharedInstance.getUserID()
//            self.coreDataObject?.deleteProductFromFavourites(product_id: product.id ?? -2, userID: userID ?? -4)
            productsVM?.deleteFavourite(appDelegate: appDelegate, product: product)
            showToastMessage(message: "Removed !", color: .red)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.cancel, handler: { [self] action in
            let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addFavourite(appDelegate: AppDelegate, product: Products) {
        let userID: Int? = UserDefaultsManager.sharedInstance.getUserID()
        productsVM?.addFavourite(userID: userID ?? -2, appDelegate: appDelegate, product: product)
        showToastMessage(message: "Item Liked", color: .green)
    }
    
    func isFavorite(appDelegate: AppDelegate, product: Products) -> Bool {
        return ((productsVM?.isProductsInFavourites(appDelegate: appDelegate, product: product)) == true)
    }
    
    
}

//MARK: Checking
extension ProductsViewController{
    
    //MARK: Check Like & Cart Buttonns
    //Favorites fill !!
    
    func checkFavouritesViewController() {
        if !(self.favoritesArray?.isEmpty ?? false) {
            like_btn?.image = UIImage(systemName: "heart.fill")
            print("yes")
        } else {
            print("No")
        }
    }
    
//    func checkFavouritesViewController(){
//            if products.isEmpty{
//                BarButton.image = UIImage(systemName: "heart")
////                UserDefaultsManager.sharedInstance.setFavorites(Favorites: false)
//                print("No")
//
//            } else {
//                BarButton.image = UIImage(systemName: "heart.fill")
////                UserDefaultsManager.sharedInstance.setFavorites(Favorites: true)
//                print("yes")
//            }
//
//    }
    
    //Cart fill !!
    func checkCartViewController(products: [Products], BarButton: UIBarButtonItem){
        print("To Do")
    }
    
    
}

extension ProductsViewController{
    
    
    func showToastMessage(message: String, color: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 120, y: view.frame.height - 130, width: 260, height: 30))

        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = color
        toastLabel.textColor = .black
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
  
    
    
}

