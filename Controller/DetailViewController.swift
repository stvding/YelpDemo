//
//  DetailViewController.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: - UIParts
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeLocation: UILabel!
    @IBOutlet weak var storePhone: UILabel!
    @IBOutlet weak var storeRating: UILabel!
    @IBOutlet weak var storeIsOpen: UILabel!
    @IBOutlet weak var storeReviewCount: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    
    var name = ""
    var rating = ""
    var location = ""
    var phone = ""
    var reviewCount = ""
    var isOpen = true
    var imageUrl = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.reservationButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    @objc func openLink(){
        if let storeUrl = URL(string: self.url){
            UIApplication.shared.open(storeUrl, options: [:], completionHandler: nil)
        }
    }
    
    
    func updateUI(){
        self.storeName.text = self.name
        self.storeRating.text = self.rating
        self.storeLocation.text = self.location
        self.storePhone.text = self.phone
        self.storeReviewCount.text = self.reviewCount
        self.storeIsOpen.text = self.isOpen ? "Yes" : "No"
        self.storeImage.image = #imageLiteral(resourceName: "not available")
        if let url = URL(string: imageUrl){
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        if url == URL(string: self.imageUrl) {
                            self.storeImage.image = UIImage(data: imageData)!
                        }
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
