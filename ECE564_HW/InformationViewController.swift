//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by yueyang on 9/1/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class InformationViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
//    @IBOutlet weak var outputLabel: UILabel!
    // picture-related
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    
    // pickerView-related
    let genders = ["Female", "Male"]
    var genderPickerView = UIPickerView()
    let roles = ["Student", "Professor", "Teaching Assistant"]
    var rolePickerView = UIPickerView()
    
    // database-related
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // segue-related
    let defaultImage = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var naviBar: UINavigationItem!
    var segueType: String = ""
    var edittedPerson: DukePerson?
    
    // MARK: - load view and settings
    override func viewDidLoad() {
        super.viewDidLoad()
        configureField()
        if(segueType == "addSegue"){
            saveButton.title = "Save"
            naviBar.title = "Add New Person"
        }
        else if(segueType == "editSegue"){
            saveButton.title = "Edit"
            naviBar.title = "View Person Only"
            //fill textField with provided person info
            fillExistedPerson()
            // disable textField input
            setTextFieldInput(bool: false)
        }
    }
    
    func configureField(){
        firstNameInput.delegate = self; lastNameInput.delegate = self; fromWhereInput.delegate = self; degreeInput.delegate = self; hobbyInput.delegate = self; languageInput.delegate = self
        genderInput.delegate = self; roleInput.delegate = self;
        teamInput.delegate = self; emailInput.delegate = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderInput.inputView = genderPickerView
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        roleInput.inputView = rolePickerView
        
        pickButton.layer.cornerRadius = 5
        pickButton.layer.borderWidth = 2
        pickButton.layer.borderColor = UIColor.systemBlue.cgColor
        pickButton.addTarget(self, action: #selector(InformationViewController.choosePic(_:)), for: .touchUpInside)
        
        userImage.image = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
    }
    
    // fill textField with provided person info
    func fillExistedPerson(){
        if(edittedPerson != nil){
            firstNameInput.text = edittedPerson!.firstName; lastNameInput.text = edittedPerson!.lastName; fromWhereInput.text = edittedPerson!.whereFrom; degreeInput.text = edittedPerson!.degree; hobbyInput.text = edittedPerson!.getHobby(hobby: edittedPerson!.hobby!); languageInput.text = edittedPerson!.getLanguage(language: edittedPerson!.language!); genderInput.text = edittedPerson!.gender; roleInput.text = edittedPerson!.role; teamInput.text = edittedPerson!.team; emailInput.text = edittedPerson!.email; userImage.image = UIImage(data: edittedPerson!.image!)
            if(edittedPerson!.image! == defaultImage!.pngData()){
                userImage.image = defaultImage
            }
        }
    }
    
    // enable or disable textField input
    func setTextFieldInput(bool: Bool){
        firstNameInput.isUserInteractionEnabled = bool; lastNameInput.isUserInteractionEnabled = bool; fromWhereInput.isUserInteractionEnabled = bool; genderInput.isUserInteractionEnabled = bool; roleInput.isUserInteractionEnabled = bool; degreeInput.isUserInteractionEnabled = bool; hobbyInput.isUserInteractionEnabled = bool; languageInput.isUserInteractionEnabled = bool; emailInput.isUserInteractionEnabled = bool; teamInput.isUserInteractionEnabled = bool;
        pickButton.isHidden = !bool
    }
    
    
    // MARK: - database-related operations
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
//    func displayUserImage(firstName: String, lastName: String){
//        if(firstName.lowercased() == "yue" && lastName.lowercased() == "yang"){
//            userImage.image = UIImage(named: "yue")!
//        }
//        else if(firstName.lowercased() == "ric" && lastName.lowercased() == "telford"){
//            userImage.image = UIImage(named: "ric")!
//        }
//        else{
//            userImage.image = UIImage(systemName: "person.crop.circle.fill.badge.exclam")
//        }
//    }
    
    // MARK: - function handler
    @IBAction func isPressed(_ sender: Any) {
        // press edit
        if(saveButton.title == "Edit"){
            saveButton.title = "Save"
            naviBar.title = "Edit Person"
            setTextFieldInput(bool: true)
        }
        else if(saveButton.title == "Save"){
            // pure add person
            if(edittedPerson == nil) {
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
        var warning: String = ""
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
            warning = "Error: FirstName and LastName cannot be null."
            return
        }
        if(gender == ""){
            warning = "Error: Please choose your gender."
            return
        }
        if(role == ""){
            warning = "Error: Please choose your role."
            return
        }
        if(gender != "Female" && gender != "Male"){
            warning = "Error: Illegal gender."
            return
        }
        if(role != "Student" && role != "Professor" && role != "Teaching Assistant"){
            warning = "Error: Illegal role."
            return
        }
        
        //split hobbies and languages to [String]
        let hobbies: [String] = hobby.components(separatedBy: ",")
        let languages: [String] = language.components(separatedBy: ",")
        let imageData: Data = userImage.image!.pngData()!
        addPersonToDB(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, degree: degree, hobby: hobbies, language: languages, team: team, email: email, image: imageData)

    }
    
    
    // MARK: imagePicker delegate calls
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let im = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage

        self.dismiss(animated: true) {
            let type = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String
            if type != nil {
                switch type! {
                case kUTTypeImage as NSString as String:
                    if im != nil {
                        self.userImage.image = im
                        self.userImage.contentMode = .scaleAspectFit
                    }
                default:break
                }
            }
        }
    }
    
    @objc func choosePic(_ sender: AnyObject) {
        let lib = UIImagePickerController.SourceType.photoLibrary
        let ok = UIImagePickerController.isSourceTypeAvailable(lib)
        if (!ok) {
            print("error")
            return
        }
        let desiredType = kUTTypeImage as NSString as String
        let arr = UIImagePickerController.availableMediaTypes(for: lib)
        print(arr!)
        if arr?.firstIndex(of: desiredType) == nil {
            print("error")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [desiredType]
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
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

// MARK: - extension and image helper
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
