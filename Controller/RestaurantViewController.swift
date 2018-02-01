//
//  RestaurantViewController.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    //MARK: - UI Parts and Variables
    @IBOutlet weak var restaurantTable: UITableView!
    @IBOutlet weak var blackScreen: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingText: UILabel!
    
    var restaurantId = [String]()
    let locationManager = CLLocationManager()
    var isRestaurantLoaded = false
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantTable.delegate = self
        self.restaurantTable.dataSource = self
        self.restaurantTable.register(UINib(nibName: "RGCell", bundle:nil), forCellReuseIdentifier: "RGCell")
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if !isRestaurantLoaded {
            fetchNewData()
        }
    }
    
    //MARK: - TableView Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurantTable.dequeueReusableCell(withIdentifier: "RGCell", for: indexPath) as! RGTableViewCell
        if let r = localDatabase.restaurants[restaurantId[indexPath.row]]{
            cell.imageUrl = r.image_url
            cell.name = r.name
            cell.rating = "⭐️" + r.rating
            cell.location = r.location
            cell.phone = r.display_phone
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        restaurantTable.deselectRow(at: indexPath, animated: true)
        let id = restaurantId[indexPath.row]
        self.performSegue(withIdentifier: "showDetailViewOfRestaurant", sender: id)
        
    }
    
    //MARK: - Location setup
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = locations[0].coordinate
        localDatabase.currentLong = location.longitude
        localDatabase.currentLat = location.latitude
        if !self.isRestaurantLoaded {fetchNewData()}
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed?!! with error: \(error)")
    }
    
    //MARK: - Helper
    func fetchNewData(){
        showLoadingScreen()
        if localDatabase.currentLong != nil && localDatabase.currentLat != nil {
            self.isRestaurantLoaded = false
            fetchDataUtility.fetchRestaurantListByUrl(url: getRestaurantByCoordinateUrl(localDatabase.currentLat!,localDatabase.currentLong!), completion: { (isSucceed, restaurantIds) in
                if isSucceed {
                    self.restaurantId = restaurantIds
                }
                self.hideLoadingScreen()
                self.isRestaurantLoaded = true
                self.restaurantTable.reloadData()
            })
        }
    }
    
    func showLoadingScreen(){
        self.blackScreen.isHidden = false
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.loadingText.isHidden = false
    }
    
    func hideLoadingScreen(){
        self.blackScreen.isHidden = true
        self.spinner.stopAnimating()
        self.loadingText.isHidden = true
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let restaurantId = sender as? String {
            if let restaurant = localDatabase.restaurants[restaurantId]{
                if segue.identifier == "showDetailViewOfRestaurant" {
                    if let dest = segue.destination as? DetailViewController{
                        dest.name = restaurant.name
                        dest.rating = "⭐️" + restaurant.rating
                        dest.location = restaurant.location
                        dest.phone = restaurant.display_phone
                        dest.reviewCount = restaurant.review_count
                        dest.isOpen = !restaurant.is_closed
                        dest.imageUrl = restaurant.image_url
                        dest.url = restaurant.url
                    }
                }
            }
        }
    }
 

}
