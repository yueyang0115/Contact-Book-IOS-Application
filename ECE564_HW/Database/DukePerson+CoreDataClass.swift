//
//  DukePerson+CoreDataClass.swift
//  ECE564_HW
//
//  Created by 杨越 on 10/2/20.
//  Copyright © 2020 ECE564. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

enum InfoKey: String, CodingKey {
    case firstNameK = "firstname"
    case lastNameK = "lastname"
    case whereFromK = "wherefrom"
    case genderK = "gender"
    case roleK = "role"
    case degreeK = "degree"
    case hobbyK = "hobbies"
    case languageK = "languages"
    case teamK = "team"
    case emailK = "email"
    case imageK = "picture"
    case idK = "id"
    case netidK = "netid"
    case departmentK = "department"
}

@objc(DukePerson)
public class DukePerson: NSManagedObject, Codable {
    // decodable
    required convenience public init(from decoder: Decoder) {
        
        guard let appDel:AppDelegate = UIApplication.shared.delegate as? AppDelegate else{ fatalError() }
        let context = appDel.persistentContainer.viewContext
        
        self.init(context: context)
        let container = try! decoder.container(keyedBy: InfoKey.self)
        self.firstName = try! container.decodeIfPresent(String.self, forKey: .firstNameK)
        self.lastName = try! container.decodeIfPresent(String.self, forKey: .lastNameK)
        self.whereFrom = try! container.decodeIfPresent(String.self, forKey: .whereFromK)
        self.gender = try! container.decodeIfPresent(String.self, forKey: .genderK)
        self.role = try! container.decodeIfPresent(String.self, forKey: .roleK)
        self.degree = try! container.decodeIfPresent(String.self, forKey: .degreeK)
        self.hobby = try! container.decodeIfPresent([String].self, forKey: .hobbyK)
        self.language = try! container.decodeIfPresent([String].self, forKey: .languageK)
        self.team = try! container.decodeIfPresent(String.self, forKey: .teamK)
        self.email = try! container.decodeIfPresent(String.self, forKey: .emailK)
        self.image = try! container.decodeIfPresent(String.self, forKey: .imageK)
        self.id = try! container.decodeIfPresent(String.self, forKey: .idK)
        self.netid = try! container.decodeIfPresent(String.self, forKey: .netidK)
        self.department = try! container.decodeIfPresent(String.self, forKey: .departmentK)
    }
    
    // encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: InfoKey.self)
        try container.encode(firstName, forKey: .firstNameK)
        try container.encode(lastName, forKey: .lastNameK)
        try container.encode(whereFrom, forKey: .whereFromK)
        try container.encode(gender, forKey: .genderK)
        try container.encode(role, forKey: .roleK)
        try container.encode(degree, forKey: .degreeK)
        try container.encode(hobby, forKey: .hobbyK)
        try container.encode(language, forKey: .languageK)
        try container.encode(team, forKey: .teamK)
        try container.encode(email, forKey: .emailK)
        try container.encode(image, forKey: .imageK)
        try container.encode(id, forKey: .idK)
        try container.encode(netid, forKey: .netidK)
        try container.encode(department, forKey: .departmentK)
    }
    
    convenience init(firstName: String, lastName: String, whereFrom: String, gender: String, role: String, degree: String, hobby: [String], language: [String], team: String, email: String, image: String, id: String, netid: String, department: String){
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
        self.image = image
        self.id = id
        self.netid = netid
        self.department = department
    }

    public override var description: String {
        let lineOne: String = "\(self.firstName!) \(self.lastName!) is a \((self.role!).lowercased()) at Duke University."
        var lineTwo: String = ""
        if(self.whereFrom != ""){
            lineTwo = "\((transferGender(gender: self.gender!)).capitalized) is from \(self.whereFrom!)."
        }
        var lineThree = ""
        if(self.degree != ""){
            lineThree = "\((transferGender(gender: self.gender!)).capitalized) is in \(self.degree!) program."
        }
        var lineThreeHalf = ""
        if(self.department != ""){
            lineThreeHalf = "\((transferGender(gender: self.gender!)).capitalized) is in \(self.department!) department."
        }
        var lineFour = ""
        if(self.hobby?.count != 0 && (getHobby(hobby: self.hobby!) != "")){
            lineFour = "\((transferGender(gender: self.gender!)).capitalized) likes \(getHobby(hobby: self.hobby!))."
        }
        var lineFive = ""
        if(self.language?.count != 0 && (getLanguage(language: self.language!) != "")){
            lineFive = "\((getPrep(gender: self.gender!)).capitalized) language includes \(getLanguage(language: self.language!))."
        }
        
        let info: String = "\(lineOne) \(lineTwo) \(lineThree) \(lineThreeHalf) \(lineFour) \(lineFive)"
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
    func getHobby(hobby: [String])->String{
        let joined = hobby.joined(separator: ", ")
        return joined
    }
    func getLanguage(language: [String])->String{
        let joined = language.joined(separator: ", ")
        return joined
    }
}
