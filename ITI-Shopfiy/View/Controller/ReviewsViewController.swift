//
//  ReviewsViewController.swift
//  ITI-Shopfiy
//
//  Created by MESHO on 09/03/2023.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var reviewTable: UITableView!{
        didSet{
            reviewTable.delegate = self
            reviewTable.dataSource = self
        }
    }
    
    let reviewsArray = [Review(image: "neuer", rating: 4.5, review: "I bought it from here, the quality is remarkable", user: "Fady Sameh"), Review(image: "cr7", rating: 4.0, review: "it's well worth the money for thier high quality, I highly recommended", user: "Abdallah Ismail"), Review(image: "zizo", rating: 2.0, review: "I didn't like it", user: "Maamoun")]

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
    }
    
    func registerNibFile() {
        reviewTable.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewTableViewCell
        cell.configureCell(user: reviewsArray[indexPath.row])
        return cell
    }
}
