//: This is the playground file to use for submitting HW1.  You will add your code where noted below.  Make sure you only put the code required at load time in the ``loadView()`` method.  Other code should be set up as additional methods (such as the code called when a button is pressed).
  
import UIKit
import PlaygroundSupport

enum Gender : String {
    case Male = "Male"
    case Female = "Female"
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

enum DukeProgram : String {
    case Undergrad = "Undergrad"
    case Grad = "Grad"
    case NA = "Not Applicable"
}

// You can add code here

// create DukePerson class
class DukePerson : Person, CustomStringConvertible {
    var role : DukeRole = .Student
    var program :DukeProgram = .NA
    var description : String {
        let basicInfo : String = firstName + " " + lastName + " : a " + role.rawValue + " from " + whereFrom
        return basicInfo
    }
    
    override init(){
        super.init()
    }
    
    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, role: DukeRole, program: DukeProgram)
    {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.role = role
        self.program = program
    }
}

// use DukePerson Array as database for test
var testPersons = [DukePerson]()
let yueyang = DukePerson(firstName: "Yue", lastName: "Yang", whereFrom: "China", gender: .Female, role: .Student, program: .Grad)
let ric = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: .Male, role: .Professor, program: .NA)
let haohong = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, role: .TA, program: .Grad)
let yuchen = DukePerson(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: .Male, role: .TA, program: .Grad)

testPersons.append(yueyang)
testPersons.append(ric)
testPersons.append(haohong)
testPersons.append(yuchen)

for person in testPersons {
    print(person)
}

// views
class HW1ViewController : UIViewController {
    // self-defined variable
    var firstNameLabel = UILabel()
    var firstNameInput = UITextView()
    var lastNameLabel = UILabel()
    var lastNameInput = UITextView()
    var fromWhereLabel = UILabel()
    var fromWhereInput = UITextView()
    var genderSegment = UISegmentedControl()
    var roleSegment = UISegmentedControl()
    var programSegment = UISegmentedControl()
    let addButton = UIButton()
    let findButton = UIButton()
    var outputLabel = UILabel()
    
    override func loadView() {
// You can change color scheme if you wish
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 10, width: 200, height: 20)
        label.text = "ECE 564 Homework 1"
        label.textColor = .white
        view.addSubview(label)
        self.view = view
        
// You can add code here
        // layout settings
        firstNameLabel.frame = CGRect(x: 50, y: 50, width: 100, height: 40)
        firstNameLabel.text = "First Name:"
        firstNameLabel.textColor = .white
        view.addSubview(firstNameLabel)
        
        firstNameInput.frame = CGRect(x: 170, y: 60, width: 150, height: 20)
        firstNameInput.textColor = .black
        firstNameInput.backgroundColor = .white
        firstNameInput.layer.cornerRadius = 5
        view.addSubview(firstNameInput)
        
        lastNameLabel.frame = CGRect(x: 50, y: 80, width: 100, height: 40)
        lastNameLabel.text = "Last Name:"
        lastNameLabel.textColor = .white
        view.addSubview(lastNameLabel)
        
        lastNameInput.frame = CGRect(x: 170, y: 90, width: 150, height: 20)
        lastNameInput.textColor = .black
        lastNameInput.backgroundColor = .white
        lastNameInput.layer.cornerRadius = 5
        view.addSubview(lastNameInput)
        
        fromWhereLabel.frame = CGRect(x: 50, y: 110, width: 100, height: 40)
        fromWhereLabel.text = "From:"
        fromWhereLabel.textColor = .white
        view.addSubview(fromWhereLabel)
        
        fromWhereInput.frame = CGRect(x: 170, y: 120, width: 150, height: 20)
        fromWhereInput.textColor = .black
        fromWhereInput.backgroundColor = .white
        fromWhereInput.layer.cornerRadius = 5
        view.addSubview(fromWhereInput)
        
