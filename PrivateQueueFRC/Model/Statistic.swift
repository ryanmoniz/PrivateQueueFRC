//
//	Statistic.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import CoreData

class Statistic : NSManagedObject{

	@NSManaged var rootClass : RootClass!
	@NSManaged var ofdelays : Delay!
	@NSManaged var flights : Flight!
	@NSManaged var minutesDelayed : MinutesDelayed!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    convenience init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
        let entity = NSEntityDescription.entity(forEntityName: "Statistic", in: context)!
        self.init(entity: entity, insertInto: context)
        
        
		if let rootClassData = dictionary["rootClass"] as? [String:Any]{
			rootClass = RootClass(fromDictionary: rootClassData, context:context)
		}
		if let ofdelaysData = dictionary["# of delays"] as? [String:Any]{
			ofdelays = Delay(fromDictionary: ofdelaysData, context:context)
		}
		if let flightsData = dictionary["flights"] as? [String:Any]{
			flights = Flight(fromDictionary: flightsData, context:context)
		}
		if let minutesdelayedData = dictionary["minutes delayed"] as? [String:Any]{
			minutesDelayed = MinutesDelayed(fromDictionary: minutesdelayedData, context:context)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if rootClass != nil{
			dictionary["rootClass"] = rootClass.toDictionary()
		}
		if ofdelays != nil{
			dictionary["# of delays"] = ofdelays.toDictionary()
		}
		if flights != nil{
			dictionary["flights"] = flights.toDictionary()
		}
		if minutesDelayed != nil{
			dictionary["minutes delayed"] = minutesDelayed.toDictionary()
		}
		return dictionary
	}

}
