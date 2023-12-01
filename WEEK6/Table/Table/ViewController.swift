//
//  ViewController.swift
//  Table
//
//  Created by user240111 on 10/12/23.
//

import UIKit

struct Province {
    var name: String!
    var cities: [String]!
}

class ViewController: UITableViewController{
    
    @IBOutlet var myTableView : UIBarButtonItem!
    
    @IBAction
    func AlertBoxMethod(_ sender: UIBarButtonItem) {
        let myAlertControl = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        myAlertControl.addTextField { textField in
            textField.placeholder = "Write an Item"
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = myAlertControl.textFields?.first {
                if let text = textField.text {
                    self.createItem(text)
                }
            }
        }
     
        myAlertControl.addAction(cancelButton)
        myAlertControl.addAction(okButton)
        
  
        present(myAlertControl, animated: true, completion: nil)
    }
    
    
    //        @IBAction
    //        func clickAddButton(_ sender : UIBarButtonItem){
    //
    //        }
    
    
    //        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //            return car.count
    //        }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = toDoItems[indexPath.row]
        return cell
    }
    
    
    //        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! UITableViewCell
    //                 cell.textLabel?.text = car[indexPath.row]
    //                 return cell
    //        }
    
    func createItem(_ item: String) {
        toDoItems.append(item)
        UserDefaults.standard.set(toDoItems, forKey: "ToDoItems")
        
        // Reload the table view to reflect the updated data
        tableView.reloadData()
        print("item added")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            toDoItems.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    print("item deleted")
        }
    }
    
    
    var toDoItems = [String]()
    
    var car = ["BMW", "LAMBORGHINI", "MERCEDES"]
    let myProvince = [Province(name: "ontario", cities: ["Toronto","Waterloo","Ottawa"]), Province(name: "Quebec", cities: ["Montreal", "Quebec City", "Hull"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        toDoItems = UserDefaults.standard.stringArray(forKey: "ToDoItems") ?? []
        if let myLocal = UserDefaults.standard.stringArray(forKey: "ToDoItems") {
            toDoItems = myLocal
            print("old data fetched")
            
        }
        
        //    override func numberOfSections(in tableView: UITableView) -> Int {
        //        return myProvince.count
        //    }
        
        //    override func tabl
        
        //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return car.count
        //    }
        //
        //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! UITableViewCell
        //        cell.textLabel?.text = car[indexPath.row]
        //        return cell
        //    }
        //
        
        
        
    }
}
