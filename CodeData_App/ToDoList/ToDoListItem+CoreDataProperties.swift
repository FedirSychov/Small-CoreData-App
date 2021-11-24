//
//  ToDoListItem+CoreDataProperties.swift
//  CodeData_App
//
//  Created by Fedor Sychev on 23.11.21.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var created_at: Date?

}

extension ToDoListItem : Identifiable {

}
