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
    var isFav: Bool?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailsVM = ProductDetailsVM()
        self.isFav = self.productDetailsVM?.getProductsInFavourites(appDelegate: self.appDelegate, product: &(self.product!))
        renderView()

        cartVM.cartsUrl = self.AllDraftsUrl
        cartVM.getCart()
        cartVM.bindingCartt = {()in
            self.renderCart()
            
        }
        
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
        productImagesCollectionView.reloadData()
    }
    
    @objc func goToFavoritesScreen(sender: AnyObject) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        
        navigationController?.pushViewController(favoritesVC, animated: true)
        viewWillAppear(false)
    }
    
    @objc func goToCartScreen(sender: AnyObject) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        
        navigationController?.pushViewController(cartVC, animated: true)
        viewWillAppear(false)
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
       
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
                addtoLine = DrafOrder(line_items: lineAppend )
                let draftOrderAppend  : ShoppingCartPut = ShoppingCartPut(draft_order:addtoLine)
                putCart(cartt: draftOrderAppend)
                print ("already used")
           
            }
          
        })
        if addtoLine == nil
                    {
                    self.postCart()
          
        }
        

    }
    
    @IBAction func addToLikesButton(_ sender: Any) {
        if !UserDefaultsManager.sharedInstance.isLoggedIn() {
            self.showLoginAlert(title: "Alert", message: "You must login")
            return
        }
        
        if isFav! {
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
            productDetailsVM!.removeProductFromFavourites(appDelegate: appDelegate, product: product!)
        } else {
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print( UserDefaultsManager.sharedInstance.getUserID()!)
            product?.variants![0].id = UserDefaultsManager.sharedInstance.getUserID()!
            print(  product?.variants![0].id! ?? 20)
            
            productDetailsVM!.addProductToFavourites(appDelegate: appDelegate, product: product!)
        }
        isFav = !isFav!
    }
    
    @IBAction func showReviews(_ sender: UIButton) {
        let reviewVC = self.storyboard!.instantiateViewController(withIdentifier: "review") as! ReviewsViewController
        self.navigationController!.pushViewController(reviewVC, animated: true)
    }
    
    
        @IBAction func addToLikesButton(_ sender: Any) {
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
    func checkIsFavourite() {
        if isFav! {
            like_btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            like_btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
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
    
    func renderView() {
        DispatchQueue.main.async {
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
            
            print ("heree email\(String(describing: self.cartcount.draft_orders?[1].email))")
         
            

            
            
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
