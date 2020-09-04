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
    @IBOutlet weak var userImage: UIImageView!
    // pickerView-related
    let genders = ["Female", "Male"]
    var genderPickerView = UIPickerView()
    let roles = ["Student", "Professor", "Teaching Assistant"]
    var rolePickerView = UIPickerView()
    
    // database-related
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // get all persons form database
    var allPersons = [DukePerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureField()
        clearDB()
        addDefaultPersonInDB()
        fetchAllPersonFromDB()
    }
    
    func configureField(){
        firstNameInput.delegate = self; lastNameInput.delegate = self; fromWhereInput.delegate = self; degreeInput.delegate = self; hobbyInput.delegate = self; languageInput.delegate = self
        genderInput.delegate = self; roleInput.delegate = self;
        teamInput.delegate = self; emailInput.delegate = self
        
        findButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        outputLabel.lineBreakMode = .byWordWrapping
        outputLabel.numberOfLines = 0
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderInput.inputView = genderPickerView
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        roleInput.inputView = rolePickerView
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
        addPersonToDB(firstName: "Yue", lastName: "Yang", whereFrom: "China", gender: "Female", role: "Student", degree: "Grad", hobby: "reading", language: "swift", team: "ece564", email: "yy258@duke.edu")
        addPersonToDB(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County", gender: "Male", role: "professor", degree: "N/A", hobby: "teaching", language: "swift", team: "ece564", email: "rt113@duke.edu")
        addPersonToDB(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", role: "teaching assistant", degree: "Grad", hobby: "reading books, jogging", language: "swift, java", team: "ece564", email: "hz147@duke.edu")
        addPersonToDB(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", role: "teaching assistant", degree: "Grad", hobby: "Dancing", language: "Java, cpp", team: "ece564", email: "yy227@duke.edu")
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
    // addButton handler
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
        if(gender == ""){
            outputLabel.text = "Error: Please choose your gender."
            return
        }
        if(role == ""){
            outputLabel.text = "Error: Please choose your role."
            return
        }
        if(gender != "Female" && gender != "Male"){
            outputLabel.text = "Error: Illegal gender."
            return
        }
        if(role != "Student" && role != "Professor" && role != "Teaching Assistant"){
            outputLabel.text = "Error: Illegal role."
            return
        }

        var personExist: Bool = false
        for person in allPersons{
            if(person.firstName!.lowercased() == firstName.lowercased() && person.lastName!.lowercased() == lastName.lowercased()){
                personExist = true
                outputLabel.text = "The person has been updated."
                deletePersonFromDB(person: person)
                break
            }
        }
        
        addPersonToDB(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, degree: degree, hobby: hobby, language: language, team: team, email: email)

        if(!personExist){
            outputLabel.text = "The person has been added."
        }
    }
    
    // findButton handler
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
                
                displayUserImage(firstName: firstName, lastName: lastName)
                return
            }
        }
        outputLabel.text = "The person was not found."
    }
    
    // display userImage
    func displayUserImage(firstName: String, lastName: String){
        if(firstName.lowercased() == "yue" && lastName.lowercased() == "yang"){
            userImage.image = UIImage(named: "yue")!
        }
        else if(firstName.lowercased() == "ric" && lastName.lowercased() == "telford"){
            userImage.image = UIImage(named: "ric")!
        }
        else{
            userImage.image = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
        }
    }
}

// MARK: - extension
extension InformationViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InformationViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == genderPickerView){
            return genders.count
        }
        else{
            return roles.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == genderPickerView){
            return genders[row]
        }
        else{
            return roles[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == genderPickerView){
            genderInput.text = genders[row]
            genderInput.resignFirstResponder()
        }
        else{
            roleInput.text = roles[row]
            roleInput.resignFirstResponder()
        }
    }
    
}
