//
//  DukePersonTableTableViewController.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/9/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class DukePersonTableTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // get all persons form database
    var allPersons = [DukePerson]()
    var sortedDB = [[DukePerson]]() //0:Professor, 1:TA, 2:Student

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        clearDB()
        addDefaultPersonInDB()
        fetchAllPersonFromDB()
    }
    
    // MARK: - database-related operations
    
    // clear database
    func clearDB(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DukePerson.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    // add some default data in database
    func addDefaultPersonInDB(){
        addPersonToDB(firstName: "Yue", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Student", degree: "Grad", hobby: ["reading"], language: ["swift"], team: "ece564", email: "yy258@duke.edu")
        addPersonToDB(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County", gender: "Male", role: "Professor", degree: "N/A", hobby: ["teaching"], language: ["swift"], team: "ece564", email: "rt113@duke.edu")
        addPersonToDB(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", role: "Teaching Assistant", degree: "Grad", hobby: ["reading books", "jogging"], language: ["swift", "java"], team: "ece564", email: "hz147@duke.edu")
        addPersonToDB(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Teaching Assistant", degree: "Grad", hobby: ["dancing"], language: ["Java", "cpp"], team: "ece564", email: "yy227@duke.edu")
    }
    
    // get all persons from database
    func fetchAllPersonFromDB(){
        do{
            self.allPersons = try context.fetch(DukePerson.fetchRequest())
            classifyPerson()
        } catch let error as NSError {
            print("Failed to get all persons from database")
            print(error)
        }
    }
    
    // classify persons by their roles, store result in 2D array as sorted database
    func classifyPerson(){
        sortedDB = [[DukePerson]]()
        sortedDB.append([DukePerson]())
        sortedDB.append([DukePerson]())
        sortedDB.append([DukePerson]())
        
        for person in allPersons{
            switch person.role{
            case "Professor":
                sortedDB[0].append(person)
            case "Teaching Assistant":
                sortedDB[1].append(person)
            case "Student":
                sortedDB[2].append(person)
            default: continue
            }
        }
    }
    
    // add one person to database
    func addPersonToDB(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: [String], language: [String], team: String, email: String){
        let newPerson = DukePerson(context: self.context)
        newPerson.firstName = firstName; newPerson.lastName = lastName; newPerson.whereFrom = whereFrom; newPerson.gender = gender; newPerson.role = role; newPerson.degree = degree; newPerson.hobby = hobby; newPerson.language = language; newPerson.team = team; newPerson.email = email
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Failed to save new person into database")
            print(error)
        }
        self.fetchAllPersonFromDB()
    }
    
    // delete one person from database
    func deletePersonFromDB(person: DukePerson){
        self.context.delete(person)
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Failed to save data after deletion")
            print(error)
        }
        self.fetchAllPersonFromDB()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return self.allPersons.count
        switch section{
            case 0:
                return sortedDB[0].count
            case 1:
                return sortedDB[1].count
            case 2:
                return sortedDB[2].count
            default:
                return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.bounds.width, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        switch section {
            case 0:
              label.text = "Professors"
            case 1:
              label.text = "TAs"
            case 2:
              label.text = "Students"
            default:
              label.text = ""
        }
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DukePersonProtoCell", for: indexPath) as! DukePersonProtoCell
        let person: DukePerson = self.sortedDB[indexPath.section][indexPath.row]
        cell.setCell(person: person)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //let tappedDukePerson: DukePerson = self.allPersons[indexPath.row]
        //tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        performSegue(withIdentifier: "editSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - ReturnHandler
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue){
//        let source: InformationViewController = segue.source as! InformationViewController
        self.fetchAllPersonFromDB()
        self.tableView.reloadData()
    }
}
