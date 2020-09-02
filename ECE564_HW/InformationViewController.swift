//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by yueyang on 9/1/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var roleInput: UITextField!
    @IBOutlet weak var fromWhereInput: UITextField!
    @IBOutlet weak var degreeInput: UITextField!
    
    @IBOutlet weak var hobbyInput: UITextField!
    @IBOutlet weak var languageInput: UITextField!
    @IBOutlet weak var teamInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var testPersons = [DukePerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        // Do any additional setup after loading the view.
    }
    
    private func configureTextField(){
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        fromWhereInput.delegate = self
        degreeInput.delegate = self
        hobbyInput.delegate = self
        languageInput.delegate = self
        
        genderInput.delegate = self
        roleInput.delegate = self
        
        teamInput.delegate = self
        emailInput.delegate = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
        for i in 0...testPersons.count-1{
            if(testPersons[i].firstName.lowercased() == firstName.lowercased() && testPersons[i].lastName.lowercased() == lastName.lowercased()){
                personExist = true
                outputLabel.text = "The person has been updated."
                testPersons.remove(at: i)
                break
            }
        }
        let newPerson = DukePerson(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, degree: degree, hobby: hobby, language: language, team: team, email: email)
        testPersons.append(newPerson)
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
        
        for person in testPersons{
            if(person.firstName.lowercased() == firstName.lowercased() && person.lastName.lowercased() == lastName.lowercased()){
                outputLabel.text = person.description
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
