//
//  ProductDetailsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController{
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var productSize: UILabel!
    
    @IBOutlet weak var cart_btn: UIButton!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentCellIndex = 0
    var cart : DrafOrder = DrafOrder()
    var cartVM = ShoppingCartViewModel()
    var lineitem = LineItem()
    var newLineItem : LineItem?
    //    var lineitemarr:LineItem = [LineItem]
    var lineItemArray:[LineItem] = []
    var lineAppend : [LineItem]?
    var addtoLine : DrafOrder?
    var cartcount = ShoppingCart()
    var AllDraftsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders.json"
    @IBOutlet weak var productImagesCollectionView: UICollectionView!{
        didSet{
            productImagesCollectionView.delegate = self
            productImagesCollectionView.dataSource = self
        }
    }
    
    var product: Products?
    var product_ID: Int?
    var ProductImages: [Image]?
    var productDetailsVM: ProductDetailsVM?
    var favoritesVM: FavouritesVM?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        productDetailsVM = ProductDetailsVM()
        productDetailsVM?.getProductDetails(Product_ID: self.product_ID ?? 8117840150809)
        productDetailsVM?.bindingProducts = { () in
            self.renderView()
            indicator.stopAnimating()
        }

        cartVM.cartsUrl = self.AllDraftsUrl
        cartVM.getCart()
        cartVM.bindingCartt = {()in
            self.renderCart()
            
        }
        
        favoritesVM = FavouritesVM()
        viewWillAppear(false)
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "AdsCollectionViewCell", bundle: nil)
        productImagesCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        
        let likesScreen = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(goToFavoritesScreen(sender: )))
        likesScreen.tintColor = UIColor(named: "Red")
        
        let cartScreen = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(goToCartScreen(sender: )))
        cartScreen.tintColor = UIColor(named: "Green")
        navigationItem.rightBarButtonItems = [likesScreen, cartScreen]
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right
        
        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIsFavourite(product: self.product ?? Products(), userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1)
        productImagesCollectionView.reloadData()
    }
    
    @objc func goToFavoritesScreen(sender: AnyObject) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(favoritesVC, animated: true)
        }else{
            showLoginAlert(title: "UnAuthorized Action", message: "Please, try to login first")
        }
    }
    
    @objc func goToCartScreen(sender: AnyObject) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true) {
        let cartVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "shoppingCart") as! ShoppingCartViewController
        navigationController?.pushViewController(cartVC, animated: true)
        }else{
            showLoginAlert(title: "UnAuthorized Action", message: "Please, try to login first")
        }
        viewWillAppear(false)
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
       
        if ( UserDefaultsManager.sharedInstance.isLoggedIn() == true){
            cartcount.draft_orders?.forEach({ email in

                        if  email.email ==  UserDefaultsManager.sharedInstance.getUserEmail()!
                        {     addtoLine = email
                            UserDefaultsManager.sharedInstance.setUserCart(cartId: email.id)
                           lineAppend = email.line_items
                            newLineItem = LineItem()
                            newLineItem?.title = product?.title
                            newLineItem?.price = product?.variants![0].price
                            newLineItem?.sku = product?.image?.src
                            newLineItem?.vendor = product?.vendor
                            newLineItem?.product_id = product?.id
                            newLineItem?.grams = product?.variants![0].inventory_quantity
                            newLineItem?.quantity = 1
                            lineAppend?.append(newLineItem!)
                            var draftOrder = DrafOrder()
                            draftOrder.line_items = lineAppend
                            addtoLine = draftOrder
                            let draftOrderAppend : ShoppingCartPut = ShoppingCartPut(draft_order:addtoLine)
                            putCart(cartt: draftOrderAppend)
                            print ("already used")
                       
                        }
                      
                    })
            if addtoLine == nil
                                {
                                self.postCart()
                      
                    }
        }else{
            showLoginAlert(title: "UnAuthorized Action", message: "You must loginn first")
        }


    }
    
    @IBAction func addToLikesButton(_ sender: Any) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == false ){
            showLoginAlert(title: "UnAuthorized Action",message: "You must login first")
        }else{
            if favoritesVM?.isProductsInFavourites(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -2, appDelegate: appDelegate, product: self.product ?? Products()) == true{
                showAlert(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -2, appDelegate: self.appDelegate, title: "Remove Item", message: "Are you sure ?", product: self.product ?? Products())
            } else {
                favoritesVM?.addFavourite(userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1, appDelegate: appDelegate, product: self.product ?? Products())
                like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                showToastMessage(message: "Added", color: .green)
            }
        }
        
    
    }
    
    @IBAction func showReviews(_ sender: UIButton) {
        let reviewVC = self.storyboard!.instantiateViewController(withIdentifier: "review") as! ReviewsViewController
        self.navigationController!.pushViewController(reviewVC, animated: true)
    }
    
    
}


extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ProductImages?.count ?? 5
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    // MARK: Dimensions

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 0
    }

    // MARK: Cells

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AdsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AdsCollectionViewCell
        
        let productimg = URL(string:ProductImages?[indexPath.row].src ?? "")
        cell.cellImage.kf.setImage(with: productimg)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}

extension ProductDetailsViewController{
    func checkIsFavourite(product: Products, userId: Int) {
        if (favoritesVM?.isProductsInFavourites(userId: userId, appDelegate: appDelegate, product: product) == true) {
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func showAlert(userId: Int, appDelegate: AppDelegate, title: String, message: String, product: Products) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { [self] action in
            favoritesVM?.deleteProductItemFromFavourites(userId: userId, appDeleget: self.appDelegate, ProductID: product.id ?? 0)
            showToastMessage(message: "Removed !", color: .red)
            viewWillAppear(false)
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
    
    func renderView() {
        DispatchQueue.main.async {
            self.product = self.productDetailsVM?.productsResults
            self.productName.text = self.product?.title
            self.productDescription.text = self.product?.body_html
            self.ProductImages = self.product?.images
            self.product?.id = self.product_ID
            self.productPrice.text = self.product?.variants?[0].price
            self.productSize.text = self.product?.variants?[0].option1 ?? "Medium"
            self.productColor.text = self.product?.variants?[0].option2 ?? "White"
            self.pageControl.hidesForSinglePage = true
            self.pageControl.currentPage = self.currentCellIndex
            self.pageControl.numberOfPages  = self.ProductImages?.count ?? 5
            self.checkIsFavourite(product: self.product ?? Products(), userId: UserDefaultsManager.sharedInstance.getUserID() ?? -1)
            self.productImagesCollectionView.reloadData()
        }
    }

}

extension ProductDetailsViewController {
    func postCart(){
        let newdraft  : [String : Any] =  [ "draft_order" :
                                        [
                                          //"id": user_id  ,//
//                                          "note": "rush order",
                                            "email": UserDefaultsManager.sharedInstance.getUserEmail()!,
//                                          "taxes_included": false,
                                            "currency": "Egp",

//                                          "name": "#d1",
//                                          "status": "completed",
                                          "line_items" : [
                                            [
//                                              "id": 58237889282329,
                                                "product_id": (self.product?.id)!,
                                                "title": (self.product?.title)! ,
//                                              "variant_title": nil,
                                                "sku": (product?.image?.src)!,
                                                "vender" : (self.product?.vendor)!,
                                              "quantity": 1,
//                                              "requires_shipping": true,
//                                              "taxable": true,
//                                              "gift_card": false,
//                                              "fulfillment_service": "manual",
                                              "grams":self.product!.variants![0].inventory_quantity!,
//                                              "tax_lines": [            [
//                                                  "rate":0.14,
//                                                  "title":"GST",
//                                                  "price":"28.00"
//                                               ]
//                                              ],
//                                              "applied_discount":,
//                                              "name": nil,
//                                              "properties": [],
//                                              "custom": false,
                                                "price": (self.product?.variants![0].price)!,
//                                              "admin_graphql_api_id": "gid://shopify/DraftOrderLineItem/498266019"
                                          
                                           ]
                                          ],
                                        "customer": [
                                            "id":UserDefaultsManager.sharedInstance.getUserID()
                                                ]
                                         
                                        ]
                                    ]
//        let customerCart : ShoppingCart = ShoppingCart()
//        customerCart.draft_order = cart
      
        //(customer_address: address)
        self.cartVM.postNewCart(userCart:newdraft){ data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        print ("cart Error \n \(error?.localizedDescription ?? "")" )
                    }
                    return
                }
                
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                    DispatchQueue.main.async {
                        print ("cart Response \n \(response ?? HTTPURLResponse())" )

                    }
                    return
                }
            print ("this is response\(String(describing: response?.statusCode))")
                print("address was added successfully")
                
                DispatchQueue.main.async {
                    print("Address Saved")
                }
            }
    }
    
    
}
extension ProductDetailsViewController {
    func renderCart() {
        DispatchQueue.main.async {
            self.cartcount = self.cartVM.cartResult!

        }
        
        
        
        
        
        
        
    }
    
    
}
extension ProductDetailsViewController {
    
    func putCart(cartt:ShoppingCartPut){
   
        self.cartVM.putNewCart(userCart: cartt) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        print ("Address Error \n \(error?.localizedDescription ?? "")" )
                    }
                    return
                }
                
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                    DispatchQueue.main.async {
                        print ("Address Response \n \(response ?? HTTPURLResponse())" )

                    }
                    return
                }
            
                print("address was added successfully")
                
                DispatchQueue.main.async {
                    print("Address Saved")
                }
            }
    }
    
    
    
    
    
    
}
