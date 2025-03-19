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
        relationshipDemo()
    }

    func setupTableUI(){
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func addPerson(){
        // create the alert form
        let alert = UIAlertController(title: "Add Person", message: "Name: ", preferredStyle: .alert)
        alert.addTextField()
        
        
        // Config the submit button
        let submitButton = UIAlertAction(title: "Add", style: .default){ (action) in
           // Get the textfield alert
            guard let textField = alert.textFields?.first, let nameToAdd = textField.text, !nameToAdd.isEmpty  else { return }
            
            // Create a object of a Person
            let newPerson = Person(context: self.context)
            newPerson.name = nameToAdd
            
            // save the data and refetch
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
    func relationshipDemo(){
        
        // Create a family
        var family = Family(context: self.context)
        family.name = "ABC Family"
        
        // Create a person
        var person = Person(context: self.context)
        person.name = "John"
        person.family = family // 1st way to specify a relationship between family and person
        /*family.addToPeople(person)*/ // 1st way to specify a relationship between family and person/
        try! self.context.save()
        
        // Reload the tableview to display John
        DispatchQueue.main.async {
            self.TableView.reloadData()
        }
    }
    
    func fetchPersons(){
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            // Set filtering and sorting
            let pred = NSPredicate(format: "name CONTAINS %@", "B")
//            request.predicate = pred
            
            // Ascending Sorting
            let sortAsc = NSSortDescriptor(key: "name", ascending: true)
            
            // Descending Sorting
            let sortDesc = NSSortDescriptor(key: "name", ascending: false)
            
//            request.sortDescriptors = [sortDesc]
            self.items = try context.fetch(request)
            
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
    
    // Display person details in a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let person = self.items![indexPath.row]
        cell.testLabel.text = person.name
            return cell
    }
    
    // Edit the tapped Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]
        let alert = UIAlertController(title: "Edit Person", message: "Edit name: ", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = person.name
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text, !nameToSave.isEmpty else { return }
            person.name = nameToSave
            do {
                try self.context.save()
                self.fetchPersons()
            } catch {
                print("There was an error saving the data")
            }
        }
        alert.addAction(saveButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToRemove = self.items![indexPath.row]
            self.context.delete(personToRemove)
            do {
                try self.context.save()
                self.fetchPersons()
            } catch {
                
            }
        }
    }
}
