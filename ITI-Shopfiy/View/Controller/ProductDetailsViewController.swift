//
//  ProductDetailsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class ProductDetailsViewController: UIViewController{
    
    @IBOutlet weak var cart_btn: UIButton!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var staticimgs = [UIImage(named: "ad1")!,UIImage(named: "ad2")!,UIImage(named: "ad3")!]
    var currentCellIndex = 0
    @IBOutlet weak var productImagesCollectionView: UICollectionView!{
        didSet{
            productImagesCollectionView.delegate = self
            productImagesCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "AdsCollectionViewCell", bundle: nil)
        productImagesCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(movetoindex))
//        swipe.direction = .left
////        productImagesCollectionView.addGestureRecognizer(swipe)
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = currentCellIndex
        pageControl.numberOfPages  = staticimgs.count
        
        let likesScreen = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(goToFavoritesScreen(sender: )))
        likesScreen.tintColor = UIColor(named: "Green")
        
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
    }
    
    @IBAction func addToLikesButton(_ sender: Any) {
    }
    

}


extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return staticimgs.count
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
        
            cell.cellImage.image = staticimgs[indexPath.row]
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}

extension ProductDetailsViewController
{

    @objc func movetoindex () {
        if currentCellIndex < staticimgs.count - 1 {
            currentCellIndex += 1
        }
        else{
            currentCellIndex = 0
        }

        productImagesCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex


    }
    
}
