//
//  HomeViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 20/02/2023.
//

import UIKit
import Foundation
import Kingfisher
import TTGSnackbar
import Reachability

class HomeViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    var brandsModel: BrandViewModel?
    var discountModel : DiscountViewModel?
    var brand :[Brands] = []
    var discount : [Discount] = []
    var AllBrandsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/smart_collections.json?since_id=482865238"
    var dicountUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com//admin/api/2023-01/price_rules/1377368047897/discount_codes.json"
    let indicator = UIActivityIndicatorView(style: .large)
    
    @IBAction func searchBtn(_ sender: Any) {
        let productsVC = UIStoryboard(name: "ProductsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "products") as! ProductsViewController
      
            productsVC.url = URLService.allProducts()
            productsVC.vendor = "All Products"
            navigationController?.pushViewController(productsVC, animated: true)
      
            self.showAlert(msg: "Please check your internet connection")
      
        
    }
    
    @IBAction func cartBtn(_ sender: Any) {
        if Reachability.forInternetConnection().isReachable(){
            if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
                let cartVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "shoppingCart") as! ShoppingCartViewController
                navigationController?.pushViewController(cartVC, animated: true)
            }else{
                showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
        
    }
    @IBAction func favBtn(_ sender: Any) {
        if reachability.isReachable(){
            if (UserDefaultsManager.sharedInstance.isLoggedIn() == true){
                let FavVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
                navigationController?.pushViewController(FavVC, animated: true)
            }else{
                showLoginAlert(Title: "UnAuthorized Action", Message: "Please, try to login first")
            }
        }else{
            self.showAlert(msg: "Please check your internet connection")
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    var staticimgs = [UIImage(named: "ad1")!,UIImage(named: "ad2")!,UIImage(named: "ad3")!]
    var timer : Timer?
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
    var currentCellIndex = 0
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    var reachability:Reachability!
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        indicator.center = view.center
        view.addSubview(indicator)
        AdsCollectionView.delegate = self
        AdsCollectionView.dataSource = self
        BrandsCollectionView.delegate = self
        BrandsCollectionView.dataSource = self
        let nib = UINib(nibName: "AdsCollectionViewCell", bundle: nil)
        AdsCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        starttimer()
        pageControl.numberOfPages  = staticimgs.count
        brandsModel = BrandViewModel()
        brandsModel?.BrandssUrl = self.AllBrandsUrl
        brandsModel?.getBrands()
        brandsModel?.bindingBrands = {()in
        self.renderBrands()
        }
        discountModel = DiscountViewModel()
        discountModel?.discountUrl = self.dicountUrl
        discountModel?.getDiscount()
        discountModel?.bindingDiscount =
        {()in
        self.renderDiscount()
        }
        
        navigationItem.title = "Shopify App"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultsManager.sharedInstance.isLoggedIn() == false{
            userName.text = "Guest"
        }
        else {
            userName.text = UserDefaultsManager.sharedInstance.getUserName()
        }
    }
   

}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Code Here
        if collectionView == AdsCollectionView {
            if   UIPasteboard.general.string != discount[0].code {
               
                UIPasteboard.general.string = discount[0].code!
                let snackbar = TTGSnackbar(message: "🎉 congratulations you get discount code!", duration: .middle)
                snackbar.tintColor =  UIColor(named: "Green")
                snackbar.show()
            }
            else {
                let snackbar = TTGSnackbar(message: "Already Copied!", duration: .middle)
                snackbar.show()
            }
          
            
            
            
        }
        else
        {
            let productsVC = UIStoryboard(name: "ProductsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "products") as! ProductsViewController
            productsVC.url = URLService.produts(Brand_ID: brand[indexPath.row].id ?? 437786837273)
            productsVC.vendor = brand[indexPath.row].title
            navigationController?.pushViewController(productsVC, animated: true)}
    }
  
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.AdsCollectionView {
            return staticimgs.count
        }
        else {
            
            return brand.count
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.AdsCollectionView {
            return 1
        }
        else {
            return 1
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.AdsCollectionView {
            let cell:AdsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AdsCollectionViewCell
            cell.cellImage.image = staticimgs[indexPath.row]
            
            return cell
        }
        else {
            
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for:indexPath)as! BrandsCollectionViewCell
            cell2.layer.borderColor = UIColor.systemGray.cgColor
            cell2.layer.borderWidth = 3.0
            cell2.layer.cornerRadius = 20.0
            let cellBrnad = self.brand [indexPath.row]
            cell2.brandLbl.text = cellBrnad.title
            let Brandimg = URL(string:cellBrnad.image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
            cell2.brandImg?.kf.setImage(with:Brandimg)
            return cell2
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.AdsCollectionView {
            self.pageControl.currentPage = indexPath.row
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
}

extension HomeViewController:UICollectionViewDelegateFlowLayout
{
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.AdsCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)}
        else { return CGSize(width: collectionView.frame.width*0.5, height: collectionView.frame.height*0.9)
        
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.AdsCollectionView {
            return 0}
        else {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.AdsCollectionView{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)}
        else  {return UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)}
    }
}
extension HomeViewController
{
    func starttimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetoindex), userInfo: nil, repeats: true)
        
        
    }
    @objc func movetoindex () {
        if currentCellIndex < staticimgs.count - 1 {
            currentCellIndex += 1
        }
        else{
            currentCellIndex = 0
        }
    
        AdsCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
        
        
    }

    

}
extension HomeViewController {
    func renderBrands(){
        DispatchQueue.main.async {
            self.brand = self.brandsModel?.brandsResults ?? []
            self.BrandsCollectionView.reloadData()
            self.indicator.stopAnimating()
        
        }
        
    }
    func renderDiscount () {
        
        DispatchQueue.main.async {
            self.discount = self.discountModel?.discoutsResults ?? []
            self.AdsCollectionView.reloadData()
        
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

