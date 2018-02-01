//
//  GroceryViewController.swift
//  YelpDemo
//
//  Created by stvding on 2018/1/31.
//  Copyright © 2018年 Shell Company. All rights reserved.
//

import UIKit

class GroceryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: - UI Parts and Variables
    @IBOutlet weak var groceryStoreTable: UITableView!
    var groceryStoreId = [String]()
    var isGroceryStoreLoading = false
    var isGroceryStoreLoaded = false
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groceryStoreTable.delegate = self
        self.groceryStoreTable.dataSource = self
        self.groceryStoreTable.register(UINib(nibName: "RGCell", bundle:nil), forCellReuseIdentifier: "RGCell")
        fetchNewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - TableView Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryStoreId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groceryStoreTable.dequeueReusableCell(withIdentifier: "RGCell", for: indexPath) as! RGTableViewCell
        if let r = localDatabase.groceryStores[groceryStoreId[indexPath.row]]{
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
        groceryStoreTable.deselectRow(at: indexPath, animated: true)
        let id = groceryStoreId[indexPath.row]
        self.performSegue(withIdentifier: "showDetailViewOfGrocery", sender: id)
        
    }
    
    //MARK: - Helper
    func fetchNewData(){
        if localDatabase.currentLong != nil && localDatabase.currentLat != nil {
            fetchDataUtility.fetchGroceryStoreListByUrl(url: getGroceryByCoordinateUrl(localDatabase.currentLat!,localDatabase.currentLong!), completion: { (isSucceed, restaurantIds) in
                if isSucceed {
                    self.groceryStoreId = restaurantIds
                }
                self.groceryStoreTable.reloadData()
            })
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let groceryStoreId = sender as? String {
            if let groceryStore = localDatabase.groceryStores[groceryStoreId]{
                if segue.identifier == "showDetailViewOfGrocery" {
                    if let dest = segue.destination as? DetailViewController{
                        dest.name = groceryStore.name
                        dest.rating = "⭐️" + groceryStore.rating
                        dest.location = groceryStore.location
                        dest.phone = groceryStore.display_phone
                        dest.reviewCount = groceryStore.review_count
                        dest.isOpen = !groceryStore.is_closed
                        dest.imageUrl = groceryStore.image_url
                        dest.url = groceryStore.url
                    }
                }
            }
        }
    }

}
