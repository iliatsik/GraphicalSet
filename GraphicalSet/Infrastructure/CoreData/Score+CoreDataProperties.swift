//
//  Score+CoreDataProperties.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 09.03.22.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var score: Int16
    @NSManaged public var date: String?

}

extension Score : Identifiable {

}
