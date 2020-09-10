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
    @IBOutlet weak var userImage: UIImageView!
    
    // pickerView-related
    let genders = ["Female", "Male"]
    var genderPickerView = UIPickerView()
    let roles = ["Student", "Professor", "Teaching Assistant"]
    var rolePickerView = UIPickerView()
    
    // database-related
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // segue-related
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var segueType: String = ""
    var edittedPerson: DukePerson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureField()
        if(segueType == "addSegue"){
            saveButton.title = "Save"
        }
        else if(segueType == "editSegue"){
            saveButton.title = "Edit"
            //fill textField
            fillExistedPerson()
        }
    }
    
    func fillExistedPerson(){
        if(edittedPerson != nil){
            firstNameInput.text = edittedPerson!.firstName; lastNameInput.text = edittedPerson!.lastName; fromWhereInput.text = edittedPerson!.whereFrom; degreeInput.text = edittedPerson!.degree; hobbyInput.text = edittedPerson!.getHobby(hobby: edittedPerson!.hobby!); languageInput.text = edittedPerson!.getLanguage(language: edittedPerson!.language!); genderInput.text = edittedPerson!.gender; roleInput.text = edittedPerson!.role; teamInput.text = edittedPerson!.team; emailInput.text = edittedPerson!.email
        }
    }
    
    func configureField(){
        firstNameInput.delegate = self; lastNameInput.delegate = self; fromWhereInput.delegate = self; degreeInput.delegate = self; hobbyInput.delegate = self; languageInput.delegate = self
        genderInput.delegate = self; roleInput.delegate = self;
        teamInput.delegate = self; emailInput.delegate = self
        
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
        //self.fetchAllPersonFromDB()
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
        //self.fetchAllPersonFromDB()
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
    
    // MARK: - ButtonHandler
    @IBAction func isPressed(_ sender: Any) {
        // press edit
        if(saveButton.title == "Edit"){
            saveButton.title = "Save"
            // enable textField
        }
        
        else if(saveButton.title == "Save"){
            // pure add person
            if(edittedPerson == nil) {
                print("get into add pure save")
                savePerson()
            }
            // replace old person
            else{
                let firstName: String  = firstNameInput.text ?? ""
                let lastName: String = lastNameInput.text ?? ""
                if(firstName == edittedPerson!.firstName && lastName == edittedPerson!.lastName){
                    deletePersonFromDB(person: edittedPerson!)
                }
                savePerson()
            }
            //exit
            performSegue(withIdentifier: "returnSegue", sender: self)
        }
    }
    
    
    func savePerson(){
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
        
        //split hobbies and languages to [String]
        let hobbies: [String] = hobby.components(separatedBy: ",")
        let languages: [String] = language.components(separatedBy: ",")

        addPersonToDB(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, degree: degree, hobby: hobbies, language: languages, team: team, email: email)

    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
//    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
//        if((sender as! UIBarButtonItem) != self.saveButton){
//            return
//        }
//        //savePerson()
//    }
    
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
