//
//	Flight.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import CoreData

class Flight : NSManagedObject{

	@NSManaged var statistic : Statistic!
	@NSManaged var cancelled : Int32
	@NSManaged var delayed : Int32
	@NSManaged var diverted : Int32
	@NSManaged var ontime : Int32
	@NSManaged var total : Int32


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    convenience init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
        let entity = NSEntityDescription.entity(forEntityName: "Flight", in: context)!
        self.init(entity: entity, insertInto: context)

		if let statisticData = dictionary["statistic"] as? [String:Any]{
			statistic = Statistic(fromDictionary: statisticData, context:context)
		}
		if let cancelledValue = dictionary["cancelled"] as? Int{
			cancelled = Int32(cancelledValue)
		}
		if let delayedValue = dictionary["delayed"] as? Int{
			delayed = Int32(delayedValue)
		}
		if let divertedValue = dictionary["diverted"] as? Int{
			diverted = Int32(divertedValue)
		}
		if let ontimeValue = dictionary["ontime"] as? Int{
			ontime = Int32(ontimeValue)
		}
		if let totalValue = dictionary["total"] as? Int{
			total = Int32(totalValue)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if statistic != nil{
			dictionary["statistic"] = statistic.toDictionary()
		}
		dictionary["cancelled"] = cancelled
		dictionary["delayed"] = delayed
		dictionary["diverted"] = diverted
		dictionary["ontime"] = ontime
		dictionary["total"] = total
		return dictionary
	}

}
