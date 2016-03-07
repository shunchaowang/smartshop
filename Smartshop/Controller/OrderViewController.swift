//
//  OrderViewController.swift
//  Smartshop
//
//  Created by Xianghuiru on 3/5/16.
//  Copyright © 2016 swang. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    private let orderNameCellIdentifier = "OrderNameCell"
    private var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(orderNameCellIdentifier, forIndexPath: indexPath) as! OrderTableViewCell
        
        let category = categories[indexPath.row]
        
        cell.categoryId = category.name
        
        // Configure the cell...
        
        return cell

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: Set up table view controller
    private func setup() {
        
        //add a margin of 0 to the top of the tableview
        //TOP, LEFT, BOTTOM, RIGHT
        //        let inset = UIEdgeInsetsMake(0, 0, 0, 0)
        //        self.tableView.contentInset = inset
        
        // add a separator to table
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        //        self.tableView.separatorColor = UIColor.blueColor()
        
        let httpUtil = SWHttpUtil()
        let requestUrl = "\(Constant.ServiceUrl)/\(Constant.AllCategoryRequest)"
        
        // TODO: add authorization header
        //        let headers = ["Accept": "application/json", "Authorization": "Bearer jHsYiWWRZDq5Sq3N"]
        
        httpUtil.get(requestUrl/*, headers: headers*/) {
            (results: [NSDictionary]?, error: String?) -> Void in
            if let unwrappedArray = results {
                
                var id = 0
                var name = ""
                var image = ""
                for category in unwrappedArray {
                    if let idValue = category.valueForKey("id") as? Int {
                        id = idValue
                    }
                    
                    if let nameValue = category.valueForKey("name") as? String {
                        name = nameValue
                    }
                    if let imageValue = category.valueForKey("image") as? String {
                        image = imageValue
                    }
                    let category = Category(id: id, name: name, image: image)
                    self.categories.append(category)
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
}



class OrderTableViewCell : UITableViewCell {
    
    @IBOutlet weak var OrderIdLabel: UILabel!
    
    var categoryId = "" {
        didSet {
            OrderIdLabel.text = categoryId
        }
    }
}


