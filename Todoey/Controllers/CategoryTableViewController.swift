//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Shawn Williams on 10/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData



class CategoryTableViewController: SwipeTableViewController {
    
    var categoryArray = [Category]()
    // Create current contex from the Current Apps shared resoures delegat and cast as our app delegate then get the persisted container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    /// Handles logic after the view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Items for persistence
        loadCategories()
        tableView.rowHeight = 80.0
    }
    
    
    
    // MARK: - Table view data source methods
    
    /// Used to get the numbers of cell rows needed for the table view
    /// - Parameters:
    ///   - tableView: The current table view
    ///   - section: The number of rows or section
    /// - Returns: the number returned
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    /// Used to populate each cell or row with the data
    /// - Parameters:
    ///   - tableView: The Current table view by indentifier
    ///   - indexPath: The index of the section or row where the data is inserted
    /// - Returns: The cell with data to populate the Table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Tap into the super class cell definitaion and update it
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Get a reference to the current category
        let category = categoryArray[indexPath.row]
        
        // Set the cell text label with the array content at specified index
        cell.textLabel?.text = category.name ?? "No Categories Added Yet"
        
        // return the updated cell
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    /// Save Category array to the Core Data Item model
    func saveCategories(){
        do {
            try self.context.save()
        } catch {
            print("Error saving category \(error)")
        }
        // Reload the table view data to update the UI
        tableView.reloadData()
    }
    
    /// Load Categories in the Coredate persisted container
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            print("Error Fetching Categories \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from swipe
    
    
    /// Overide implementation of the supper class method
    /// - Parameter indexPath: The current index path of the selected cell
    override func updateModel(at indexPath: IndexPath) {
        // Use the current context to delete from the persistence container
        self.context.delete(self.categoryArray[indexPath.row])
        // Update the category array
        self.categoryArray.remove(at: indexPath.row)
    }
    
    //MARK: - Add New Categories
    
    /// Handles when the user pressed the Add category button
    /// - Parameter sender: UI element
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Create a UI Text field to the higher function scope
        var textField = UITextField()
        // Create an alert using the controller with a title, no message, and a preferred style
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // Create an alert action button to add to the alert. This is the alerts action button
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What will happen once the user clicks the add item button on our UIAlert
            
            // Create a new Category from current data model context and append to category array
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            
            // Save the updated Category array to the DataModel
            self.saveCategories()
            
        }
        // Used to add a textfield in the alert which is scppod to inside the alert
        alert.addTextField { (alertTextField) in
            // set the placeholder for the texfield in the alert
            alertTextField.placeholder = "Add a new category"
            // This sets the Higher scopped textfield to the locally alert scopped textfield
            textField = alertTextField
        }
        // Adds the created alert action to the instance of the alert
        alert.addAction(action)
        // Presents the alert in the view with animation when the function is called
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
    
    /// Notifies the table of that a particular row is or did get selected
    /// - Parameters:
    ///   - tableView: The current table view
    ///   - indexPath: the index of the section or row that was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /// Prepares the View Cotroller before the Segue begins
    /// - Parameters:
    ///   - segue: the current segue
    ///   - sender: The UI sender performing the segque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the View Controller that is the destination from the segue
        let destinationVC = segue.destination as! TodoListViewController
        
        // Grap the category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            // Set the destinationVS category to the selected category
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}


