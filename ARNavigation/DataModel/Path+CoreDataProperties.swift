//
//  Path+CoreDataProperties.swift
//  ARNavigation
//
//  Created by ck on 2023/3/21.
//
//

import Foundation
import CoreData


extension Path {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Path> {
        return NSFetchRequest<Path>(entityName: "Path")
    }

    @NSManaged public var anglediff: [NSNumber]?
    @NSManaged public var direction: [String]?
    @NSManaged public var initdirection: Float
    @NSManaged public var pathdescription: String?
    @NSManaged public var pathname: String?
    @NSManaged public var position: [[NSNumber]]?
    @NSManaged public var timestamp: Date?
    @NSManaged public var pathlength: Int16
    
    

}

extension Path : Identifiable {

}
