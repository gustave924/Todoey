//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmed Aboelela on 7/5/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var dummy : [Item] = []
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category?{
        didSet{
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell’s contents.
        cell.textLabel?.text = dummy[indexPath.row].title
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
            let item = Item(context: self.context)
            item.title = textField.text!
            item.isChecked = false
            item.parentCategory = self.selectedCategory
            self.dummy.append(item)
            
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
        
        do{
            try context.save()
        }catch{
            print("error w7esh 5ales \(error)")
        }
    }
    
    func loadTasks(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory?.title ?? "")
        if let incomingPredicate = request.predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, incomingPredicate])
        }else{
            request.predicate = predicate
        }
        
        do{
            dummy = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("error gamed fas5h \(error)")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors =  [NSSortDescriptor(key: "title", ascending: true)]
        loadTasks(with: request)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0){
            loadTasks()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

