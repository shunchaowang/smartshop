//
//  ProductViewController.swift
//  Smartshop
//
//  Created by Shunchao Wang on 1/27/2016.
//  Copyright © 2016 swang. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    var categoryId: Int = 0
    var categoryName = ""
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setup()
    }
    
    // MARK: initial setup
    private func setup() {
        categoryLabel.text = categoryName
    }

    // MARK: Back Button Action
    @IBAction func backButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("ProductBackToCategorySegue", sender: nil)
    }
    
    // MARK: Segue Preparation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProductToProductTableEmbedSegue" {
            if let destination = segue.destinationViewController as? ProductTableViewController {
                destination.categoryId = self.categoryId
            }
        }
    }
    
}

class ProductTableViewController: UITableViewController {
    
    var categoryId = 0
    private let productCellIdentifier = "ProductNameCell"
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setup()
    }
    
    // MARK: initial setup for table
    private func setup() {
        
        let httpUtil = SWHttpUtil()
        let requestUrl = "\(Constant.ServiceUrl)/\(Constant.ProductByCategoryRequest)"
        
        // TODO: add authorization header
        //let headers = ["Accept": "application/json", "Authorization": "Bearer jHsYiWWRZDq5Sq3N"]
        let headers = ["Accept": "application/json", "limit": "\(Constant.PageLimit)", "offset": "0"]
        
        httpUtil.get(requestUrl, headers: headers) {
            (results: [NSDictionary]?, error: String?) -> Void in
            if let unwrappedArray = results {
                
                var id = 0
                var model = ""
                var quantity = 0
                var image = ""
                var price = 0.0
                var weight = 0.0
                var name = ""
                var description = ""
                let categoryId = self.categoryId
               
                for product in unwrappedArray {
                    if let idValue = product.valueForKey("id") as? Int {
                        id = idValue
                    }
                    if let modelValue = product.valueForKey("model") as? String {
                        model = modelValue
                    }
                    if let quantityValue = product.valueForKey("quantity") as? Int {
                        quantity = quantityValue
                    }
                    
                    if let imageValue = product.valueForKey("image") as? String {
                        image = imageValue
                    }
                    if let priceValue = product.valueForKey("price") as? Double {
                        price = priceValue
                    }
                    if let weightValue = product.valueForKey("weight") as? Double {
                        weight = weightValue
                    }
                    if let nameValue = product.valueForKey("name") as? String {
                        name = nameValue
                    }
                    if let descriptionValue = product.valueForKey("description") as? String {
                        description = descriptionValue
                    }
                    let product = Product(id: id, model:model, quantity: quantity, image: image, price: price, weight: weight, name: name, description: description, categoryId: categoryId)
                    self.products.append(product)
                }
            }
            self.tableView.reloadData()
        }

        
    }

    
}
