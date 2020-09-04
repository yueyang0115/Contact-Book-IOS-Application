//
//  DukePerson+CoreDataClass.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/2/20.
//  Copyright © 2020 ECE564. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DukePerson)
public class DukePerson: NSManagedObject {
    
    convenience init(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: String, language: String, team: String, email: String){
        //self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.init()
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
    
    public override var description: String {
        let lineOne: String = "\(self.firstName!) \(self.lastName!) is a \((self.role!).lowercased()) at Duke University."
        var lineTwo: String = ""
        if(self.whereFrom != ""){
            lineTwo = "\((transferGender(gender: self.gender!)).capitalized) is from \(self.whereFrom!)."
        }
        var lineThree = ""
        if(self.degree != "N/A"){
            lineThree = "\((transferGender(gender: self.gender!)).capitalized) is in \(self.degree!) program."
        }
        var lineFour = ""
        if(self.hobby != ""){
            lineFour = "\((getPrep(gender: self.gender!)).capitalized) hobby includes \(getHobby(hobby: self.hobby!))."
        }
        var lineFive = ""
        if(self.language != ""){
            lineFive = "\((getPrep(gender: self.gender!)).capitalized) language includes \(getLanguage(language: self.language!))."
        }
        
        let info: String = "\(lineOne) \(lineTwo) \(lineThree) \(lineFour) \(lineFive)"
        return info
    }
    
    func transferGender(gender: String)->String{
        if(gender == "Female"){ return "she" }
        else{ return "he" }
    }
    func getPrep(gender: String)->String{
        if(gender == "Female"){ return "her" }
        else{ return "his" }
    }
    
    func getProgram(program: String)->String{
        return program
    }
    func getHobby(hobby: String)->String{
        return hobby
    }
    func getLanguage(language: String)->String{
        return language
    }
}
