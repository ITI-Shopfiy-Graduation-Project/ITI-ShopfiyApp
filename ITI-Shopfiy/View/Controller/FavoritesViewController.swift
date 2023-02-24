//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class FavoritesViewController: UIViewController, UISearchBarDelegate {

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

        // Do any additional setup after loading the view.
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        favoritesCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
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
        
        return 10
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
