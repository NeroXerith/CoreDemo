//
//  Family+CoreDataProperties.swift
//  CoreDemo
//
//  Created by Biene Bryle Sanico on 3/19/25.
//
//

import Foundation
import CoreData


extension Family {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Family> {
        return NSFetchRequest<Family>(entityName: "Family")
    }

    @NSManaged public var name: String?
    @NSManaged public var people: NSSet?

}

// MARK: Generated accessors for people
extension Family {

    @objc(addPeopleObject:)
    @NSManaged public func addToPeople(_ value: Person)

    @objc(removePeopleObject:)
    @NSManaged public func removeFromPeople(_ value: Person)

    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)

}

extension Family : Identifiable {

}
