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
    @IBOutlet weak var netIDInput: UITextField!
    @IBOutlet weak var departmentInput: UITextField!
    @IBOutlet weak var idInput: UITextField!
    
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
        // if come from addSegue
        if(segueType == "addSegue"){
            saveButton.title = "Save"
            naviBar.title = "Add New Person"
        }
        // if come from editSegue
        else if(segueType == "editSegue"){
            saveButton.title = "Edit"
            naviBar.title = "View Person Only"
            fillExistedPerson() // fill textField with provided person info
            setTextFieldInput(bool: false) // disable textField input
        }
    }
    
    func configureField(){
        firstNameInput.delegate = self; lastNameInput.delegate = self; fromWhereInput.delegate = self; degreeInput.delegate = self; hobbyInput.delegate = self; languageInput.delegate = self
        genderInput.delegate = self; roleInput.delegate = self;
        teamInput.delegate = self; emailInput.delegate = self;
        netIDInput.delegate = self; departmentInput.delegate = self;
        idInput.delegate = self;
        
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
            firstNameInput.text = edittedPerson!.firstName; lastNameInput.text = edittedPerson!.lastName; fromWhereInput.text = edittedPerson!.whereFrom; degreeInput.text = edittedPerson!.degree; hobbyInput.text = edittedPerson!.getHobby(hobby: edittedPerson!.hobby!); languageInput.text = edittedPerson!.getLanguage(language: edittedPerson!.language!); genderInput.text = edittedPerson!.gender; roleInput.text = edittedPerson!.role; teamInput.text = edittedPerson!.team; emailInput.text = edittedPerson!.email; netIDInput.text = edittedPerson!.netid;
                departmentInput.text = edittedPerson!.department; idInput.text = edittedPerson!.id
            //userImage.image = UIImage(data: edittedPerson!.image!)
            
            let dataDecoded : Data = Data(base64Encoded: edittedPerson!.image!, options: .ignoreUnknownCharacters)!
            userImage.image = UIImage(data: dataDecoded)
            
            if(dataDecoded == defaultImage!.pngData()){
                userImage.image = defaultImage
            }
        }
    }
    
    // enable or disable textField input
    func setTextFieldInput(bool: Bool){
        firstNameInput.isUserInteractionEnabled = bool; lastNameInput.isUserInteractionEnabled = bool; fromWhereInput.isUserInteractionEnabled = bool; genderInput.isUserInteractionEnabled = bool; roleInput.isUserInteractionEnabled = bool; degreeInput.isUserInteractionEnabled = bool; hobbyInput.isUserInteractionEnabled = bool; languageInput.isUserInteractionEnabled = bool; emailInput.isUserInteractionEnabled = bool; teamInput.isUserInteractionEnabled = bool;
            netIDInput.isUserInteractionEnabled = bool; departmentInput.isUserInteractionEnabled = bool;
            idInput.isUserInteractionEnabled = bool
        pickButton.isHidden = !bool
    }
    
    
    // MARK: - database-related operations
    // add one person to database
    func addPersonToDB(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: [String], language: [String], team: String, email: String, image: String, id: String, netid: String, department: String){
        let newPerson = DukePerson(context: self.context)
        newPerson.firstName = firstName; newPerson.lastName = lastName; newPerson.whereFrom = whereFrom; newPerson.gender = gender; newPerson.role = role; newPerson.degree = degree; newPerson.hobby = hobby; newPerson.language = language; newPerson.team = team; newPerson.email = email; newPerson.image = image; newPerson.id = id; newPerson.netid = netid; newPerson.department = department
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
    
    
    // MARK: - edit/save person
    // when saveButton is pressed
    @IBAction func isPressed(_ sender: Any) {
        // change from edit to save
        if(saveButton.title == "Edit"){
            saveButton.title = "Save"
            naviBar.title = "Edit Person"
            setTextFieldInput(bool: true) // enable textField input
        }
        // save person and try exit
        else if(saveButton.title == "Save"){
            var canExit: Bool = false;
            // only add new person
            if(edittedPerson == nil) {
                canExit = savePerson()
            }
            // edit existed person
            else{
                let firstName: String  = firstNameInput.text ?? ""
                let lastName: String = lastNameInput.text ?? ""
                if(firstName == edittedPerson!.firstName && lastName == edittedPerson!.lastName){
                    deletePersonFromDB(person: edittedPerson!)
                }
                canExit = savePerson()
            }
            //if can exit
            if(canExit){
                performSegue(withIdentifier: "returnSegue", sender: self)
            }
        }
    }
    
    // if person info valid, return true and save person, otherwise return false and pop up alert
    func savePerson() -> Bool{
        // read input
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
        let netID: String = netIDInput.text ?? ""
        var id: String = idInput.text ?? ""
        let department: String = departmentInput.text ?? ""
        
        // check person info valid or not
        if(firstName == "" && lastName == ""){
            displayErrorAlert(error: "FirstName and LastName cannot be null.")
            return false
        }
        if(netID == ""){
            displayErrorAlert(error: "netID cannot be null.")
            return false
        }
        if(gender == ""){
            displayErrorAlert(error: "Please choose your gender.")
            return false
        }
        if(role == ""){
            displayErrorAlert(error: "Please choose your role.")
            return false
        }
        if(gender != "Female" && gender != "Male"){
            displayErrorAlert(error: "Illegal gender.")
            return false
        }
        if(role != "Student" && role != "Professor" && role != "Teaching Assistant"){
            displayErrorAlert(error: "Illegal role.")
            return false
        }
        if(id == ""){
            id = netID
        }
        
        //split hobbies and languages to [String]
        let hobbies: [String] = hobby.components(separatedBy: ",")
        let languages: [String] = language.components(separatedBy: ",")
        //var imageData: Data = userImage.image!.pngData()!
        let imageData: Data = resizeImage(image: userImage.image!, targetSize: CGSize(width: 100, height: 100)).pngData()!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        // add person to database
        addPersonToDB(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, degree: degree, hobby: hobbies, language: languages, team: team, email: email, image: strBase64, id: id, netid: netID, department: department)
                
        // encode newly added person to JSON
        do{
            let persons: [DukePerson] = try context.fetch(DukePerson.fetchRequest())
            for person in persons{
                if(person.firstName!.lowercased() == firstName.lowercased() &&
                    person.lastName!.lowercased() == lastName.lowercased()){
                    //let encodeSucceed:Bool = saveJsonInfo(person: person)
                    //print("encode succeed: \(encodeSucceed)")
                }
            }
        }
        catch let error as NSError {
            print("When encode newly added person, failed to get all persons from database")
            print(error)
        }
        
        return true;
    }
    
    // transfer DukePerson class to JSON
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
    
    // pop up alert if person info invalid
    func displayErrorAlert(error: String){
        let alert = UIAlertController(title: "Cannot Save Person", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: imagePicker-related
    // resize image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

// MARK: - extension: textField, pick image, PickerView
// dismiss keyboard
extension InformationViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// set up pickerView
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

// set up image picker
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
