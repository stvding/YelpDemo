//
//  Restaurant.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import Foundation

class Restaurant{
    var id = ""
    var name = ""
    var rating = ""
    var review_count = ""
    var url = ""
    var location = ""
    var display_phone = ""
    var image_url = ""
    var is_closed = true
    
    init(id:String) {
        self.id = id
    }
    
    func setRestaurantDetails(name: String, rating: String, review_count: String, url: String, location: String, display_phone: String, image_url: String, is_closed:Bool){
        self.name = name
        self.rating = rating
        self.review_count = review_count
        self.url = url
        self.location = location
        self.display_phone = display_phone
        self.image_url = image_url
        self.is_closed = is_closed
    }
}
