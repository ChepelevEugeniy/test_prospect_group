//
//  PhotoObject+CoreDataProperties.swift
//  
//
//  Created by Maxim Biriukov on 6/15/18.
//
//

import Foundation
import CoreData


extension PhotoObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoObject> {
        return NSFetchRequest<PhotoObject>(entityName: "PhotoObject")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var url: URL?
    @NSManaged public var thumbnailURL: URL?
    @NSManaged public var albumID: String?

}
