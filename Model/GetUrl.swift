//
//  GetUrl.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import Foundation


let prefixUrlString = "https://api.yelp.com/v3/businesses/search"
let authHeaders = ["Authorization": "Bearer 3zVRg27yYiiHQn5z0cDNwdb8NOT-Q-DU2vh1JtwWgvmVvozJkwoTf7Eyi0m5HBB9t01dN-qIR1IVNlalprFnhwdVAKK_5VQ5DX93RhAe2HsfpiwYEV2OojlPvmZyWnYx"]

let getRestaurantByCoordinateUrl:(Double, Double)->String = {(lat:Double, long:Double)->String in
    let urlString = prefixUrlString + "?term=restaurant&latitude=\(lat)&longitude=\(long)"
    return urlString
}

let getGroceryByCoordinateUrl:(Double, Double)->String = {(lat:Double, long:Double)->String in
    let urlString = prefixUrlString + "?term=grocery&latitude=\(lat)&longitude=\(long)"
    return urlString
}
