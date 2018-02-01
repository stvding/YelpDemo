//
//  DataSet.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import Foundation

//MARK: - Local database singleton structure
class localDatabase{
    // User dictionary with id-Restaurant pair
    static var restaurants = [String:Restaurant]()
    
    // User dictionary with id-GroceryStore pair
    static var groceryStores = [String:GroceryStore]()
    
    // Lat and long
    static var currentLat: Double?
    static var currentLong: Double?
}
