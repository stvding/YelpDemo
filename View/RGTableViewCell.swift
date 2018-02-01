//
//  RGTableViewCell.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import UIKit

class RGTableViewCell: UITableViewCell {
    //MARK: - UIParts
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    @IBOutlet weak var restaurantLocation: UILabel!
    @IBOutlet weak var restaurantPhone: UILabel!
    
    var name: String?{
        didSet{
            self.restaurantName.text = self.name
        }
    }
    var rating: String?{
        didSet{
            self.restaurantRating.text = self.rating
        }
    }
    var location: String?{
        didSet{
            self.restaurantLocation.text = self.location
        }
    }
    var phone: String?{
        didSet{
            self.restaurantPhone.text = self.phone
        }
    }
    
    var imageUrl: String?{
        didSet{
            self.restaurantImage.image = #imageLiteral(resourceName: "not available")
            if let url = URL(string: imageUrl!){
                DispatchQueue.global(qos: .userInitiated).async {
                    if let imageData = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            if url == URL(string: self.imageUrl!) {
                                self.restaurantImage.image = UIImage(data: imageData)!
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
