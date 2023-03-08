//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import TTGSnackbar
import CoreData
import Kingfisher

class FavoritesViewController: UIViewController {

    @IBOutlet weak var cart_btn: UIBarButtonItem!
    @IBOutlet weak var favoritesSearchBar: UISearchBar!{
        didSet{
            favoritesSearchBar.delegate = self
        }
    }
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!{
        didSet{
            favoritesCollectionView.dataSource = self
            favoritesCollectionView.delegate = self
        }
    }

    var savedProductsArray: [NSManagedObject]? = []
//    var favoritesProducts: [Products]? = []
//    var searchArray: [Products] = []
    var managedContext: NSManagedObjectContext!
    var coreDataManager: CoreDataManager?
    //
    private var flag : Bool = true
    var indicator: UIActivityIndicatorView?
    //
//    var favoritesVM: FavouritesVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        indicator = UIActivityIndicatorView(style: .large)
//        indicator?.center = view.center
//        view.addSubview(indicator ?? UIActivityIndicatorView() )
//        indicator?.startAnimating()
                
        coreDataManager = CoreDataManager.getInstance()
//        let userId = UserDefaultsManager.sharedInstance.getUserID()
//        savedProductsArray = coreDataManager?.fetchData(userID: userId ?? -4) ?? []
        
        self.favoritesCollectionView.reloadData()
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        favoritesCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
        navigationItem.title = "Favorites"
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userId = UserDefaultsManager.sharedInstance.getUserID()
        savedProductsArray = coreDataManager?.fetchData(userID: userId ?? -4) ?? []
        self.favoritesCollectionView.reloadData()
    }
    
    @IBAction func goToCartViewController(_ sender: UIBarButtonItem) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    

}

//MARK: Cell
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedProductsArray?.count ?? 20
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
        cell.favouritesView = self
        let temp: NSManagedObject = savedProductsArray?[indexPath.row] ?? NSManagedObject()
        cell.productTitle.text = temp.value(forKey: "title") as? String
        cell.productImageview.kf.setImage(with: URL(string: temp.value(forKey: "src") as? String ?? ""))
        let product: Products = Products()
        product.id = temp.value(forKey: "product_id") as? Int
        cell.configureCell(product: product, isInFavouriteScreen: true)
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product_ID = savedProductsArray?[indexPath.row].value(forKey: "product_id") as? Int
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
}

//MARK: Search
extension FavoritesViewController: UISearchBarDelegate{
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        favoritesProducts = []
//        if searchText == "" {
//            favoritesProducts = searchArray
//        }
//        for product in searchArray {
//            if product.title!.uppercased().contains(searchText.uppercased()){
//                favoritesProducts.append(product)
//            }
//        }
//        self.favoritesCollectionView.reloadData()
//    }
}

//MARK: Fetch Data
extension FavoritesViewController: FavoriteActionFavoritesScreen {
    
    func showAlert(title: String, message: String, product: Products){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            
            let userId = UserDefaultsManager.sharedInstance.getUserID()
            self.coreDataManager?.deleteProductFromFavourites(product_id: product.id ?? -3, userID: userId ?? -3)
            self.favoritesCollectionView.reloadData()
            product.state = false
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
    
    
}

extension FavoritesViewController{
//    func renderView() {
//        DispatchQueue.main.async {
//            self.savedProductsArray = self.favoritesVM?.results ?? []
//            self.favoritesProducts = self.favoritesVM?.savedResults ?? []
//            self.searchArray = self.favoritesProducts
//            self.favoritesCollectionView.reloadData()
//        }
//    }
    
    
//    func renderView(userId: Int){
//            self.savedProductsArray = self.coreDataManager?.fetchData(userID: userId) ?? []
//            for item in (self.savedProductsArray ){
//                    let product = Products()
//                    product.id = item.value(forKey:"product_id") as? Int
//                    product.title = item.value(forKey: "title") as? String
//                    product.image?.src = item.value(forKey: "src") as? String
//                    product.variants?.first?.price = item.value(forKey: "price") as? String
//                    product.user_id = item.value(forKey: "user_id") as? Int
//                self.favoritesProducts.append(product)
//                    print(product.title ?? "")
//            }
//    }
    
    
}

