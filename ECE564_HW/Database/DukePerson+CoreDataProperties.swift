//
//  DukePerson+CoreDataProperties.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/10/20.
//  Copyright © 2020 ECE564. All rights reserved.
//
//

import Foundation
import CoreData

protocol ECE564 {
     var hobby : [String]?   {get}
     var language : [String]?    {get}
}

extension DukePerson : ECE564{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DukePerson> {
        return NSFetchRequest<DukePerson>(entityName: "DukePerson")
    }

    @NSManaged public var degree: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gender: String?
    @NSManaged public var hobby: [String]?
    @NSManaged public var language: [String]?
    @NSManaged public var lastName: String?
    @NSManaged public var role: String?
    @NSManaged public var team: String?
    @NSManaged public var whereFrom: String?
    @NSManaged public var image: Data?

}
