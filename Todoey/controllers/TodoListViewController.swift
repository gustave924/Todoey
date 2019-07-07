//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmed Aboelela on 7/5/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var dummy : [TodoItem] = [TodoItem(itemValue: "Hey", isChecked: false),
                              TodoItem(itemValue: "Hello", isChecked: false),
                              TodoItem(itemValue: "Hi", isChecked: false)]
    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadTasks()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell’s contents.
        cell.textLabel?.text = dummy[indexPath.row].itemValue
        let isChecked = dummy[indexPath.row].isChecked
        if(isChecked){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(dummy[indexPath.row])
        let isChecked = dummy[indexPath.row].isChecked
        dummy[indexPath.row].isChecked = !isChecked
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveTasks()
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            let textField = alert.textFields![0]
            self.dummy.append(TodoItem(itemValue: textField.text!, isChecked: false))
            
            self.saveTasks()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (userInput) in
            userInput.placeholder = "Add a todey item"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTasks(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.dummy)
            try data.write(to: self.filePath!)
        }catch{
            print("error w7esh 5ales \(error)")
        }
    }
    
    func loadTasks(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
            dummy = try decoder.decode([TodoItem].self, from: data)
            }catch{
                print("error gamed fas5h \(error)")
            }
        }
    }
}

