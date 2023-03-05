//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class FavoritesViewController: UIViewController, UISearchBarDelegate {

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
    var savedProducts: [Products] = [Products]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favoritesVM: FavouritesVM?
    private var deletedProductItem : Products?
    private var flag : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        getSavedProducts()
        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func goToCartViewController(_ sender: UIBarButtonItem) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    

}

//MARK: Cell
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.savedProducts.count
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
        
        let productimg = URL(string:savedProducts[indexPath.row].image?.src ?? "")
        cell.productImageview.kf.setImage(with: productimg)
        cell.productTitle.text = savedProducts[indexPath.row].title
        cell.isFavourite = favoritesVM?.isFavourite(appDelegate: appDelegate, productID: savedProducts[indexPath.row].id ?? 0)
        cell.product = savedProducts[indexPath.row]
        cell.delegate = self
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product_ID = savedProducts[indexPath.row].id
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
    
    
}

extension FavoritesViewController{
    func getSavedProducts(){
        favoritesVM?.fetchSavedProducts(appDelegate: self.appDelegate)
        self.savedProducts = favoritesVM?.savedProductsArray ?? []
        favoritesVM?.bindingData = {result , error in
            if result != nil {
                self.renderView()
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func renderView(){
        self.savedProducts  = self.favoritesVM?.savedProductsArray ?? []
            DispatchQueue.main.async {
                self.favoritesCollectionView.reloadData()
            }
    }
    
    func deleteLeaueItem(indexPath: IndexPath){
        if (favoritesVM?.error == nil)
        {
            DispatchQueue.main.async { [self] in
                deletedProductItem = self.savedProducts[indexPath.row]
                savedProducts.remove(at: indexPath.row)
                self.favoritesCollectionView.deleteItems(at: [indexPath])
                // savedLeagueTable.reloadData()
                if let name = deletedProductItem?.title
                {
                    let successMsg = "\(String(describing: name)) was unsaved successfully"
                    showToastMessage(message: successMsg, color: .red)
                    DispatchQueue.main.asyncAfter(deadline: .now()+5){
                        if self.flag == true {
                            self.favoritesVM?.deleteProductItemFromFavourites(appDeleget: self.appDelegate, ProductID: self.deletedProductItem?.id ?? 0)
                        }
                    }
                    
                }
            }
        }
            else
            {
                self.showToastMessage(message: favoritesVM?.error?.localizedDescription ?? "", color: .red)
                print(favoritesVM?.error ?? "")
            }
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
    
    
}

extension FavoritesViewController: ToAddToLikes{
    func deleteFromFavourites(id: Int) {
        showAlert(Title: "Remove Item", Message: "Are you sure ?", ProductID: id)
    }
    
    func addToFavourite(product: Products) {
        favoritesVM?.saveProduct(appDelegate: appDelegate, product: product)
        showToastMessage(message: "Added", color: .green)
    }
    
    func navTologin() {
        print("User is logged already")
        
    }
    
    func isFavourite(id: Int) -> Bool {
        print("is favourite product: \(id)")
        return (favoritesVM?.isFavourite(appDelegate: appDelegate, productID: id) == true)
    }
    
    func isLogin()->Bool{
        return UserDefaultsManager.sharedInstance.isLoggedIn()
    }

    
}
