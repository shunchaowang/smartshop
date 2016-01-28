//
//  CategoryTableViewController.swift
//  Smartshop
//
//  Created by Shunchao Wang on 1/26/2016.
//  Copyright © 2016 swang. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    private let categoryNameCellIdentifier = "CategoryNameCell"
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
        let cell = tableView.dequeueReusableCellWithIdentifier(categoryNameCellIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell
        
        let category = categories[indexPath.row]
            
        cell.categoryName = category.name
        cell.categoryId = category.id
        cell.categoryImageUrl = category.image
       
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
        
        // register tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapTableCell:")
        tapGestureRecognizer.delegate = self
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Tab handler
    func tapTableCell(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.Ended {
            return
        }
        
        let location = gestureRecognizer.locationInView(self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(location) {
            if let row = self.tableView.cellForRowAtIndexPath(indexPath) as? CategoryTableViewCell {
                performSegueWithIdentifier("CategoryTableToProductSegue", sender: row)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CategoryTableToProductSegue" {
            if let category = sender as? CategoryTableViewCell, destination = segue.destinationViewController as? ProductViewController {
                destination.categoryName = category.categoryName
                destination.categoryId = category.categoryId
            }
        }
    }
   
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    var categoryId: Int = 0
    var categoryName = "" {
        didSet {
            categoryNameLabel.text = categoryName
        }
    }
    var categoryImageUrl: String? {
        didSet {
            if let imageUrl = categoryImageUrl {
                if let url = NSURL(string: "\(Constant.ZencartUrl)/\(imageUrl)"), data = NSData(contentsOfURL: url) {
                    categoryImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

