//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmed Aboelela on 7/5/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var dummy = ["Hey", "Hello", "Hi"]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            dummy = items
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell’s contents.
        cell.textLabel?.text = dummy[indexPath.row]
        
        return cell
    }
    
    //MARK - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(dummy[indexPath.row])
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            let textField = alert.textFields![0]
            self.dummy.append(textField.text!)
            self.defaults.set(self.dummy, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (userInput) in
            userInput.placeholder = "Add a todey item"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

