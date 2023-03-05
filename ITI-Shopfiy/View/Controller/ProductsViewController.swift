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
    private var favoritesVM: FavouritesVM?
    var url: String?
    var vendor: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        productsVM = ProductsVM()
        productsVM?.getProducts(URL: url ?? "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json")
        productsVM?.bindingProducts = { () in
            self.renderView()
            indicator.stopAnimating()
        }
        
//        favoritesArray = favoritesVM?.savedProductsArray
//        favoritesVM?.bindingData = { () in
//            self.favoritesArray = self.favoritesVM?.savedProductsArray ?? []
////            self?.productsCollectionView.reloadData()
//        }
        checkFavouritesViewController(products: favoritesArray ?? [], BarButton: self.like_btn)
        
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
        
        navigationItem.title = vendor
        viewWillAppear(false)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesVM = FavouritesVM()
        let products: [Products] = favoritesVM?.savedProductsArray ?? []
        checkFavouritesViewController(products: products, BarButton: self.like_btn)
        productsCollectionView.reloadData()
    }
    
    @IBAction func likesScreen(_ sender: UIBarButtonItem) {
        if (isLogin() == true) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(favoritesVC, animated: true)
        }else{
            showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
        }
    }
    
    @IBAction func cartScreen(_ sender: UIBarButtonItem) {
        if (isLogin() == true) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
        }else{
            showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
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
        let productimg = URL(string: productsArray?[indexPath.row].image?.src ?? "")
        cell.productImageview.kf.setImage(with: productimg)
        cell.productTitle.text = productsArray?[indexPath.row].title
        cell.isFavourite = favoritesVM?.isFavourite(appDelegate: appDelegate, productID: productsArray?[indexPath.row].id ?? 0)
        cell.product = productsArray?[indexPath.row]
        cell.delegate = self
        
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

//MARK: Checking
extension ProductsViewController: ToAddToLikes{
    
    //MARK: Check cell
    //Check product is liked
    func deleteFromFavourites(id: Int) {
        showAlert(Title: "Remove Item", Message: "Are you sure ?", ProductID: id)
//        favoritesVM?.deleteProductItemFromFavourites(appDeleget: appDelegate, ProductID: id)
    }
    
    func addToFavourite(product: Products) {
        favoritesVM?.saveProduct(appDelegate: appDelegate, product: product)
        showToastMessage(message: "Added", color: .green)
    }
    
    func navTologin() {
        showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
        
    }
    
    func isFavourite(id: Int) -> Bool {
        print("is favourite product: \(id)")
        return (favoritesVM?.isFavourite(appDelegate: appDelegate, productID: id) == true)
    }
    
    func isLogin()->Bool{
        return UserDefaultsManager.sharedInstance.isLoggedIn()
    }


    
    
    //MARK: Check Like & Cart Buttonns
    //Favorites fill !!
    func checkFavouritesViewController(products: [Products], BarButton: UIBarButtonItem){
            if products.isEmpty{
                BarButton.image = UIImage(systemName: "heart")
                UserDefaultsManager.sharedInstance.setFavorites(Favorites: false)
                print("No")
                
            } else {
                BarButton.image = UIImage(systemName: "heart.fill")
                UserDefaultsManager.sharedInstance.setFavorites(Favorites: true)
                print("yes")
            }
        
    }
    
    //Cart fill !!
    func checkCartViewController(products: [Products], BarButton: UIBarButtonItem){
        print("To Do")
    }
    
    
}

extension ProductsViewController{
    
    func showAlert(Title: String, Message: String, ProductID: Int) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            favoritesVM = FavouritesVM()
            favoritesVM?.deleteProductItemFromFavourites(appDeleget: appDelegate, ProductID: ProductID)
            showToastMessage(message: "Removed !", color: .red)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    func showLoginAlert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.cancel, handler: { [self] action in
            let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

