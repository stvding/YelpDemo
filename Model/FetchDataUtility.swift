//
//  FetchDataUtility.swift
//  
//
//  Created by stvding on 2018/1/31.
//

import Foundation
import Alamofire
import SwiftyJSON

class fetchDataUtility {
    //MARK: - Fetch Restaurant list
    class func fetchRestaurantListByUrl(url: String, completion:@escaping (_ isSucceed:Bool, _ restaurantIds:[String]) -> Void){
        var isSucceed = false
        var restaurantIds = [String]()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(url, method: .get, headers: authHeaders).validate().responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            switch response.result {
            case .success(let value):
                let jsonResult = JSON(value)
                let data = jsonResult["businesses"].arrayValue
                for r in data {
                    if let id = archiveRestaurantData(data: r) {
                        restaurantIds.append(id)
                    }
                }
                
                isSucceed = true
            case .failure(let error as AFError):
                isSucceed = false
                switch error {
                case .responseValidationFailed(reason: let reason):
                    switch reason {
                    case .unacceptableStatusCode(code: _):
                        let jsonResult = JSON(response.data!)
                        print(jsonResult)
                    default:
                        break
                    }
                default:
                    break
                }
            default:
                break
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(isSucceed, restaurantIds)
            }
        }
    }
    
    //MARK: - Fetch Grocery Store list
    class func fetchGroceryStoreListByUrl(url: String, completion:@escaping (_ isSucceed:Bool, _ groceryStoreIds:[String]) -> Void){
        var isSucceed = false
        var groceryStoreIds = [String]()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(url, method: .get, headers: authHeaders).validate().responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            switch response.result {
            case .success(let value):
                let jsonResult = JSON(value)
                let data = jsonResult["businesses"].arrayValue
                for g in data {
                    if let id = archiveGroceryStoreData(data: g) {
                        groceryStoreIds.append(id)
                    }
                }
                
                isSucceed = true
            case .failure(let error as AFError):
                isSucceed = false
                switch error {
                case .responseValidationFailed(reason: let reason):
                    switch reason {
                    case .unacceptableStatusCode(code: _):
                        let jsonResult = JSON(response.data!)
                        print(jsonResult)
                    default:
                        break
                    }
                default:
                    break
                }
            default:
                break
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(isSucceed, groceryStoreIds)
            }
        }
    }
    
//MARK: - Helper Functions
    // Archive restaurant data. save restaurant data to local database, and return the restaurant id
    private class func archiveRestaurantData(data:JSON)->String? {
        let id = data["id"].stringValue
        let name = data["name"].stringValue
        let rating = data["rating"].stringValue
        let review_count = data["review_count"].stringValue
        let url = data["url"].stringValue
        let location = data["location"]["address1"].stringValue+" "+data["location"]["address2"].stringValue+", "+data["location"]["city"].stringValue
        let display_phone = data["phone"].stringValue
        
        let image_url = data["image_url"].stringValue
        let is_closed = data["is_closed"].boolValue
        

        var restaurant = localDatabase.restaurants[id]
        if restaurant == nil {
            restaurant = Restaurant(id: id)
        }
        
        restaurant!.setRestaurantDetails(name: name, rating: rating, review_count: review_count, url: url, location: location, display_phone: display_phone, image_url: image_url, is_closed: is_closed)
        
        
        localDatabase.restaurants.updateValue(restaurant!, forKey: id)
        
        return id
    }
    
    // Archive grocery store data. save grocery store data to local database, and return the grocery store id
    private class func archiveGroceryStoreData(data:JSON)->String? {
        let id = data["id"].stringValue
        let name = data["name"].stringValue
        let rating = data["rating"].stringValue
        let review_count = data["review_count"].stringValue
        let url = data["url"].stringValue
        let location = data["location"]["address1"].stringValue+" "+data["location"]["address2"].stringValue+", "+data["location"]["city"].stringValue
        let display_phone = data["phone"].stringValue
        let image_url = data["image_url"].stringValue
        let is_closed = data["is_closed"].boolValue
        
        var groceryStore = localDatabase.groceryStores[id]
        if groceryStore == nil {
            groceryStore = GroceryStore(id: id)
        }
        
        groceryStore!.setGroceryStoreDetails(name: name, rating: rating, review_count: review_count, url: url, location: location, display_phone: display_phone, image_url: image_url, is_closed: is_closed)
        
        
        localDatabase.groceryStores.updateValue(groceryStore!, forKey: id)
        
        return id
    }
}
