//
//  RatingTableViewController.swift
//  TableView-TestApplication
//
//  Created by Robert Byrne on 2015-12-07.
//  Copyright © 2015 LeanRob. All rights reserved.
//

import UIKit

class RatingTableViewController: UITableViewController {

    var icon: Icon?
    
    // Sets a checkmark if the user has selected one of these ratings
    func refresh() {
        
        // note this trick to use when working with enumerations!!
        for index in 0 ... RatingType.TotalRatings.rawValue {
            
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = icon?.rating.rawValue == index ? .Checkmark : .None
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    // deselect the row when user taps on it, create rating based on indexPath.row, assign it to the icon
    // gaurd for anything past the indexPath.row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let rating = RatingType(rawValue: indexPath.row) else {
            return
        }
        icon?.rating = rating
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