        genderSegment.frame = CGRect(x: 50, y: 170, width: 270, height: 30)
        genderSegment.insertSegment(withTitle: "Male", at: 0, animated: true)
        genderSegment.insertSegment(withTitle: "Female", at: 135, animated: true)
        genderSegment.backgroundColor = .systemGray6
        if (genderSegment.selectedSegmentIndex == UISegmentedControl.noSegment) {
            genderSegment.selectedSegmentIndex = 0
        }
        view.addSubview(genderSegment)
        
        
        roleSegment.frame = CGRect(x: 50, y: 210, width: 270, height: 30)
        roleSegment.insertSegment(withTitle: "Prof", at: 0, animated: true)
        roleSegment.insertSegment(withTitle: "TA", at: 60, animated: true)
        roleSegment.insertSegment(withTitle: "Student", at: 120, animated: true)
        roleSegment.backgroundColor = .systemGray6
        if (roleSegment.selectedSegmentIndex == UISegmentedControl.noSegment) {
            roleSegment.selectedSegmentIndex = 2
        }
        view.addSubview(roleSegment)
        
        programSegment.frame = CGRect(x: 50, y: 250, width: 270, height: 30)
        programSegment.insertSegment(withTitle: "Undergrad", at: 0, animated: true)
        programSegment.insertSegment(withTitle: "Grad", at: 60, animated: true)
        programSegment.insertSegment(withTitle: "N/A", at: 120, animated: true)
        programSegment.backgroundColor = .systemGray6
        if (programSegment.selectedSegmentIndex == UISegmentedControl.noSegment) {
            programSegment.selectedSegmentIndex = 2
        }
        view.addSubview(programSegment)
        
        addButton.frame = CGRect(x: 50, y: 310, width: 120, height: 50)
        addButton.layer.cornerRadius = 10
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .systemYellow
        addButton.setTitle("Add/Update", for: .normal)
        addButton.addTarget(self, action: #selector(addPerson), for: .touchUpInside)
        view.addSubview(addButton)
        
        findButton.frame = CGRect(x: 200, y: 310, width: 120, height: 50)
        findButton.layer.cornerRadius = 10
        findButton.setTitleColor(.black, for: .normal)
        findButton.backgroundColor = .systemYellow
        findButton.setTitle("Find", for: .normal)
        findButton.addTarget(self, action: #selector(findPerson), for: .touchUpInside)
        view.addSubview(findButton)
        
        outputLabel.frame = CGRect(x: 50, y: 340, width: 270, height: 40)
        outputLabel.textColor = .white
        view.addSubview(outputLabel)
    
        
    }
    
// You can add code here
    // button handler functions
    
    @objc func addPerson() {
        resignResponse()
        
        let firstName: String  = firstNameInput.text
        let lastName: String = lastNameInput.text
        let fromWhere: String = fromWhereInput.text
        var gender : Gender
        switch genderSegment.selectedSegmentIndex {
            case 0: gender = .Female
            default: gender = .Male; break
        }
        var role : DukeRole
        switch roleSegment.selectedSegmentIndex {
            case 0: role = .Professor
            case 1: role = .TA
            default: role = .Student; break
        }
        var program: DukeProgram
        switch programSegment.selectedSegmentIndex {
            case 0: program = .Undergrad
            case 1: program = .Grad
            default: program = .NA; break
        }
        
        for i in 0...testPersons.count-1{
            if(testPersons[i].firstName == firstNameInput.text && testPersons[i].lastName == lastNameInput.text){
                testPersons.remove(at: i)
                break
            }
        }
        let newPerson = DukePerson(firstName: firstName, lastName: lastName, whereFrom: fromWhere, gender: gender, role: role, program: program)
        testPersons.append(newPerson)
    }
    
    @objc func findPerson() {
        resignResponse()
        for person in testPersons{
            if(person.firstName == firstNameInput.text && person.lastName == lastNameInput.text){
                print(person)
                return
            }
        }
    }
    
    func resignResponse(){
        firstNameInput.resignFirstResponder()
        lastNameInput.resignFirstResponder()
        fromWhereInput.resignFirstResponder()
    }


}
// Don't change the following line - it is what allowsthe view controller to show in the Live View window
PlaygroundPage.current.liveView = HW1ViewController()
