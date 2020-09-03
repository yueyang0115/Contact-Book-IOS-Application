//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by yueyang on 9/1/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class InformationViewController: UIViewController {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var roleInput: UITextField!
    @IBOutlet weak var degreeInput: UITextField!
    @IBOutlet weak var fromWhereInput: UITextField!
    
    @IBOutlet weak var hobbyInput: UITextField!
    @IBOutlet weak var languageInput: UITextField!
    @IBOutlet weak var teamInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // get persons form core data
    var allPersons = [DukePerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureTextField()
        clearDB()
        addDefaultPersonInDB()
        fetchAllPersonFromDB()
    }
    
    func configureTextField(){
        firstNameInput.delegate = self; lastNameInput.delegate = self; fromWhereInput.delegate = self; degreeInput.delegate = self; hobbyInput.delegate = self; languageInput.delegate = self
        genderInput.delegate = self; roleInput.delegate = self;
        teamInput.delegate = self; emailInput.delegate = self
        
        findButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        outputLabel.lineBreakMode = .byWordWrapping
        outputLabel.numberOfLines = 5
    }
    
    // MARK: - database-related operations
    
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
        addPersonToDB(firstName: "Yue", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Student", degree: "Grad", hobby: "reading", language: "swift", team: "ece564", email: "")
        addPersonToDB(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: "Male", role: "professor", degree: "N/A", hobby: "teaching", language: "swift", team: "ece564", email: "")
        addPersonToDB(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", role: "teaching assistant", degree: "Grad", hobby: "learning", language: "swift", team: "ece564", email: "")
        addPersonToDB(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", role: "teaching assistant", degree: "Grad", hobby: "learning", language: "swift", team: "ece564", email: "")
    }
    
    // get all persons from database
    func fetchAllPersonFromDB(){
        do{
            self.allPersons = try context.fetch(DukePerson.fetchRequest())
        } catch let error as NSError {
            print("Failed to get all persons from database")
            print(error)
        }
    }
    
    // add one person to database
    func addPersonToDB(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: String, language: String, team: String, email: String){
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Handler
    @IBAction func addPerson(_ sender: Any) {
        print("add person")
        // read input as new person's attribute
        let firstName: String  = firstNameInput.text ?? ""
        let lastName: String = lastNameInput.text ?? ""
        let fromWhere: String = fromWhereInput.text ?? ""
        let degree: String = degreeInput.text ?? ""
        let hobby: String = hobbyInput.text ?? ""
        let language: String = languageInput.text ?? ""
        let team: String = teamInput.text ?? ""
        let email: String = emailInput.text ?? ""
        
        let gender: String = genderInput.text ?? ""
        let role: String = roleInput.text ?? ""
        
        if(firstName == "" && lastName == ""){
            outputLabel.text = "Error: FirstName and LastName cannot be null."
            return
        }

        var personExist: Bool = false
        for person in allPersons{
            if(person.firstName!.lowercased() == firstName.lowercased() && person.lastName!.lowercased() == lastName.lowercased()){
                personExist = true
                outputLabel.text = "The person has been updated."
                
                deletePersonFromDB(person: person)
//                self.context.delete(person)
//                do {
//                    try self.context.save()
//                } catch  {
//                    print("Failed to save data after deletion")
//                }
//                self.fetchPersonFromDB()
                
                break
            }
        }
        
        addPersonToDB(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, degree: degree, hobby: hobby, language: language, team: team, email: email)
//        let newPerson = DukePerson(context: self.context)
//        newPerson.firstName = firstName; newPerson.lastName = lastName; newPerson.whereFrom = fromWhere; newPerson.gender = gender; newPerson.role = role; newPerson.degree = degree; newPerson.hobby = hobby; newPerson.language = language; newPerson.team = team; newPerson.email = email
//        do {
//            try self.context.save()
//        } catch  {
//            print("Failed to save new person into database")
//        }
//        self.fetchPerson()
        
        if(!personExist){
            outputLabel.text = "The person has been added."
        }
    }
    
    @IBAction func findPerson(_ sender: Any) {
        print("find person")
        let firstName: String  = firstNameInput.text ?? ""
        let lastName: String = lastNameInput.text ?? ""
        if(firstName == "" && lastName == ""){
            outputLabel.text = "Error: FirstName and LastName cannot be null."
            return
        }
        
        for person in allPersons{
            if(person.firstName!.lowercased() == firstName.lowercased() && person.lastName!.lowercased() == lastName.lowercased()){
                outputLabel.text = person.description
                genderInput.text = person.gender; roleInput.text = person.role; degreeInput.text = person.degree; fromWhereInput.text  = person.whereFrom; hobbyInput.text = person.hobby; languageInput.text = person.language; teamInput.text = person.team; emailInput.text = person.email;
                return
            }
        }
        outputLabel.text = "The person was not found."
    }
}

extension InformationViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
