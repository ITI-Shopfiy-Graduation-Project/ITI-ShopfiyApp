//
//  SearchViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {

    @IBOutlet weak var like_btn: UIBarButtonItem!
    @IBOutlet weak var cart_btn: UIBarButtonItem!
    @IBOutlet weak var ProductsSearchBar: UISearchBar!{
        didSet{
            ProductsSearchBar.delegate = self
        }
    }
    @IBOutlet weak var productsCollectionView: UICollectionView!{
        didSet{
            productsCollectionView.delegate = self
            productsCollectionView.dataSource = self
        }
    }
    
    var productsArray: [Products]?
    var searchVM: ProductsSearchVM?
    var searchArray: [Products]?
    var currentProduct: Products?
    var current_URL: String?
    var vendor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        searchVM = ProductsSearchVM()
        searchVM?.getProductsSearch(url: current_URL ?? URLService.allProducts())
        searchVM?.bindingProducts = { () in
            self.renderView()
            indicator.stopAnimating()
        }
        
        let productNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productNib, forCellWithReuseIdentifier: "cell")
        
        navigationItem.title = vendor
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goToFavorites(_ sender: UIBarButtonItem) {
        let favoritesVC = UIStoryboard(name: "FavoritesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "favorites") as! FavoritesViewController
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @IBAction func goToCart(_ sender: UIBarButtonItem) {
        let cartVC = UIStoryboard(name: "CartStoryboard", bundle: nil).instantiateViewController(withIdentifier: "cart") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        let productDetialsVC = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController

        productDetialsVC.product = productsArray?[indexPath.row]
        productDetialsVC.product_ID = productsArray?[indexPath.row].id

        navigationController?.pushViewController(productDetialsVC, animated: true)
    }
    
}

extension SearchViewController{
    func renderView() {
        DispatchQueue.main.async {
            self.productsArray = self.searchVM?.productsResults ?? []
            self.searchArray = self.searchVM?.productsResults ?? []
            self.productsCollectionView.reloadData()
        }
    }

    
}

extension SearchViewController: UISearchBarDelegate{
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

