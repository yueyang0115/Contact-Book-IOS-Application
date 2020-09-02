//
//  DataModel.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/2/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import Foundation

//enum Gender : String {
//    case Male = "Male"
//    case Female = "Female"
//}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"
    var gender : String = "Male"
}

//enum DukeRole : String {
//    case Student = "Student"
//    case Professor = "Professor"
//    case TA = "Teaching Assistant"
//}

//enum DukeProgram : String {
//    case Undergrad = "Undergrad"
//    case Grad = "Grad"
//    case NA = "Not Applicable"
//}

// create DukePerson class
class DukePerson : Person, CustomStringConvertible {

    var role : String = "student"
    var degree : String = "Not Applicable"
    var hobby: String = ""
    var language: String = ""
    var team: String = ""
    var email: String = ""
    
    var description : String {
        let lineOne: String = "\(self.firstName) \(self.lastName) is a \(getProgram(program: self.degree))\(self.role.lowercased()) at Duke University."
        var lineTwo: String = ""
        if(self.whereFrom != ""){
            lineTwo = "\((transferGender(gender: self.gender)).capitalized) is from \(self.whereFrom)."
        }
        let info: String = "\(lineOne) \(lineTwo)"
        
        return info
    }
    
    override init(){
        super.init()
    }
    
    init(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: String, language: String, team: String, email: String){
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.role = role
        self.degree = degree
        self.hobby = hobby
        self.language = language
        self.team = team
        self.email = email
    }
    
    func transferGender(gender: String)->String{
        if(gender == "Female"){ return "she" }
        else{ return "he" }
    }
    
    func getProgram(program: String)->String{
        return program
    }
    
}
