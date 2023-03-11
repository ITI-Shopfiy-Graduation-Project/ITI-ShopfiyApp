//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import Kingfisher
import Foundation

class ProductsViewController: UIViewController{
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var like_btn: UIBarButtonItem!
    @IBOutlet weak var cart_btn: UIBarButtonItem!
    
    @IBAction func showSlider(_ sender: Any) {
        
        priceSlider.isHidden = !priceSlider.isHidden
        priceValue.isHidden =  !priceValue.isHidden
//        priceSlider.minimumValue = 0
//        priceSlider.maximumValue = 100
//        "Price: " + String(Int(sender.value))
    }
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
    var searchArray: [Products]? = []
    var likedProducts: [Products]? = []
    var productsVM: ProductsVM?
    var favoritesVM: FavouritesVM?
    var url: String?
    var vendor: String?
    var indicator: UIActivityIndicatorView?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceSlider.isHidden = true
        priceValue.isHidden = true
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        view.addSubview(indicator ?? UIActivityIndicatorView() )
        indicator?.startAnimating()
        
        navigationItem.title = vendor
        
        favoritesVM = FavouritesVM()
        productsVM = ProductsVM()
        productsVM?.getProducts(URL: url ?? "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json")
        productsVM?.bindingProducts = { () in
            self.renderView()
            self.indicator?.stopAnimating()
        }
        
        viewWillAppear(false)
        
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
                
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: View will appear
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = vendor
        self.productsCollectionView.reloadData()
    }
    
    @IBAction func likesScreen(_ sender: UIBarButtonItem) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
            favoritesVC.savedProductsArray = likedProducts
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
        let product = self.productsArray?[indexPath.row]

        cell.productTitle.text = product?.title ?? ""
        let productimg = URL(string:product?.image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.productImageview?.kf.setImage(with:productimg)
        cell.currentProduct = product
        cell.Location = false
        if favoritesVM?.isProductsInFavourites(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: product ?? Products()) == true {
            cell.like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            cell.like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.productsView = self
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

//MARK: Check cell & Alerts
extension ProductsViewController: FavouriteActionProductScreen{
    func addFavourite(userId: Int, appDelegate: AppDelegate, product: Products) {
        favoritesVM?.addFavourite(userId: userId, appDelegate: self.appDelegate, product: product)
        showToastMessage(message: "Added", color: .green)
    }
    
    func isFavorite(userId: Int, appDelegate: AppDelegate, product: Products) -> Bool {
        return favoritesVM?.isProductsInFavourites(userId: userId, appDelegate: self.appDelegate, product: product) ?? false
    }
    
    func showAlert(userId: Int, appDelegate: AppDelegate, title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            favoritesVM?.deleteProductItemFromFavourites(userId: userId, appDeleget: self.appDelegate, ProductID: product.id ?? 0)
            showToastMessage(message: "Removed !", color: .red)
            self.productsCollectionView.reloadData()
            viewWillAppear(false)
        }))
        self.productsCollectionView.reloadData()
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

extension ProductsViewController {
    
    @IBAction func priceActionSlider(_ sender: UISlider) {
                priceSlider.maximumValue = 300
        priceValue.text =  "Price: " + String(Int(sender.value))
        if sender.value < 150 {
            productsArray = searchArray!.filter({ Products in
                Double(Products.variants?[0].price ?? "0")! < Double(sender.value)
                
                
            })}
        if sender.value > 150 {
            productsArray = searchArray!.filter({ Products in
                Double(Products.variants?[0].price ?? "0")! >  Double(sender.value)
                
            })
    }
    self.productsCollectionView.reloadData()

    }
            }

