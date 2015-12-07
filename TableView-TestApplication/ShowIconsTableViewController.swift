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
    
    // changed to an array of an array, optionals
    var iconSets: [[Icon?]?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize iconSet from iconsets Iconsets.swift, then set a variable to be the first set of icons store them in icons variable
        
        // count of how many letters are in the collation, in english == 26
        let sectionTitlesCount = UILocalizedIndexedCollation.currentCollation().sectionTitles.count
        
        // create 26 elements of iconSets, 1 for each letter
        var allSections = [[Icon?]?](count: sectionTitlesCount, repeatedValue: nil)
        
        let sets = IconSet.iconSets()
        let collation = UILocalizedIndexedCollation.currentCollation()
        
        // loop through each iconSet in sets and every icon in each iconSet and set its section number
        for iconSet in sets {
            var sectionNumber: Int
            for icon in iconSet.icons {
                sectionNumber = collation.sectionForObject(icon, collationStringSelector: "title")
                
                // if the number doesnt exist yet the create an array for it
                if allSections[sectionNumber] == nil {
                    allSections[sectionNumber] = [Icon?]()
                }
                // append each icon to section
                allSections[sectionNumber]!.append(icon)
            }
        }
        
        iconSets = allSections
        
        for index in 0 ... iconSets.count - 1 {
            let iconSet = iconSets[index]
            if let set = iconSet {
                set
                iconSets[index] = set.sort(<)
            }
        }
        
        // Allows the user to click a row when editing modeis enabled
        tableView.allowsSelectionDuringEditing = true
        
        // edit button code
        navigationItem.rightBarButtonItem = editButtonItem()
        tableView.estimatedRowHeight = 67.0
        tableView.rowHeight = UITableViewAutomaticDimension

        
    }
    
    // reloads data when changes are made and they leave the Edit screen
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //prepare for segue ro edit view controller
        if segue.identifier == "goToEdit" {
            
            let editViewController = segue.destinationViewController as? EditTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let set = iconSets[indexPath.section]
                let icon = set![indexPath.row]
                editViewController?.icon = icon
                
            }
            
        }
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
                let indexPath = NSIndexPath(forItem: set!.count, inSection: index)
                
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
            
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerate() {
                let indexPath = NSIndexPath(forItem: set!.count, inSection: index)
                
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
        
        //let adjustment = editing ? 1 : 0
        //let iconSet = iconSets[section]
        
        guard let iconSet = iconSets[section] else {
            return 0
        }
        return iconSet.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // create iconSet as array of sections, return iconset names. See Iconset file for details.
        
        /*let iconSet = iconSets[section]
        commented out to show indexing
        */
        return UILocalizedIndexedCollation.currentCollation().sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        //set icon set to array of all sections
        let iconSet = iconSets[indexPath.section]
        
        let set = iconSets[indexPath.section]
        
        if indexPath.row >= iconSet!.count && editing {
            
            cell = tableView.dequeueReusableCellWithIdentifier("NewRowCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Add Row"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
            
        } else {
            
            cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
            if let iconCell = cell as? IconTableViewCell {
                
                let icon = set![indexPath.row]
                iconCell.titleLable.text = icon!.title
                iconCell.subTitleLabel.text = icon!.subtitle
                
                if let iconImage = icon!.image {
                    iconCell.iconImageView?.image = iconImage
                    
                } else {
                    // sets image in a new row to empty instead of recycling the images for a new cell
                    iconCell.iconImageView?.image = nil
                }
                
                if icon!.rating == .Awesome {
                    iconCell.favoriteImageView.image = UIImage(named: "star_sel.png")
                } else {
                    iconCell.favoriteImageView.image = UIImage(named: "star_uns.png")
                }
                
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var set = iconSets[indexPath.section]
        
        // check if editing style is .Delete
        if editingStyle == .Delete {
            
            set!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        } else if editingStyle == .Insert {
            
            // This block of code adds a new row when the inset editing style button is tapped
            let newIcon = Icon(withTitle: "New Icon", subtitle: "", imageName: nil)
            set!.append(newIcon)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
    }
    
    // this function controlls the button that show on the left side in editing mode
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        // create set variable to reference
        let set = iconSets[indexPath.section]
        
        // if row is bigger than the set count them add insert button, else return the delete button
        if indexPath.row >= set!.count {
            return .Insert
        }
        return .Delete
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let set = iconSets[indexPath.section]
        if editing && indexPath.row < set!.count {
            return nil
        }
        
        return indexPath
    }
    
    // This function allows for the user to tap on a row in  editing mode
    // if the set is bigger than the count of the section then 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let set = iconSets[indexPath.section]
        if indexPath.row >= set!.count && editing {
            self.tableView(tableView, commitEditingStyle: .Insert, forRowAtIndexPath: indexPath)
        }
    }
    
    // checking if this is a row or an ad icon row
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let iconSet = iconSets[indexPath.section]
        if indexPath.row >= iconSet!.count && editing {
            return false
        }
        return true
    }
    
    /* Commmented out to show indexing
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
    */
    
    // checking wether you can move something to a correct index path, otherwise provide a new one
    // stops an error whe you drop a cell beyond the add cell button
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        let set = iconSets[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= set!.count {
            return NSIndexPath(forItem: set!.count-1, inSection: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    // The following 2 methods are used to show a alphabetical side scroll for the tableView
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.currentCollation().sectionTitles
    }
    
    // this function lets you skip through empty section in your tableView
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        var sectionIndex = UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
        let totalSections = iconSets.count
        for counter in index ... totalSections - 1 {
            if iconSets[counter]?.count > 0 {
                sectionIndex = counter
                break
            }
        }
        return sectionIndex
        
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


