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
        // load product belong to category here
        
    }

    
}
