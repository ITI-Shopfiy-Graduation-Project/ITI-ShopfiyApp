//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class ProductsViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var like_btn: UIBarButtonItem!
    @IBOutlet weak var cart_btn: UIBarButtonItem!
    
    @IBOutlet weak var productSearchBar: UISearchBar!{
        didSet{
            productSearchBar.delegate = self
        }
    }
    
    @IBOutlet weak var productsCollectionView: UICollectionView!{
        didSet{
            productsCollectionView.dataSource = self
            productsCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likesScreen(_ sender: UIBarButtonItem) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @IBAction func cartScreen(_ sender: UIBarButtonItem) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
}

//MARK: Cell
extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = self.storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
    
    
    
}
