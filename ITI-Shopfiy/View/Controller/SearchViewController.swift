//
//  SearchViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 27/02/2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var like_btn: UIBarButtonItem!
    @IBOutlet weak var cart_btn: UIBarButtonItem!
    @IBOutlet weak var ProductsSearchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func goToCart(_ sender: UIBarButtonItem) {
    }
    

}
