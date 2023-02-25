//
//  CategoryViewController.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 22/02/2023.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBAction func cartBtn(_ sender: Any) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func favouritesBtn(_ sender: Any) {
        let FavVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(FavVC, animated: true)
    }
    var staticimgs = [UIImage(named: "ct1")!,UIImage(named: "ct2")!,UIImage(named: "ct3")!,UIImage(named: "ct4")!,UIImage(named: "ct5")!]
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryCollectionView.dataSource = self
        CategoryCollectionView.delegate = self
    }
    

}
extension CategoryViewController:UICollectionViewDelegate {
    
}
extension CategoryViewController :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for:indexPath)as! CategoryCollectionViewCell
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 0
        cell.borderColor = UIColor.clear
        cell.productImage.layer.cornerRadius = 35
        cell.productImage.layer.borderWidth = 0
        cell.productImage.clipsToBounds = false
        cell.productImage.layer.masksToBounds = true
        cell.productImage.image = staticimgs[indexPath.row]
        
        
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
    
    
    

