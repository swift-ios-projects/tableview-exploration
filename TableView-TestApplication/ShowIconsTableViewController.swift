//
//  ShowIconsTableViewController.swift
//  TableView-TestApplication
//
//  Created by Robert Byrne on 2015-12-05.
//  Copyright © 2015 LeanRob. All rights reserved.
//

import UIKit

class ShowIconsTableViewController: UITableViewController {

    
    @IBOutlet weak var myTableView: UITableView!
    
    var iconSets = [IconSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize iconSet from iconsets Iconsets.swift, then set a variable to be the first set of icons store them in icons variable
        
        iconSets = IconSet.iconSets()
        
        // Allows the user to click a row when editing modeis enabled
        tableView.allowsSelectionDuringEditing = true
        
        // edit button code
        navigationItem.rightBarButtonItem = editButtonItem()
        tableView.estimatedRowHeight = 67.0
        tableView.rowHeight = UITableViewAutomaticDimension

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    // MARK: - Table view data source

extension ShowIconsTableViewController {
    
    // set editing functionallity for the edit button to delete rows
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            
            // Start and end updates after this code block
            // This code is to add a new row to the index by enumerating through the rows and then adding a row at the indexPath
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerate() {
                let indexPath = NSIndexPath(forItem: set.icons.count, inSection: index)
                
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
            
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerate() {
                let indexPath = NSIndexPath(forItem: set.icons.count, inSection: index)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return iconSets.count
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // create variable with iconsets array with all sections, then return the total array icons count
        
        let adjustment = editing ? 1 : 0
        
        let iconSet = iconSets[section]
        return iconSet.icons.count + adjustment
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // create iconSet as array of sections, return iconset names. See Iconset file for details.
        let iconSet = iconSets[section]
        return iconSet.name
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        //set icon set to array of all sections
        let iconSet = iconSets[indexPath.section]
        
        if indexPath.row >= iconSet.icons.count && editing {
            
            cell = tableView.dequeueReusableCellWithIdentifier("NewRowCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Add Row"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
            
        } else {
            
            cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
            if let iconCell = cell as? IconTableViewCell {
                
                let icon = iconSet.icons[indexPath.row]
                iconCell.titleLable.text = icon.title
                iconCell.subTitleLabel.text = icon.subtitle
                
                if let iconImage = icon.image {
                    iconCell.iconImageView?.image = iconImage
                    
                } else {
                    // sets image in a new row to empty instead of recycling the images for a new cell
                    iconCell.iconImageView?.image = nil
                }
                
                if icon.rating == .Awesome {
                    iconCell.favoriteImageView.image = UIImage(named: "star_sel.png")
                } else {
                    iconCell.favoriteImageView.image = UIImage(named: "star_uns.png")
                }
                
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // check if editing style is .Delete
        if editingStyle == .Delete {
            
            let set = iconSets[indexPath.section]
            set.icons.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        } else if editingStyle == .Insert {
            
            // This block of code adds a new row when the inset editing style button is tapped
            let newIcon = Icon(withTitle: "New Icon", subtitle: "", imageName: nil)
            let set = iconSets[indexPath.section]
            set.icons.append(newIcon)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
    }
    
    // this function controlls the button that show on the left side in editing mode
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        // create set variable to reference
        let set = iconSets[indexPath.section]
        
        // if row is bigger than the set count them add insert button, else return the delete button
        if indexPath.row >= set.icons.count {
            return .Insert
        }
        return .Delete
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let set = iconSets[indexPath.section]
        if editing && indexPath.row < set.icons.count {
            return nil
        }
        
        return indexPath
    }
    
    // This function allows for the user to tap on a row in  editing mode
    // if the set is bigger than the count of the section then 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let set = iconSets[indexPath.section]
        if indexPath.row >= set.icons.count && editing {
            self.tableView(tableView, commitEditingStyle: .Insert, forRowAtIndexPath: indexPath)
        }
    }
    
    // checking if this is a row or an ad icon row
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let iconSet = iconSets[indexPath.section]
        if indexPath.row >= iconSet.icons.count && editing {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceSet = iconSets[sourceIndexPath.section]
        let destinationSet = iconSets[destinationIndexPath.section]
        let iconToMove = sourceSet.icons[sourceIndexPath.row]
        
        // checking if they are the same, if not then swap them
        if sourceSet == destinationSet {
            if destinationIndexPath.row != sourceIndexPath.row {
                swap(&destinationSet.icons[destinationIndexPath.row], &destinationSet.icons[sourceIndexPath.row])
            }
        } else {
            // if not then we will have to remove an icon and add it to the destimation set
            destinationSet.icons.insert(iconToMove, atIndex: destinationIndexPath.row)
            sourceSet.icons.removeAtIndex(sourceIndexPath.row)
        }
    }
    
    // checking wether you can move something to a correct index path, otherwise provide a new one
    // stops an error whe you drop a cell beyond the add cell button
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        let set = iconSets[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= set.icons.count {
            return NSIndexPath(forItem: set.icons.count-1, inSection: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
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


