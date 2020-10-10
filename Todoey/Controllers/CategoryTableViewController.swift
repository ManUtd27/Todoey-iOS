//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Shawn Williams on 10/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    /// Handles when the user pressed the Add category button
    /// - Parameter sender: UI element
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Add category pressed")
    }
}
