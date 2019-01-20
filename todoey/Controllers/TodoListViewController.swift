//
//  ViewController.swift
//  todoey
//
//  Created by bhalchandra on 14/11/18.
//  Copyright © 2018 bhalchandra. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)

        if let item = todoItems?[indexPath.row] {

        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
        } else {

            cell.textLabel?.text = "NO Items Added"
        }

        return cell
    }
    
    //Mark - Tableview Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error ")
            }
        }
        tableView.reloadData()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks the add item  BUtton on our UIalert
            
            if let currentCategory = self.selectedCategory {
                do {
                    
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)" )
                }
                
            }
           self.tableView.reloadData()
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        
        }
    
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    


    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}
//MARK: - Search Bar methods
extension TodoListViewController: UISearchBarDelegate {
    
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true )
        tableView.reloadData()
}

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
