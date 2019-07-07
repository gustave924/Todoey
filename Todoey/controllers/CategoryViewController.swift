//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ahmed Aboelela on 7/7/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories: [Category] = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        readCategories()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    // MARK: - add view table data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination as! TodoListViewController
        destination.selectedCategory = categories[tableView.indexPathForSelectedRow!.row]
    }
    // MARK: - data manipulation methods
    
    // MARK: - add new categories
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add category", message: "Add your task category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            let textField = alert.textFields![0]
            let category = Category(context: self.context)
            category.title = textField.text!
            self.categories.append(category)
            self.saveCategories()
        }
        
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Add task Category"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    // MARK: - tableView delegate method

    func readCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("An error occured which is bad \(error)")
        }
    }
    
    func saveCategories(){
        do{
            try context.save();
        }catch{
            print("An error occured which is bad \(error)")
        }
        tableView.reloadData()
    }
}
