//
//  HomeViewController.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 20/02/2023.
//

import UIKit
import Foundation
import Kingfisher
class HomeViewController: UIViewController {
    var brandsModel: BrandViewModel?
    var brand :[Brands] = []
    var AllBrandsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/smart_collections.json?since_id=482865238"

    @IBAction func searchBtn(_ sender: Any) {
        let productVC = UIStoryboard(name: "ProductsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "products") as! ProductsViewController
        navigationController?.pushViewController(productVC, animated: true)
       
    }
    @IBAction func cartBtn(_ sender: Any) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func favBtn(_ sender: Any) {
        let FavVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(FavVC, animated: true)
    }
    @IBOutlet weak var pageControl: UIPageControl!
    var staticimgs = [UIImage(named: "ad1")!,UIImage(named: "ad2")!,UIImage(named: "ad3")!]
    var timer : Timer?
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
    var currentCellIndex = 0
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    override func viewDidLoad() {
     
        super.viewDidLoad()
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
        
        
    }
    func renderBrands(){
        DispatchQueue.main.async {
            self.brand = self.brandsModel?.brandsResults ?? []
            self.BrandsCollectionView.reloadData()
           
        
        }
        
    }


}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Code Here
        let productsVC = UIStoryboard(name: "ProductsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "products") as! ProductsViewController
        
        navigationController?.pushViewController(productsVC, animated: true)
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

