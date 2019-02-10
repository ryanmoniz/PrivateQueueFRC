//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import CoreData

class RootClass : NSManagedObject{

	@NSManaged var airport : Airport!
	@NSManaged var carrier : Carrier!
	@NSManaged var statistics : Statistic!
	@NSManaged var time : FlightTime!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    convenience init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
        let entity = NSEntityDescription.entity(forEntityName: "RootClass", in: context)!
        self.init(entity: entity, insertInto: context)
        
		if let airportData = dictionary["airport"] as? [String:Any]{
			airport = Airport(fromDictionary: airportData, context:context)
		}
		if let carrierData = dictionary["carrier"] as? [String:Any]{
			carrier = Carrier(fromDictionary: carrierData, context:context)
		}
		if let statisticsData = dictionary["statistics"] as? [String:Any]{
			statistics = Statistic(fromDictionary: statisticsData, context:context)
		}
		if let timeData = dictionary["time"] as? [String:Any]{
			time = FlightTime(fromDictionary: timeData, context:context)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if airport != nil{
			dictionary["airport"] = airport.toDictionary()
		}
		if carrier != nil{
			dictionary["carrier"] = carrier.toDictionary()
		}
		if statistics != nil{
			dictionary["statistics"] = statistics.toDictionary()
		}
		if time != nil{
			dictionary["time"] = time.toDictionary()
		}
		return dictionary
	}

}

extension RootClass {
    @nonobjc class func createFetchRequest() -> NSFetchRequest<RootClass> {
        return NSFetchRequest<RootClass>(entityName: className())
    }
}
