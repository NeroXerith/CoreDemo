//
//  ViewController.swift
//  CoreDemo
//
//  Created by Biene Bryle Sanico on 3/18/25.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    
    @IBOutlet weak var TableView: UITableView!
    var items: [Person]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableUI()
        fetchPersons()
    }

    func setupTableUI(){
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func addPerson(){
        let alert = UIAlertController(title: "Add Person", message: "Name: ", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default){ (action) in
            guard let textField = alert.textFields?.first, let nameToAdd = textField.text, !nameToAdd.isEmpty  else { return }
            
            let newPerson = Person(context: self.context)
            newPerson.name = nameToAdd
            
            do {
                try self.context.save()
                self.fetchPersons()
            } catch {
                print("There was a problem saving the data")
            }
            
            
        }
        
        alert.addAction(submitButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchPersons(){
        do {
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        } catch {
            
        }
    }

    @IBAction func addPersonButton(_ sender: Any) {
        addPerson()
    }
    
}

extension ViewController{
    // Configure the UI for a specific cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let person = self.items![indexPath.row]
        cell.testLabel.text = person.name
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]
        let alert = UIAlertController(title: "Edit Person", message: "Edit name: ", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
