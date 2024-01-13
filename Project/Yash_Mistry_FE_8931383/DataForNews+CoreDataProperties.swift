//
//  DataForNews+CoreDataProperties.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/11/23.
//
//

import Foundation
import CoreData


extension DataForNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataForNews> {
        return NSFetchRequest<DataForNews>(entityName: "DataForNews")
    }

    @NSManaged public var author: String?
    @NSManaged public var cityName: String?
    @NSManaged public var descriptionn: String?
    @NSManaged public var source: String?
    @NSManaged public var sourceOfTransaction: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var typeOfInteraction: String?

}

extension DataForNews : Identifiable {

}
