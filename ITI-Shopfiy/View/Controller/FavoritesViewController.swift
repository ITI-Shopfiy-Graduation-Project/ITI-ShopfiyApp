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
//    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    private var savedProductsArray = [Products]()
//    var searchArray: [Products]? = []
//    private let favouriteVM = FavouritesVM()
//    private var deletedProductItem : Products?
    //
    var savedProductsArray: [NSManagedObject] = []
    var favoritesProducts: [Products] = []
    var searchArray: [Products] = []
    var currentProduct = Products()
    var managedContext: NSManagedObjectContext!
    var coreDataManager: CoreDataManager?
    //
    private var flag : Bool = true
    var indicator: UIActivityIndicatorView?
    //
    var favoritesVM: FavouritesVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(savedProductsArray.count)
        // Do any additional setup after loading the view.

//        savedProductsArray = coreDataManager?.fetchData(userID: userId ?? -2) ?? []
//        getSavedProducts()
        //
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        view.addSubview(indicator ?? UIActivityIndicatorView() )
        indicator?.startAnimating()
                
        favoritesVM = FavouritesVM()
        viewWillAppear(false)
        //
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
        coreDataManager = CoreDataManager.getInstance()
        let userId = UserDefaultsManager.sharedInstance.getUserID()
//        self.savedProductsArray = coreDataManager?.fetchData(userID: <#T##Int#>)
        favoritesVM?.fetchSavedProducts(userID: userId ?? -1)
        favoritesVM?.bindingFavorites = { () in
            self.renderView()
            self.indicator?.stopAnimating()
        }
        print("favoriteArrayofiti\(favoritesProducts)")
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
        print(savedProductsArray.count)

        return self.favoritesProducts.count
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
        let product = self.favoritesProducts[indexPath.row]
//        cell.productTitle.text = product.title
////        print("productArray\(product)")
//        let productimg = URL(string:product.image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
//        cell.productImageview?.kf.setImage(with:productimg)
        cell.currentProduct = product
        cell.configureCell(product: product)
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product_ID = favoritesProducts[indexPath.row].id
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
}

//MARK: Search
extension FavoritesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        favoritesProducts = []
        if searchText == "" {
            favoritesProducts = searchArray
        }
        for product in searchArray {
            if product.title!.uppercased().contains(searchText.uppercased()){
                favoritesProducts.append(product)
            }
        }
        self.favoritesCollectionView.reloadData()
    }
}

//MARK: Fetch Data
extension FavoritesViewController: FavouriteActionProductScreen {
    func addFavourite(product: Products) {
        
    }
    
    func showAlert(title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            
            let userId = UserDefaultsManager.sharedInstance.getUserID()
            favoritesVM?.deleteProductItemFromFavourites(product_id: product.id ?? -2, userID: userId ?? -2)
//            coreDataManager?.deleteProductFromFavourites(product_id: product.id ?? 0, userID: userId ?? -7)
            self.favoritesCollectionView.reloadData()
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
    func renderView() {
        DispatchQueue.main.async {
//            self.savedProductsArray = self.favoritesVM?.savedResults ?? []
//            self.getSavedProducts()
            self.savedProductsArray = self.favoritesVM?.results ?? []
            self.favoritesProducts = self.favoritesVM?.savedResults ?? []
            self.searchArray = self.favoritesProducts
            self.favoritesCollectionView.reloadData()
        }
    }
    
    
//    func getSavedProducts(){
//        for item in (savedProductsArray)
//        {
//
//            let proudct = Products()
//
//            proudct.id = item.value(forKey:"product_id") as? Int
//            proudct.title = item.value(forKey: "title") as? String
//            proudct.image?.src = item.value(forKey: "src") as? String
//            proudct.variants?.first?.price = item.value(forKey: "price") as? String
//            proudct.user_id = item.value(forKey: "user_id") as? Int
//            self.favoritesProducts.append(proudct)
//            print("AI")
//        }
//    }
    
    
}
