//
//  ViewController.swift
//  CodeData_App
//
//  Created by Fedor Sychev on 23.11.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    // List with all ToDo items
    private var models = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data To Do List"
        
        view.addSubview(tableView)
        
        getAllItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    ///
    /// Function for creating new items
    /// 
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createItem(name: text)
            
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(model.name!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        
        let alert = UIAlertController(title: "Edit", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit", message: "Edit  Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let NewName = field.text, !NewName.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newName: NewName)
            }))
            
            self.present(alert, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(alert, animated: true)
    }
    
    
    
    
    
    
    // Core Data
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            tableView.reloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.created_at = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        
        do {
            try context.save()
             getAllItems()
        } catch {
            
        }
    }

}

