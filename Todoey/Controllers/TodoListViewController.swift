//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: SwipeTableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            // Load Items for persistence
            loadItems()
            tableView.rowHeight = 80.0
        }
    }
    // Create current contex from the Current Apps shared resoures delegat and cast as our app delegate then get the persisted container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// Handles logic after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
        // Tap into the super class cell definitaion and update it
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Get a reference to the current item
        let item = itemArray[indexPath.row]
        
        // Set the cell text label with the array content at specified indexc
        cell.textLabel?.text = item.title ?? "No Items Added Yet"
        
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
        
        self.saveItems()
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
            
            // Create a new Item from current data model context and append to item array
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            
            // Save the updated item array to the DataModel
            self.saveItems()
            
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
    
    //MARK: - Model Manupulation Methods
    
    /// Save items array to the Core Data Item model
    func saveItems(){
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // Reload the table view data to update the UI
        tableView.reloadData()
    }
    
    
    /// Load Items in the Coredate persisted container
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        
        // Create filter predicate to only selects the items that have parentCategory.name that matches the selected category name
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        // If there is a search Item predicate create a compound predicate for the request otherwise continue with category predicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("Error Fetching items \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from swipe
    
    
    /// Overide implementation of the supper class method
    /// - Parameter indexPath: The current index path of the selected cell
    override func updateModel(at indexPath: IndexPath) {
        // Use the current context to delete from the persistence container
        context.delete(itemArray[indexPath.row])
        // Update the Item array
        itemArray.remove(at: indexPath.row)
    }
    
    
    
}

//MARK: - Search Bar  Methods
extension TodoListViewController: UISearchBarDelegate {
    
    /// Tells us when the search button is pressed in the UI
    /// - Parameter searchBar: The UI element sending the context
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // get a request for querying the database
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Tag on a query to the request to specify what we want back from the database and Add our structured query to the request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        // Sort date results from the data with a sort descriptor and  Add the sort descriptor to the request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // load items with the request and filter predicate
        loadItems(with: request, predicate: predicate)
    }
    
    
    /// Handles logic for everytime the text is changed in the search field
    /// - Parameters:
    ///   - searchBar: The UI Search bat
    ///   - searchText: the text in the search bar that is changing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

