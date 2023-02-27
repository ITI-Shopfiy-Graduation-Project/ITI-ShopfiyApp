//
//  CategoryViewController.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 22/02/2023.
//

import UIKit
import Kingfisher
class CategoryViewController: UIViewController {
    var CategoryModel: CategoryViewModel?
//    var AllProductsUrl : String?
    var pttt : [Products] = []
    var product :[Products] = []
    
    var AllProductsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/products.json"
   
    @IBAction func cartBtn(_ sender: Any) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func favouritesBtn(_ sender: Any) {
        let FavVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(FavVC, animated: true)
    }
  
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryModel = CategoryViewModel()
        CategoryCollectionView.dataSource = self
        CategoryCollectionView.delegate = self
        CategoryModel?.ProductsUrl = self.AllProductsUrl
        CategoryModel?.getProductsFromCategory()
        CategoryModel?.bindingProducts = {()in
        self.renderProducts()
            
        
        }
        
        
    }
    func renderProducts(){
        DispatchQueue.main.async {
            self.product = self.CategoryModel?.productsResults ?? []
            self.CategoryCollectionView.reloadData()
          
          
     
        }
        
    }
}
extension CategoryViewController:UICollectionViewDelegate {
    
}
extension CategoryViewController :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for:indexPath)as! CategoryCollectionViewCell
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 0
        cell.borderColor = UIColor.clear
        cell.productImage.layer.cornerRadius = 35
        cell.productImage.layer.borderWidth = 0.5
        cell.productImage.clipsToBounds = false
        cell.productImage.layer.masksToBounds = true
        cell.productImage.layer.backgroundColor = UIColor.lightGray.cgColor
        let productt = self.product [indexPath.row]
        let productimg = URL(string:productt.image?.src ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.productImage?.kf.setImage(with:productimg)
        
        
        cell.productPrice.text = productt.variants?[0].price?.appending(" $")
        
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
        
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            return CGSize(width: self.view.frame.width*0.4, height: self.view.frame.height*0.1)
//        }
        
        

        
    }
    
    
    

