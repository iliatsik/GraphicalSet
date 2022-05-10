//
//  Score+CoreDataProperties.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 18.03.22.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var date: String?
    @NSManaged public var score: Int16

}

extension Score : Identifiable {

}
