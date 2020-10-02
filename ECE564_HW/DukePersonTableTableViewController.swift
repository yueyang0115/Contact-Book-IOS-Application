//
//  DukePersonTableTableViewController.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/9/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class DukePersonTableTableViewController: UITableViewController, UISearchBarDelegate {
    //database-related variable
    @IBOutlet weak var modeButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allPersons = [DukePerson]()
    //var sortedDB :[[DukePerson]] = [[],[],[]] //0:Professor, 1:TA, 2:Student
    var filteredPersons : [String: [DukePerson]] = [:]
    var imageDict : [String: UIImage] = [:]
    
    //segue-related variable
    let defaultImage = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
    var edittedPerson: DukePerson?
    
    // dark mode related
    @IBOutlet weak var addButton: UIBarButtonItem!
    var isDark :Bool = false
    
    //search-related variable
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseConfiguration()
        setUpSearchBar()
        setTableViewBright()
    }
    
    func databaseConfiguration() {
        clearDB()
        addDefaultPersonInDB()
        fetchAllPersonFromDB()
        setImageDict()
        //filteredPersons = sortedDB
        modeButton.title = "Dark/Bright"
    }
    
    func setImageDict(){
        imageDict["Professor"] = UIImage(named: "Professors")
        imageDict["Students"] = UIImage(named: "Students")
        imageDict["Teaching Assistant"] = UIImage(named: "TAs")
    }
    
    @IBAction func changeMode(_ sender: Any) {
        if(isDark){
            setTableViewBright()
            isDark = false
        }
        else{
            setTableViewDark()
            isDark = true
        }
        self.tableView.reloadData()
    }
    
    // setUp tableView
    func setTableViewBright(){
        let tempImageView = UIImageView(image: UIImage(named: "bg9"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
    }
    
    func setTableViewDark(){
        let tempImageView = UIImageView(image: UIImage(named: "night6"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
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
        let imageRic = resizeImage(image: UIImage(named: "ric")!, targetSize: CGSize(width: 50, height: 50))
        let imageYue = resizeImage(image: UIImage(named: "yue")!, targetSize: CGSize(width: 50, height: 50))
        let imageHaohang = resizeImage(image: UIImage(named: "haohong")!, targetSize: CGSize(width: 50, height: 50))
        let imageYuchen = resizeImage(image: UIImage(named: "yuchen")!, targetSize: CGSize(width: 50, height: 50))
        let imageTeam = UIImage(named: "Teams")
        
        let decodedRic = imageRic.pngData()!.base64EncodedString(options: .lineLength64Characters)
        let decodedYue = imageYue.pngData()!.base64EncodedString(options: .lineLength64Characters)
        let decodedHaohang = imageHaohang.pngData()!.base64EncodedString(options: .lineLength64Characters)
        let decodedYuchen = imageYuchen.pngData()!.base64EncodedString(options: .lineLength64Characters)
        let decodedTeam = imageTeam!.pngData()!.base64EncodedString(options: .lineLength64Characters)
        
        
        addPersonToDB(firstName: "Yue", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Student", degree: "Grad", hobby: ["skating"], language: ["swift"], team: "ECE564", email: "yy258@duke.edu", image: decodedYue)
        addPersonToDB(firstName: "Weihan", lastName: "Zhang", whereFrom: "China", gender: "Female", role: "Student", degree: "Grad", hobby: ["singing"], language: ["c++"], team: "ECE564", email: "wz125@duke.edu", image: decodedTeam)
        addPersonToDB(firstName: "Zeyu", lastName: "Li", whereFrom: "China", gender: "Male", role: "Student", degree: "Grad", hobby: ["running"], language: ["java"], team: "", email: "zeyu.li@duke.edu", image:  decodedTeam)
        addPersonToDB(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County", gender: "Male", role: "Professor", degree: "N/A", hobby: ["teaching"], language: ["swift"], team: "", email: "rt113@duke.edu", image: decodedRic)
        addPersonToDB(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", role: "Teaching Assistant", degree: "Grad", hobby: ["reading books", "jogging"], language: ["swift", "java"], team: "", email: "hz147@duke.edu", image: decodedHaohang)
        addPersonToDB(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Teaching Assistant", degree: "Grad", hobby: ["dancing"], language: ["Java", "cpp"], team: "", email: "yy227@duke.edu", image: decodedYuchen)
        
        fetchPerson(firstName: "Yue", lastName: "Yang")
        fetchPerson(firstName: "Ric", lastName: "Telford")
        fetchPerson(firstName: "Haohong", lastName: "Zhao")
        fetchPerson(firstName: "Yuchen", lastName: "Yang")
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // encode newly added person to JSON
    // func fetch newly added person and save to json
    func fetchPerson(firstName: String, lastName: String){
        do{
            let persons: [DukePerson] = try context.fetch(DukePerson.fetchRequest())
            for person in persons{
                if(person.firstName!.lowercased() == firstName.lowercased() &&
                    person.lastName!.lowercased() == lastName.lowercased()){
                    let encodeSucceed:Bool = saveJsonInfo(person: person)
                    print("encode succeed: \(encodeSucceed)")
                }
            }
        }
        catch let error as NSError {
            print("When encode newly added person, failed to get all persons from database")
            print(error)
        }
    }
    
    func saveJsonInfo(person: DukePerson) -> Bool{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(person) {
            if let json = String(data: encoded, encoding: .utf8) {
                print("encode result is: \(json)")
                return true
            }
            else { return false }
        }
        else { return false }
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
        filteredPersons = [:]
        
        for person in allPersons{
            if(person.role == "Student" && person.team != ""){
                if(filteredPersons[person.team!] == nil){
                    filteredPersons[person.team!] = [DukePerson]()
                }
                filteredPersons[person.team!]!.append(person)
            }
            else{
                if(filteredPersons[person.role!] == nil){
                    filteredPersons[person.role!] = [DukePerson]()
                }
                filteredPersons[person.role!]!.append(person)
            }
        }
    }
    
    // add one person to database
    func addPersonToDB(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: [String], language: [String], team: String, email: String, image: String){
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
    
    // MARK: - TableView related
    
    // return num of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredPersons.count
    }

    // return num of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = filteredPersons.index(filteredPersons.startIndex, offsetBy: section)
        let key : String = filteredPersons.keys[index]
        return filteredPersons[key]!.count
    }
    
    // set view for one cell
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let sectionImgView = UIImageView(frame: CGRect(x: 15, y: 5, width: 25, height: 25))
        
        let label = UILabel(frame: CGRect(x: 45, y: 5, width: tableView.bounds.width-25, height: 25))
        //label.font = UIFont.boldSystemFont(ofSize: 18)
        label.font = UIFont(name: "Chalkduster", size: 18.0)
        if(isDark){
            label.textColor = UIColor.white
        }
        else{
            label.textColor = UIColor.black
        }
        
        let index = filteredPersons.index(filteredPersons.startIndex, offsetBy: section)
        let key : String = filteredPersons.keys[index]
        label.text = key
        if(imageDict[key] != nil){
            sectionImgView.image = imageDict[key]
        }
        else{
            sectionImgView.image = UIImage(named: "Teams")
        }
        
        view.addSubview(label)
        view.addSubview(sectionImgView)
        return view
    }
    
    // return one cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DukePersonProtoCell", for: indexPath) as! DukePersonProtoCell
        
        let index = filteredPersons.index(filteredPersons.startIndex, offsetBy: indexPath.section)
        
        let key : String = filteredPersons.keys[index]
        let persons: [DukePerson] = filteredPersons[key]!
        let person = persons[indexPath.row]
        
        cell.setCell(person: person, isDark: isDark)
        if(isDark){
            cell.backgroundColor = UIColor.black
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        
        let dataDecoded : Data = Data(base64Encoded: person.image!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        if(decodedimage!.pngData() == defaultImage!.pngData()){
            cell.pImageView.image = defaultImage
        }
        return cell
    }
    
    // swipe and choose to edit/delete a cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteCell(at: indexPath)
        let editAction = editCell(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // swipe and delete a cell
    func deleteCell(at indexPath: IndexPath) -> UIContextualAction{
        //let person: DukePerson = self.filteredPersons[indexPath.section][indexPath.row]
        let index = filteredPersons.index(filteredPersons.startIndex, offsetBy: indexPath.section)
        let key : String = filteredPersons.keys[index]
        let persons: [DukePerson] = filteredPersons[key]!
        let person = persons[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            self.displayDeleteAlert(at: indexPath, person: person)
            actionPerformed(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return deleteAction
    }
    
    // display alert for deletion action
    func displayDeleteAlert(at indexPath: IndexPath, person: DukePerson){
        let alert = UIAlertController(title: "Delete Person", message: "Are you sure you want to delete person \(person.firstName!) \(person.lastName!) ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
                self.deletePersonFromDB(person: person)
                //self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.fetchAllPersonFromDB()
                self.tableView.reloadData()
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // swipe and edit a cell
    func editCell(at indexPath: IndexPath) -> UIContextualAction{
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            //self.edittedPerson = self.filteredPersons[indexPath.section][indexPath.row]
            let index = self.filteredPersons.index(self.filteredPersons.startIndex, offsetBy: indexPath.section)
            let key : String = self.filteredPersons.keys[index]
            let persons: [DukePerson] = self.filteredPersons[key]!
            self.edittedPerson = persons[indexPath.row]
            
            self.performSegue(withIdentifier: "editSegue", sender: self)
            actionPerformed(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = #colorLiteral(red: 0, green: 0.7292503119, blue: 0, alpha: 1)
        return editAction
    }


    // MARK: - SearchBar Related
    
    // search bar settings
    func setUpSearchBar(){
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["All", "Professor", "TA", "Student"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
    }
    
    // do search when selected scope changes
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        doFilterSearch(index :selectedScope, searchText: searchBar.text!)
    }
    
    // do search when search text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doFilterSearch(index: searchBar.selectedScopeButtonIndex, searchText: searchText)
    }
    
    // search function
    func doFilterSearch(index :Int, searchText: String){
        if(searchText == ""){
            filteredPersons = [:]
            // only display person in that correspoding catogory
            for person in allPersons{
                filterRole(index: index, person: person)
            }
        }
        else{
            filteredPersons = [:]
            for person in allPersons{
                if(person.description.lowercased().contains(searchText.lowercased())){
                    filterRole(index: index, person: person)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // filter all persons by their roles, put in filteredPerson array
    func filterRole(index: Int, person: DukePerson){
        switch person.role{
        case "Professor":
            if(index == 0 || index == 1){
                if(filteredPersons[person.role!] == nil){
                    filteredPersons[person.role!] = [DukePerson]()
                }
                self.filteredPersons[person.role!]!.append(person)
            }
        case "Teaching Assistant":
            if(index == 0 || index == 2){
                if(filteredPersons[person.role!] == nil){
                    filteredPersons[person.role!] = [DukePerson]()
                }
                self.filteredPersons[person.role!]!.append(person)
            }
        case "Student":
            if(index == 0 || index == 3){
                if(person.team == ""){
                    if(filteredPersons[person.role!] == nil){
                        filteredPersons[person.role!] = [DukePerson]()
                    }
                    self.filteredPersons[person.role!]!.append(person)
                }
                else{
                    if(filteredPersons[person.team!] == nil){
                        filteredPersons[person.team!] = [DukePerson]()
                    }
                    filteredPersons[person.team!]!.append(person)
                }
            }
        default: break
        }
    }
    
    
    // MARK: - Navigation

    // go to edit scene when one cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //self.edittedPerson = self.filteredPersons[indexPath.section][indexPath.row]
        let index = self.filteredPersons.index(self.filteredPersons.startIndex, offsetBy: indexPath.section)
        let key : String = self.filteredPersons.keys[index]
        let persons: [DukePerson] = self.filteredPersons[key]!
        self.edittedPerson = persons[indexPath.row]
        
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    // preparation before leaving this scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let dst = navController.topViewController as! InformationViewController
        
        // if leave this scene by addSegue
        if (segue.identifier == "addSegue")  {
            navController.topViewController?.navigationItem.rightBarButtonItem?.title = "Save"
            dst.segueType = "addSegue"
        }
        // if leave this scene by editSegue
        else if(segue.identifier == "editSegue"){
            navController.topViewController?.navigationItem.rightBarButtonItem?.title = "Edit"
            dst.edittedPerson = self.edittedPerson
            dst.segueType = "editSegue"
        }
    }
    
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue){
        self.fetchAllPersonFromDB()
        self.tableView.reloadData()
        searchBar.selectedScopeButtonIndex = 0
    }
}
