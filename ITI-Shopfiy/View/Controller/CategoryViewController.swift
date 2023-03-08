//
//  CategoryViewController.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 22/02/2023.
//

import UIKit
import Kingfisher
import JJFloatingActionButton
class CategoryViewController: UIViewController {
    
    @IBOutlet weak var AllBtn: UIBarButtonItem!
    @IBOutlet weak var MenCtegory: UIBarButtonItem!
    @IBOutlet weak var WomenCategory: UIBarButtonItem!
    @IBOutlet weak var MainCategory: UIToolbar!
    @IBOutlet weak var kidCategory: UIBarButtonItem!
    @IBOutlet weak var SaleCategory: UIBarButtonItem!
  
    @IBAction func addFavourite(_ sender: UIButton) {
        
       
    
        
        
    }
    let indicator = UIActivityIndicatorView(style: .large)
    let actionButton = JJFloatingActionButton()
    var CategoryModel: CategoryViewModel?
    var product :[Products] = []
    var favourite : Address = Address()
    var FavVM = AddressViewModel()
    
    
    var AllProductsUrl = URLService.allProducts()
    
       
    var id : Int?
    
    @IBAction func cartBtn(_ sender: Any) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
            let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
            navigationController?.pushViewController(cartVC, animated: true)
        }else{
            showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
        }
    }
    @IBAction func favouritesBtn(_ sender: Any) {
        if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
            let FavVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
            navigationController?.pushViewController(FavVC, animated: true)
        }else{
            showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
        }
    }
  
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
  

    @IBAction func searchBtn(_ sender: Any) {
        
//        search button here
        let productsVC = UIStoryboard(name: "ProductsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "products") as! ProductsViewController
        
        switch self.AllProductsUrl {
        case "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/collections/437787230489/products.json":
            productsVC.url = AllProductsUrl
            productsVC.vendor = "Men"
        case "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/collections/437787263257/products.json":
            productsVC.url = AllProductsUrl
            productsVC.vendor = "Women"
        case "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/collections/437787296025/products.json":
            productsVC.url = AllProductsUrl
            productsVC.vendor = "Kids"
        case "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/collections/437787328793/products.json":
            productsVC.url = AllProductsUrl
            productsVC.vendor = "Sale"
        default:
            productsVC.url = AllProductsUrl
            productsVC.vendor = "All Categories"
        }

        
        navigationController?.pushViewController(productsVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        CategoryModel = CategoryViewModel()
        CategoryCollectionView.dataSource = self
        CategoryCollectionView.delegate = self
        CategoryModel?.ProductsUrl = self.AllProductsUrl
        CategoryModel?.getProductsFromCategory()
        CategoryModel?.bindingProducts = {()in
        self.renderProducts()
            self.btn()
         
             
        }
     
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CategoryCollectionView.reloadData()
    }
    
    func renderProducts(){
        DispatchQueue.main.async {
            self.product = self.CategoryModel?.productsResults ?? []
            self.CategoryCollectionView.reloadData()
            self.indicator.stopAnimating()
            if self.product.count == 0 {
            self.CategoryCollectionView.isHidden = true
            }
            else {
                self.CategoryCollectionView.isHidden = false
                
            }
            
            }
     
    }
}
extension CategoryViewController:UICollectionViewDelegate {
    
}
extension CategoryViewController :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product_ID = product[indexPath.row].id
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for:indexPath)as! CategoryCollectionViewCell
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 0
        cell.borderColor = UIColor.clear
        cell.productImage.layer.cornerRadius = 35
        cell.productImage.layer.borderWidth = 0
        cell.productImage.clipsToBounds = false
        cell.productImage.layer.masksToBounds = true
        cell.productImage.layer.backgroundColor = UIColor.white.cgColor
        cell.productImage.layer.shadowColor =  UIColor.gray.cgColor
        cell.productImage.layer.shadowRadius = 100

        
        let productt = self.product [indexPath.row]
        let productimg = URL(string:productt.image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.productImage?.kf.setImage(with:productimg)
        cell.productPrice.text = productt.title
        cell.buttonAction = { sender in
            self.favourite.address2 = String(productt.id!)
            print (productt.id!)
            print ("suiiii")
            self.favourite.customer_id = 6867984711961
            self.postAddress()
            }
        
        return cell
        
    }
    
    
    
}
    
    
    extension CategoryViewController: UICollectionViewDelegateFlowLayout
    
    {
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.view.frame.width*0.45, height: self.view.frame.height*0.32)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 7, left: 12, bottom: 0, right: 12)
            }
        

        

        
    }
