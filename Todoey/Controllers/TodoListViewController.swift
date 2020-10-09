//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let userDefault = UserDefaults.standard
    let todoListArrayKey = "TodoListArray"
    
    /// Handles logic after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Find Mike"
        newItem.done = false
        
        itemArray.append(newItem)
        
        
        // Get the items in the User Defaults database
//        if let items = userDefault.array(forKey: todoListArrayKey) as? [String] {
//            itemArray = items
//        }
      
    }
    
    //MARK: - Tableview Datasource methods
    
    
    /// Used to get the numbers of cell rows needed for the table view
    /// - Parameters:
    ///   - tableView: The current table view
    ///   - section: The number of rows or section
    /// - Returns: the number returned
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    /// Used to populate each cell or row with the data
    /// - Parameters:
    ///   - tableView: The Current table view by indentifier
    ///   - indexPath: The index of the section or row where the data is inserted
    /// - Returns: The cell with data to populate the Table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell constant from the reusable table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Get a reference to the current item
        let item = itemArray[indexPath.row]
        
        // Set the cell text label with the array content at specified indexc
        cell.textLabel?.text = item.title
        
        // If the currently selected cell row has accessarry checkmark then set it to none otherwith set the checkmark
        cell.accessoryType = item.done ? .checkmark : .none
    
        // return the updated cell
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    
    /// Notifies the table of that a particular row is or did get selected
    /// - Parameters:
    ///   - tableView: The current table view
    ///   - indexPath: the index of the section or row that was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update to selected item done property to the oposite of what it was
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // Reload the table view to show updated changes
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    /// Displays an alert for the user to add a new item
    /// - Parameter sender: The user action from the view
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Create a UI Text field to the higher function scope
        var textField = UITextField()
        // Create an alert using the controller with a title, no message, and a preferred style
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // Create an alert action button to add to the alert. This is the alerts action button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the add item button on our UIAlert
            // Create a new Item object and Append the item to the end of the item array
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            // Save the updated item array to the User defaults
//            self.userDefault.set(self.itemArray, forKey: self.todoListArrayKey)
            // Reload the table view data to update the UI
            self.tableView.reloadData()
        }
        // Used to add a textfield in the alert which is scppod to inside the alert
        alert.addTextField { (alertTextField) in
            // set the placeholder for the texfield in the alert
            alertTextField.placeholder = "Create new item"
            // This sets the Higher scopped textfield to the locally alert scopped textfield
            textField = alertTextField
        }
        // Adds the created alert action to the instance of the alert
        alert.addAction(action)
        // Presents the alert in the view with animation when the function is called
        present(alert, animated: true, completion: nil)
    }
}

