//
//  LoginViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 22/02/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var pagesControl: UIPageControl!
    @IBOutlet weak var adsCollectionView: UICollectionView!{
        didSet{
            adsCollectionView.delegate = self
            adsCollectionView.dataSource = self
        }
    }
    var staticimgs = [UIImage(named: "ad1")!,UIImage(named: "ad2")!,UIImage(named: "ad3")!]
    var timer : Timer?
    var currentCellIndex = 0
    var loginVM: loginProtocol?

    var indicator: UIActivityIndicatorView?

    var cartVM = ShoppingCartViewModel()
    var AllDraftsUrl = "https://55d695e8a36c98166e0ffaaa143489f9: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@ios-q2-new-capital-2022-2023.myshopify.com/admin/api/2023-01/draft_orders.json"
    var cartcount = ShoppingCart()
    override func viewDidLoad() {
        super.viewDidLoad()

        loginVM = LoginVM()
        // Do any additional setup after loading the view.
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        view.addSubview(indicator ?? UIActivityIndicatorView() )
        indicator?.startAnimating()
        
        let nib = UINib(nibName: "AdsCollectionViewCell", bundle: nil)
        adsCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        starttimer()
        pagesControl.numberOfPages  = staticimgs.count
        navigationItem.title = "Shopify App"
        adsCollectionView.reloadData()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipe.direction = .right

        view.addGestureRecognizer(swipe)
        cartVM.cartsUrl = self.AllDraftsUrl
        cartVM.getCart()
        cartVM.bindingCartt = {()in
            self.renderCart()
            
        }
        getCartId()
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func login_btn(_ sender: Any) {
        let userName = username_txt.text ?? ""
        let password = password_txt.text ?? ""
        
        login(userName: userName, password: password)
        
    }
    
    
    @IBAction func signUp_btn(_ sender: Any) {
        let signUpVC = UIStoryboard(name: "SignUpStoryboard", bundle: nil).instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func skip_btn(_ sender: Any) {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController
        UserDefaultsManager.sharedInstance.setUserStatus(userIsLogged: false)
        UserDefaultsManager.sharedInstance.logut()
        navigationController?.pushViewController(homeVC, animated: true)
    }


}

extension LoginViewController{
    
    func login(userName: String, password: String){
        loginVM?.login(userName: userName, password: password, completionHandler: { Customer in
            if Customer != nil {
                self.showToastMessage(message: "Congratulations", color: UIColor(named: "Green") ?? .systemGreen)
                self.indicator?.stopAnimating()
                print("customer logged in successfully")
                //Navigation
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showAlertError(title: "failed to login", message: "please check your Email or Password")
                print("failed to login")
            }
        })
    
    }
    
    func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(Action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToastMessage(message: String, color: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 120, y: view.frame.height - 130, width: 260, height: 30))

        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = color
        toastLabel.textColor = .black
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
}

extension LoginViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return staticimgs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AdsCollectionViewCell
        cell.cellImage.image =  staticimgs[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            self.pagesControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension LoginViewController{
    
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
    
        adsCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pagesControl.currentPage = currentCellIndex
        
        
    }
}
extension LoginViewController {
    func renderCart() {
        DispatchQueue.main.async {
            self.cartcount = self.cartVM.cartResult!
            
           

            
            
        }
        
        
        
        
        
        
        
    }
    
    
}
extension LoginViewController {
    func getCartId()
    {
        
        cartcount.draft_orders?.forEach({ email in
            
            if  email.email ==  UserDefaultsManager.sharedInstance.getUserEmail()!
            {
                UserDefaultsManager.sharedInstance.setUserCart(cartId: email.id)
            }
            
            
            
            
        })}
                                        }