extension CategoryViewController {
    func render() {
        CategoryModel?.ProductsUrl = self.AllProductsUrl
        CategoryModel?.getProductsFromCategory()
        CategoryModel?.bindingProducts = {()in
        self.renderProducts()
        
        }
        
    }
    
    
    
}
extension CategoryViewController {
    
    func toolbarBtnClr() {
        AllBtn.tintColor = UIColor.gray
        MenCtegory.tintColor = UIColor.gray
        WomenCategory.tintColor = UIColor.gray
        kidCategory.tintColor = UIColor.gray
        SaleCategory.tintColor = UIColor.gray
        
        
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
extension CategoryViewController {
    @IBAction func allCategory(_ sender: UIBarButtonItem) {
        toolbarBtnClr()
        AllBtn.tintColor = UIColor(named: "Green")
        AllProductsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json?"
      render()
    
    }

@IBAction func MenCategory(_ sender: UIBarButtonItem) {
        toolbarBtnClr()
    AllProductsUrl = URLService.mainCategory(category_ID:437787230489)
        MenCtegory.tintColor = UIColor(named: "Green")
//        AllProductsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=437787230489"
      render()

    }
@IBAction func WomenCategory(_ sender: UIBarButtonItem) {
        toolbarBtnClr()
        WomenCategory.tintColor = UIColor(named: "Green")
    AllProductsUrl = URLService.mainCategory(category_ID: 437787263257)
//        AllProductsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=437787263257"
         render()
    

    }
@IBAction func KidCategory(_ sender: UIBarButtonItem) {
            toolbarBtnClr()
            kidCategory.tintColor = UIColor(named: "Green")
    AllProductsUrl = URLService.mainCategory(category_ID: 437787296025)
//            AllProductsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=437787296025"
             render()
        

        }
@IBAction func SaleCategory(_ sender: UIBarButtonItem) {
                toolbarBtnClr()
    SaleCategory.tintColor = UIColor(named: "Green")
    AllProductsUrl = URLService.mainCategory(category_ID:437787328793)
//                AllProductsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json?collection_id=437787328793"
                 render()
            

            }
    
}
extension CategoryViewController {
    
    func btn ()
    {   actionButton.itemAnimationConfiguration = .circularSlideIn(withRadius: 120)
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: .pi * 3 / 4)
        actionButton.buttonAnimationConfiguration.opening.duration = 0.8
        actionButton.buttonAnimationConfiguration.closing.duration = 0.6
        actionButton.buttonColor = UIColor(named: "Green") ?? .green
        
        actionButton.addItem(title: "", image: UIImage(named: "fb1")?.withRenderingMode(.alwaysTemplate)) { item in
           
            self.AllProductsUrl =  self.AllProductsUrl + "&product_type=SHOES"
            
            self.render()
           
      }
        actionButton.addItem(title: "", image: UIImage(named: "fb2")?.withRenderingMode(.alwaysTemplate)) { item in
            self.AllProductsUrl =  self.AllProductsUrl + "&product_type=T-SHIRTS"
            self.render()
          
        }
        actionButton.addItem(title: "", image: UIImage(named: "fb3")?.withRenderingMode(.alwaysTemplate)) { item in
            self.AllProductsUrl =  self.AllProductsUrl + "&product_type=ACCESSORIES"
            self.render()
       
        }
        
        actionButton.display(inViewController: self)
    
        

    }

    
    
    
    
    
}
extension CategoryViewController {
    func postAddress(){
        let customerAddress : PostAddress = PostAddress()
        customerAddress.customer_address = favourite
        //(customer_address: address)
        self.FavVM.postNewAddress(userAddress: customerAddress) { data, response, error in
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

