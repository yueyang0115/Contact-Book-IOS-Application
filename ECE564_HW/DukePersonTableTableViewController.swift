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
    //database-related variable
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allPersons = [DukePerson]()
    var sortedDB :[[DukePerson]] = [[],[],[]] //0:Professor, 1:TA, 2:Student
    
    //segue-related variable
    let defaultImage = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
    @IBOutlet weak var addButton: UIBarButtonItem!
    var edittedPerson: DukePerson?
    
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
        let imageRic = UIImage(named: "ric")
        let imageYue = UIImage(named: "yue")
        let imageTA0 = UIImage(named: "TA2")
        addPersonToDB(firstName: "Yue", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Student", degree: "Grad", hobby: ["reading"], language: ["swift"], team: "ece564", email: "yy258@duke.edu", image: imageYue!.pngData()!)
        addPersonToDB(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County", gender: "Male", role: "Professor", degree: "N/A", hobby: ["teaching"], language: ["swift"], team: "ece564", email: "rt113@duke.edu", image: imageRic!.pngData()!)
        addPersonToDB(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", role: "Teaching Assistant", degree: "Grad", hobby: ["reading books", "jogging"], language: ["swift", "java"], team: "ece564", email: "hz147@duke.edu", image: imageTA0!.pngData()!)
        addPersonToDB(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Teaching Assistant", degree: "Grad", hobby: ["dancing"], language: ["Java", "cpp"], team: "ece564", email: "yy227@duke.edu", image: imageTA0!.pngData()!)
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
        sortedDB = [[],[],[]]
        
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
    func addPersonToDB(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: [String], language: [String], team: String, email: String, image: Data){
        let newPerson = DukePerson(context: self.context)
        newPerson.firstName = firstName; newPerson.lastName = lastName; newPerson.whereFrom = whereFrom; newPerson.gender = gender; newPerson.role = role; newPerson.degree = degree; newPerson.hobby = hobby; newPerson.language = language; newPerson.team = team; newPerson.email = email; newPerson.image = image
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
        let sectionImgView = UIImageView(frame: CGRect(x: 15, y: 5, width: 25, height: 25))
        
        let label = UILabel(frame: CGRect(x: 45, y: 5, width: tableView.bounds.width-25, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        switch section {
            case 0:
              label.text = "Professors"
              sectionImgView.image = UIImage(named: "professor")
            case 1:
              label.text = "TAs"
              sectionImgView.image = UIImage(named: "TA")
            case 2:
              label.text = "Students"
              sectionImgView.image = UIImage(named: "student")
            default:
              label.text = ""
        }
        view.addSubview(label)
        view.addSubview(sectionImgView)
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DukePersonProtoCell", for: indexPath) as! DukePersonProtoCell
        let person: DukePerson = self.sortedDB[indexPath.section][indexPath.row]
        cell.setCell(person: person)
        if(person.image == defaultImage!.pngData()){
            cell.pImageView.image = defaultImage
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.edittedPerson = self.sortedDB[indexPath.section][indexPath.row]
        //print("in table, get into didselectRow func")
        performSegue(withIdentifier: "editSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Delete Cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let person: DukePerson = self.sortedDB[indexPath.section][indexPath.row]
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Person", message: "Are you sure you want to delete person \(person.firstName!) \(person.lastName!) ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
                    self.deletePersonFromDB(person: person)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    }))
            self.present(alert, animated: true, completion: nil)
        }
        //else if editingStyle == .insert {}
    }
    

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
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
//        let dst: InformationViewController = segue.destination as! InformationViewController
        let dst = navController.topViewController as! InformationViewController
        if (segue.identifier == "addSegue")  {
            navController.topViewController?.navigationItem.rightBarButtonItem?.title = "Save"
            dst.segueType = "addSegue"
        }
        else if(segue.identifier == "editSegue"){
            //print("in table, get into prepare function")
            navController.topViewController?.navigationItem.rightBarButtonItem?.title = "Edit"
            dst.edittedPerson = self.edittedPerson
            dst.segueType = "editSegue"
        }
    }
    
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue){
//        let source: InformationViewController = segue.source as! InformationViewController
        self.fetchAllPersonFromDB()
        self.tableView.reloadData()
    }
}
