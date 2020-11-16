//
//  EmployeeListTableViewController.swift
//  Employee
//
//  Created by Kasito on 16.11.2020.
//

import UIKit
import FirebaseDatabase

class EmployeeListTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    
    var employeers = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("profiles")
        
        loadFromFireBase()
    }
    
    func loadFromFireBase() {
        ref?.observe(.value) { snapshot in
            
            var newEmployee = [Employee]()
            for list in snapshot.children {
                let listEmployee = Employee(snapShot: list as! DataSnapshot)
                newEmployee.append(listEmployee)
            }
            
            self.employeers = newEmployee
            self.tableView.reloadData()
        }
    }
    
    @IBAction func cancel(sender: UIStoryboardSegue) {}
    
    func cellCheckbox(cell: UITableViewCell, isDev: Bool) {
        if isDev {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        }
    }
    
    func decodetImage(imageString: String?) -> UIImage? {
        guard  let imageString = imageString, let decodedData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
        else {
            return nil
        }
        return UIImage(data: decodedData)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        let items = employeers[indexPath.row]
        cell.textLabel?.text = items.name
        
        let date =   Date(timeIntervalSince1970: TimeInterval(items.dateOfBirth ?? 0) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        cellCheckbox(cell: cell, isDev: items.developer ?? false)
        
        cell.imageView?.image = decodetImage(imageString: items.foto)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ref.child(employeers[indexPath.row].name ?? "").removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var toggle: Bool
        
        if cell?.accessoryType == .checkmark {
            toggle = false
        } else {
            toggle = true
        }
        
        cellCheckbox(cell: cell!, isDev: toggle)
        ref.child(employeers[indexPath.row].name ?? "").updateChildValues(["developer" : toggle])
    }
}
