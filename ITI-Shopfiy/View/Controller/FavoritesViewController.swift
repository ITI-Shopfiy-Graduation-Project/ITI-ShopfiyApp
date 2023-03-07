//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import TTGSnackbar
class FavoritesViewController: UIViewController, UISearchBarDelegate {
    var ids : Int?
    var productsIdsArray: [Address]?
    var address : Address = Address()
    let addressVM = AddressViewModel()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var savedProductsArray = [Products]()
    private let favouriteVM = FavouritesVM()
    private var deletedProductItem : Products?
    private var flag : Bool = true
//    \(teams[indexPath.row].team_key ?? 63)
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products/\(ids).json"
        
      
      
          
            
            
            // Do any additional setup after loading the view.
            //        getSavedProducts()
            
            // Do any additional setup after loading the view.
            let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
            favoritesCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
            swipe.direction = .right
            
            view.addGestureRecognizer(swipe)
            
            
            addressVM.getAllUserAddress(userId:6867984711961)
            addressVM.bindingAddress = {()in
                self.renderProuductsId()
                
            }
        }
   
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToCartViewController(_ sender: UIBarButtonItem) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    

}

//MARK: Cell
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
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
//        cell.shadowColor = UIColor(named: "Green")
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let productDetialsVC = self.storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
//        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
    
    
}


extension FavoritesViewController{
    func getSavedProducts(){
        favouriteVM.fetchSavedProducts(appDelegate: self.appDelegate)
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
    
    func deleteProductItem(indexPath: IndexPath){
        if (favouriteVM.error == nil)
        {
            DispatchQueue.main.async { [self] in
                deletedProductItem = self.savedProductsArray[indexPath.row]
                savedProductsArray.remove(at: indexPath.row)
                self.favoritesCollectionView.deleteItems(at: [indexPath])
                // savedLeagueTable.reloadData()
                if let name = deletedProductItem?.title
                {
                    let successMsg = "\(String(describing: name)) was unsaved successfully"
                    showSuccessSnakbar(msg: successMsg, index: indexPath.row)
                    DispatchQueue.main.asyncAfter(deadline: .now()+5){
                        if self.flag == true {
                            self.favouriteVM.deleteProductItemFromFavourites(appDeleget: self.appDelegate, ProductID: self.deletedProductItem?.id ?? -1)
                        }
                    }
                    
                }
            }
        }
            else
            {
                self.showErrorSnakbar(msg: favouriteVM.error?.localizedDescription  ?? "")
                print(favouriteVM.error ?? "")
            }
    }
    
    private func showSuccessSnakbar(msg : String, index: Int ){
        let snackbar = TTGSnackbar(
            message: msg,
            duration: .long,
            actionText: "Undo",
            actionBlock: { (snackbar) in
                print("snack bar Click action!")
                self.flag = false
                if self.flag == false{
                    self.undoDeleting(index: index)
                }
               
            }
        )
        snackbar.actionTextColor = UIColor.blue
        snackbar.backgroundColor = UIColor.black
        snackbar.messageTextColor = UIColor.white
        snackbar.show()
    }
    
    private func undoDeleting(index: Int){
        if let product = deletedProductItem {
            savedProductsArray.insert(product, at: index)
            favoritesCollectionView.reloadData()
        }
    }
    private func showErrorSnakbar(msg: String)
    {
        let snackbar = TTGSnackbar(
            message: msg,
            duration: .middle
            )
        snackbar.backgroundColor = UIColor.red
        snackbar.messageTextColor = UIColor.white
        snackbar.show()
    }
    
    func showAlert(Title: String, Message: String, ProductID: Int) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            self.favouriteVM.deleteProductItemFromFavourites(appDeleget: appDelegate, ProductID: ProductID)
            showErrorSnakbar(msg: "Item Removed")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


//extension FavoritesViewController:FavoriteActionFavoritesScreen {
//    func deleteFavourite(appDelegate: AppDelegate, product: Products) {
//        favouriteVM.deleteProductItemFromFavourites(appDeleget: appDelegate, ProductID: product.id ?? 0)
//        favoritesCollectionView.reloadData()
//    }
//}
extension FavoritesViewController
{
    func renderProuductsId () {
        DispatchQueue.main.async { [self] in
            self.productsIdsArray = self.addressVM.addressList ?? []
            print (productsIdsArray![1].address2)
            
            }

        
        
        
        
        
    }
    
    
    
    
    
}

