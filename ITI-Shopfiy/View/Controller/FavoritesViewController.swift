//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
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

    var savedProductsArray: [Products]? = []
    var searchArray: [Products] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favoritesViewModel: FavouritesVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        favoritesViewModel = FavouritesVM()
        getSavedFavorites()
        
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
        getSavedFavorites()
        self.favoritesCollectionView.reloadData()
    }
    
    @IBAction func goToCartViewController(_ sender: UIBarButtonItem) {
        let cartVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "shoppingCart") as! ShoppingCartViewController

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
        cell.productTitle.text = savedProductsArray?[indexPath.row].title
        let productimg = URL(string:savedProductsArray?[indexPath.row].image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.productImageview?.kf.setImage(with:productimg)
//        cell.like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        if favoritesViewModel?.isProductsInFavourites(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: savedProductsArray?[indexPath.row] ?? Products()) == true {
            cell.like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            cell.like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.Location = true
        cell.currentProduct = savedProductsArray?[indexPath.row]
        cell.favouritesView = self
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
//        productDetialsVC.product = savedProductsArray?[indexPath.row]
        productDetialsVC.product_ID = savedProductsArray?[indexPath.row].id

        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
}

//MARK: Search
extension FavoritesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        savedProductsArray = []
        if searchText == "" {
            savedProductsArray = searchArray
        }
        for product in searchArray {
            if product.title!.uppercased().contains(searchText.uppercased()){
                savedProductsArray?.append(product)
            }
        }
        self.favoritesCollectionView.reloadData()
    }
}

//MARK: Fetch Data
extension FavoritesViewController: FavoriteActionFavoritesScreen {
    func showAlert(userId: Int, appDelegate: AppDelegate, title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            
            favoritesViewModel?.deleteProductItemFromFavourites(userId: userId, appDeleget: self.appDelegate, ProductID: product.id ?? 0)
            viewWillAppear(false)
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
    
    func getSavedFavorites(){
        favoritesViewModel?.fetchSavedProducts(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: self.appDelegate)
        favoritesViewModel?.bindingData = {result , error in
            if result != nil {
//                self.savedProductsArray = result
                
                DispatchQueue.main.async {
                    self.savedProductsArray = result
                    self.savedProductsArray  = self.favoritesViewModel?.savedProductsArray ?? []
                    self.favoritesCollectionView.reloadData()
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}

