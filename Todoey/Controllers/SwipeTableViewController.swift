//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Shawn Williams on 10/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Table View data source methods
    
    /// Used to populate each cell or row with the data
    /// - Parameters:
    ///   - tableView: The Current table view by indentifier
    ///   - indexPath: The index of the section or row where the data is inserted
    /// - Returns: The cell with data to populate the Table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell constant from the reusable table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // set the cell delegate to self
        cell.delegate = self
        
        // return the updated cell
        return cell
    }
    


    /// Updates the table view to have a swipeable action to delete categories
    /// - Parameters:
    ///   - tableView: The current table view
    ///   - indexPath: the index path of the cell to delete
    ///   - orientation: The orientaion of the current swipe
    /// - Returns: Returns the complete delete swipe action to the table view
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    
    /// Customize the look and feel of the swipe action
    /// - Parameters:
    ///   - collectionView: The current view thats being swiped
    ///   - indexPath: the index path of the swiped cell
    ///   - orientation: the orientatio of the swipped used for the action
    /// - Returns: Return the custom action back
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    /// Allows Subclassed to update the data model with the correct index path
    /// - Parameter indexPath: index of the current selected cell   
    func updateModel(at indexPath: IndexPath) {
        // Update our data model
    }
}
