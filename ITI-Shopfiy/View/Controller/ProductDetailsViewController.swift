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
    
    
    @IBOutlet weak var cart_btn: UIButton!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    var currentCellIndex = 0
    var cart : DrafOrder = DrafOrder()
    var cartVM = ShoppingCartViewModel()
    var lineitem = LineItem()
//    var lineitemarr:LineItem = [LineItem]
    var lineItemArray:[LineItem] = []
    @IBOutlet weak var productImagesCollectionView: UICollectionView!{
        didSet{
            productImagesCollectionView.delegate = self
            productImagesCollectionView.dataSource = self
        }
    }
    
    var product: Products?
    var product_ID: Int?
    var ProductImages: [Image]?
    var currentProduct: Products?
    var productDetailsVM: ProductDetailsVM?
    
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
//        lineitem.title = "ADIDAS | CLASSIC BACKPACK"
//        cart.email = "mohamed2323@gmail.com"
//        cart.customer?.email = "mohamed2323@gmail.com"
//        cart.customer?.id = 6868122665241
//        cart.customer?.first_name = "Mohamed"
//        cart.created_at = "2023-03-06T04:06:34-05:00"
//        cart.updated_at = "2023-03-06T04:06:34-05:00"
//        cart.line_items?[0].title = "ADIDAS | CLASSIC BACKPACK"
//        lineitem.product_id = 8117841854745
//        lineItemArray.removeAll()
//        lineItemArray.append(lineitem)
//        self.cart.id = 1110835953945
        self.postCart()
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
    func renderView() {
        DispatchQueue.main.async {
            self.product = self.productDetailsVM?.productsResults
            self.productName.text = self.product?.title
            self.productDescription.text = self.product?.body_html
            self.ProductImages = self.product?.images
            self.product?.id = self.product_ID
            self.productPrice.text = self.product?.variants?[0].price
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
                                          "email": "youseif@gamil.com",
//                                          "taxes_included": false,
//                                          "currency": "Egp",
                                         
//                                          "created_at": "2023-02-13T10:18:48-05:00",
//                                          "updated_at": "2023-02-13T10:18:48-05:00",
//                                          "tax_exempt": false,

                                       
//                                          "name": "#d1",
//                                          "status": "completed",
                                          "line_items" : [
                                            [
//                                              "id": 58237889282329,
//                                              "variant_id": nil,
//                                              "product_id": nil,
                                              "title":  "CONVERSE" ,
//                                              "variant_title": nil,
//                                              "sku": nil,
//                                              "vender" : nil,
                                              "quantity": 6,
//                                              "requires_shipping": true,
//                                              "taxable": true,
//                                              "gift_card": false,
//                                              "fulfillment_service": "manual",
//                                              "grams":567,
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
                                              "price": "100.00",
//                                              "admin_graphql_api_id": "gid://shopify/DraftOrderLineItem/498266019"
                                          
                                           ]
                                          ],
                                        "customer": [
                                        "id":6868102218009
                                                ]
                                         
                                        ]
                                    ]
        let customerCart : ShoppingCart = ShoppingCart()
        customerCart.draft_order = cart
      
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
                print ("this is response\(response?.statusCode)")
                print("address was added successfully")
                
                DispatchQueue.main.async {
                    print("Address Saved")
                }
            }
    }
    
    
}


