//
//  DataForMaps+CoreDataProperties.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/11/23.
//
//

import Foundation
import CoreData


extension DataForMaps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataForMaps> {
        return NSFetchRequest<DataForMaps>(entityName: "DataForMaps")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var distanceTravelled: Double
    @NSManaged public var endPoint: String?
    @NSManaged public var modeOfTravel: String?
    @NSManaged public var sourceOfTransaction: String?
    @NSManaged public var startPoint: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var typeOfInteraction: String?

}

extension DataForMaps : Identifiable {

}
