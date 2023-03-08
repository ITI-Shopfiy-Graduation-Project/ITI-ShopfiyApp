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
    var searchArray: [Products]? = []
    var productsVM: ProductsVM?
    var likedProducts: [NSManagedObject]? = [NSManagedObject]()
    var managedContext: NSManagedObjectContext?
    var coreDataObject: CoreDataManager?
    var url: String?
    var vendor: String?
    var indicator: UIActivityIndicatorView?

//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var dataCaching: IDataCaching = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        view.addSubview(indicator ?? UIActivityIndicatorView() )
        indicator?.startAnimating()
        
        navigationItem.title = vendor
        
        productsVM = ProductsVM()
        coreDataObject = CoreDataManager.getInstance()
        guard let userId = UserDefaultsManager.sharedInstance.getUserID() else {return}
        likedProducts = coreDataObject?.fetchData(userID: userId ) ?? []
        productsVM?.getProducts(URL: url ?? "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json")
        productsVM?.bindingProducts = { () in
            self.renderView()
            self.indicator?.stopAnimating()
        }
        self.productsCollectionView.reloadData()
        
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
        navigationItem.title = vendor
        
        coreDataObject = CoreDataManager.getInstance()
        likedProducts = coreDataObject?.fetchData(userID: UserDefaultsManager.sharedInstance.getUserID() ?? 0) ?? []
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
        let product = self.productsArray?[indexPath.row]
        cell.productTitle.text = product?.title ?? ""
        let productimg = URL(string:product?.image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.productImageview?.kf.setImage(with:productimg)
        cell.productsView = self
        cell.configureCell(product: product ?? Products())
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

//MARK: Check cell
extension ProductsViewController: FavouriteActionProductScreen{
    func addFavourite(product: Products) {
        let userID: Int? = UserDefaultsManager.sharedInstance.getUserID()
        coreDataObject?.saveData(Product: product, userID: userID ?? -4)
        print("productArray\(product)")
        print(self.likedProducts?.count ?? 0)
        showToastMessage(message: "Added !", color: .green)
    }

    
    func showAlert(title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            let userID: Int? = UserDefaultsManager.sharedInstance.getUserID()
            self.coreDataObject?.deleteProductFromFavourites(product_id: product.id ?? -2, userID: userID ?? -4)
            product.state = false
            showToastMessage(message: "Removed !", color: .red)
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
    
    

    
    
}

//MARK: Checking
extension ProductsViewController{
    
    //MARK: Check Like & Cart Buttonns
    //Favorites fill !!
    
    func checkFavouritesViewController() {
        if ((self.likedProducts?.isEmpty) == nil) {
            like_btn?.image = UIImage(systemName: "heart.fill")
            print("there is favorites")
        } else {
            print("No, there is no favorites")
        }
    }
    
    //Cart fill !!
    func checkCartViewController(){
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

