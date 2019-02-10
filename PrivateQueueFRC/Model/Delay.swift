//
//	Delay.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import CoreData

class Delay : NSManagedObject{

	@NSManaged var statistic : Statistic!
	@NSManaged var carrier : Int32
	@NSManaged var lateaircraft : Int32
	@NSManaged var nationalaviationsystem : Int32
	@NSManaged var security : Int32
	@NSManaged var weather : Int32


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    convenience init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
        let entity = NSEntityDescription.entity(forEntityName: "Delay", in: context)!
        self.init(entity: entity, insertInto: context)
        
		if let statisticData = dictionary["statistic"] as? [String:Any]{
			statistic = Statistic(fromDictionary: statisticData, context:context)
		}
		if let carrierValue = dictionary["carrier"] as? Int{
			carrier = Int32(carrierValue)
		}
		if let lateaircraftValue = dictionary["late aircraft"] as? Int{
			lateaircraft = Int32(lateaircraftValue)
		}
		if let nationalaviationsystemValue = dictionary["national aviation system"] as? Int{
			nationalaviationsystem = Int32(nationalaviationsystemValue)
		}
		if let securityValue = dictionary["security"] as? Int{
			security = Int32(securityValue)
		}
		if let weatherValue = dictionary["weather"] as? Int{
			weather = Int32(weatherValue)
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
		dictionary["carrier"] = carrier
		dictionary["late aircraft"] = lateaircraft
		dictionary["national aviation system"] = nationalaviationsystem
		dictionary["security"] = security
		dictionary["weather"] = weather
		return dictionary
	}

}
