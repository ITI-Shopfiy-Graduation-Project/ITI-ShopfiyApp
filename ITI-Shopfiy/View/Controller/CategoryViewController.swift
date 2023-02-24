//
//  CategoryViewController.swift
//  ITI-Shopfiy
//
//  Created by Abdallah ismail on 22/02/2023.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        CategoryCollectionView.dataSource = self
        CategoryCollectionView.delegate = self
    }
    

}
extension CategoryViewController:UICollectionViewDelegate {
    
}
//extension CategoryViewController :UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
////
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailcell", for:indexPath)as! DetailsCollectionViewCell
////        let detiliedteam = player [indexPath.row]
////        cell.playerName.text =  detiliedteam.player_name
////        cell.playerAge.text = detiliedteam.player_age
////        cell.playerNumber.text = detiliedteam.player_number
////        cell.playerPostion.text = detiliedteam.player_type
////        cell.layer.borderColor = UIColor.darkGray.cgColor
////         cell.layer.borderWidth = 3.0
////        cell.layer.cornerRadius = 20.0
////
////        let playerimg = URL(string:detiliedteam.player_image ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
////        cell.playerImg.layer.cornerRadius = 50
////        cell.playerImg.layer.borderWidth = 2
////        cell.playerImg.clipsToBounds = false
////        cell.playerImg.layer.masksToBounds = true
////        cell.playerImg?.kf.setImage(with:playerimg)
//        return cell
//    }

    




extension CategoryViewController: UICollectionViewDelegateFlowLayout

{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.48, height: self.view.frame.height*0.32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width*0.1, height: self.view.frame.height*0.1)
    }
    
    
    
}



