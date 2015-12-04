//
//  ViewController.swift
//  TableView-TestApplication
//
//  Created by Robert Byrne on 2015-12-04.
//  Copyright © 2015 LeanRob. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var icons = [Icon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let iconSets = IconSet.iconSets()
        let iconSet = iconSets[0]
        icons = iconSet.icons
        
        // removes space before first row of table
        automaticallyAdjustsScrollViewInsets = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
        let icon = icons[indexPath.row]
        
        cell.textLabel?.text = icon.title
        cell.detailTextLabel?.text = icon.subtitle
        
        if let imageView = cell.imageView, iconImage = icon.image {
            imageView.image = iconImage
        }

        
        return cell
    }
    
}

