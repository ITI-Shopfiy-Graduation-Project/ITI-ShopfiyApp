//
//  ProductsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit
import Kingfisher

class ProductsViewController: UIViewController{
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
    
    var productsArray: [Products]?
    var productsVM: ProductsVM?
    var searchArray: [Products]?
    var currentProduct: Products?
    var Brand_ID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        productsVM = ProductsVM()
        productsVM?.getProducts(Brand_ID: Brand_ID ?? "437786837273")
        productsVM?.bindingProducts = { () in
            self.renderView()
            indicator.stopAnimating()
        }
        
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productsCollectionView.reloadData()
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
        
        return productsArray?.count ?? 20
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
        
        let product = self.productsArray?[indexPath.row]
        let productimg = URL(string:product?.image?.src ?? "")
        cell.productImageview.kf.setImage(with: productimg)
        cell.productTitle.text = product?.title
        return cell
    }

    // MARK: Navigation

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetialsVC = self.storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        
        productDetialsVC.product = productsArray?[indexPath.row]
        
        self.navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
}

extension ProductsViewController{
    func renderView() {
        DispatchQueue.main.async {
            self.productsArray = self.productsVM?.productsResults ?? []
            self.searchArray = self.productsVM?.productsResults ?? []
            self.productsCollectionView.reloadData()
        }
    }

    
}

extension ProductsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        productsArray = []
        if searchText == "" {
            productsArray = searchArray
        }
        for product in searchArray ?? [] {
            if product.title!.uppercased().contains(searchText.uppercased()){
                productsArray?.append(product)
            }
        }
        self.productsCollectionView.reloadData()
    }
}
