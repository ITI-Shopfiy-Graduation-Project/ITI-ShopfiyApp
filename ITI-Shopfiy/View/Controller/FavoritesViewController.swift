//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import TTGSnackbar
import CoreData

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
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var savedProductsArray = [Products]()
    var searchArray: [Products]? = []
    private let favouriteVM = FavouritesVM()
    private var deletedProductItem : Products?
    //
//    var savedProductsArray: [NSManagedObject] = []
//    var currentProduct = Products()
//    var managedContext: NSManagedObjectContext!
//    var coreDataManager: CoreDataManager?
    //
    private var flag : Bool = true
    var indicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(savedProductsArray.count)
        // Do any additional setup after loading the view.
        viewWillAppear(false)
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
        getSavedProducts()
//        self.favoritesCollectionView.reloadData()
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

        return self.savedProductsArray.count
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
        //
//        let item = savedProductsArray[indexPath.row]
//        cell.currentProduct.id = item.value(forKey:"product_id") as? Int
//        cell.currentProduct.title = item.value(forKey: "title") as? String
//        cell.currentProduct.image?.src = item.value(forKey: "src") as? String
//        cell.currentProduct.variants?.first?.price = item.value(forKey: "price") as? String
//        cell.currentProduct.user_id = item.value(forKey: "user_id") as? Int
//        self.currentProduct = cell.currentProduct
        //
        cell.configureCell(product: savedProductsArray[indexPath.row])
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product_ID = savedProductsArray[indexPath.row].id
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
}

//MARK: Search
extension FavoritesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        savedProductsArray = []
        if searchText == "" {
            savedProductsArray = searchArray ?? []
        }
        for product in searchArray ?? [] {
            if product.title!.uppercased().contains(searchText.uppercased()){
                savedProductsArray.append(product)
            }
        }
        self.favoritesCollectionView.reloadData()
    }
}

//MARK: Fetch Data
extension FavoritesViewController{
    
//    func getSavedProducts(){
//        let userId = UserDefaultsManager.sharedInstance.getUserID()
//        coreDataManager = CoreDataManager.getInstance()
//        savedProductsArray = coreDataManager?.fetchData(userID: userId ?? -9) ?? []
//
//        self.favoritesCollectionView.reloadData()
//    }
    
    func getSavedProducts(){
        let userID = UserDefaultsManager.sharedInstance.getUserID() ?? -1
        favouriteVM.fetchSavedProducts(userID: userID, appDelegate: self.appDelegate)
        self.savedProductsArray = favouriteVM.savedProductsArray ?? []
        favouriteVM.bindingData = {result , error in
            if result != nil {
                self.renderView()
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func renderView(){
        self.savedProductsArray  = self.favouriteVM.savedProductsArray ?? []
            DispatchQueue.main.async {
                self.favoritesCollectionView.reloadData()
            }
    }
    
//    func deleteProductItem(indexPath: IndexPath){
//        if (favouriteVM.error == nil)
//        {
//            DispatchQueue.main.async { [self] in
//                deletedProductItem = self.savedProductsArray[indexPath.row]
//                savedProductsArray.remove(at: indexPath.row)
//                self.favoritesCollectionView.deleteItems(at: [indexPath])
//                // savedLeagueTable.reloadData()
//                if let name = deletedProductItem?.title
//                {
//                    let successMsg = "\(String(describing: name)) was unsaved successfully"
//                    showSuccessSnakbar(msg: successMsg, index: indexPath.row)
//                    DispatchQueue.main.asyncAfter(deadline: .now()+5){
//                        if self.flag == true {
//                            self.favouriteVM.deleteProductItemFromFavourites(appDeleget: self.appDelegate, ProductID: self.deletedProductItem?.id ?? -1)
//                        }
//                    }
//
//                }
//            }
//        }
//            else
//            {
//                self.showErrorSnakbar(msg: favouriteVM.error?.localizedDescription  ?? "")
//                print(favouriteVM.error ?? "")
//            }
//    }
    
//    private func showSuccessSnakbar(msg : String, index: Int ){
//        let snackbar = TTGSnackbar(
//            message: msg,
//            duration: .long,
//            actionText: "Undo",
//            actionBlock: { (snackbar) in
//                print("snack bar Click action!")
//                self.flag = false
//                if self.flag == false{
//                    self.undoDeleting(index: index)
//                }
//
//            }
//        )
//        snackbar.actionTextColor = UIColor.blue
//        snackbar.backgroundColor = UIColor.black
//        snackbar.messageTextColor = UIColor.white
//        snackbar.show()
//    }
//
//    private func undoDeleting(index: Int){
//        if let product = deletedProductItem {
//            savedProductsArray.insert(product, at: index)
//            favoritesCollectionView.reloadData()
//        }
//    }
//    private func showErrorSnakbar(msg: String)
//    {
//        let snackbar = TTGSnackbar(
//            message: msg,
//            duration: .middle
//            )
//        snackbar.backgroundColor = UIColor.red
//        snackbar.messageTextColor = UIColor.white
//        snackbar.show()
//    }
    
//    func showAlert(Title: String, Message: String, ProductID: Int) {
//        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
////            self.favouriteVM.deleteProductItemFromFavourites(appDeleget: appDelegate, ProductID: ProductID)
////            showErrorSnakbar(msg: "Item Removed")
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
}

extension FavoritesViewController: FavouriteActionProductScreen {
    func addFavourite(appDelegate: AppDelegate, product: Products) {
//        let userID = UserDefaultsManager.sharedInstance.getUserID() ?? -1
//        favouriteVM.addFavourite(userID: userID, appDelegate: appDelegate, product: product)
    }
    
    func isFavorite(appDelegate: AppDelegate, product: Products) -> Bool {
        favouriteVM.isProductsInFavourites(appDelegate: appDelegate, product: product)
    }
    
    func showAlert(title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            
            let userId = UserDefaultsManager.sharedInstance.getUserID()
//            coreDataManager?.deleteProductFromFavourites(product_id: product.id ?? 0, userID: userId ?? -7)
            favouriteVM.deleteProductItemFromFavourites(appDeleget: appDelegate, ProductID: product.id ?? -1)
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
    
    
//    func addFavourite(appDelegate: AppDelegate, product: Products) {
////        favouriteVM.addFavourite(userID: Int, appDelegate: appDelegate, product: product)
//    }
    
//    func isFavorite(appDelegate: AppDelegate, product: Products) -> Bool {
////        favouriteVM.isProductsInFavourites(appDelegate: appDelegate, product: product)
//        return true
//    }

}
