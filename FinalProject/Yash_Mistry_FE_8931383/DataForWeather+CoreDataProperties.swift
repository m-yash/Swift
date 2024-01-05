//
//  DataForWeather+CoreDataProperties.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/11/23.
//
//

import Foundation
import CoreData


extension DataForWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataForWeather> {
        return NSFetchRequest<DataForWeather>(entityName: "DataForWeather")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var datetime: String?
    @NSManaged public var humidity: Int32
    @NSManaged public var sourceOfTransaction: String?
    @NSManaged public var temperature: Int32
    @NSManaged public var timeStamp: Date?
    @NSManaged public var typeOfInteraction: String?
    @NSManaged public var wind: Double

}

extension DataForWeather : Identifiable {

}
