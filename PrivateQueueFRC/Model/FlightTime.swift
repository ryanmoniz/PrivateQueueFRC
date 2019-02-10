//
//	Time.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import CoreData

class FlightTime : NSManagedObject{

	@NSManaged var rootClass : RootClass!
	@NSManaged var label : String!
	@NSManaged var month : Int32
	@NSManaged var year : Int32


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    convenience init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)	{
        let entity = NSEntityDescription.entity(forEntityName: "FlightTime", in: context)!
        self.init(entity: entity, insertInto: context)
        
		if let rootClassData = dictionary["rootClass"] as? [String:Any]{
			rootClass = RootClass(fromDictionary: rootClassData, context:context)
		}
		if let labelValue = dictionary["label"] as? String{
			label = labelValue
		}
		if let monthValue = dictionary["month"] as? Int{
			month = Int32(monthValue)
		}
		if let yearValue = dictionary["year"] as? Int{
			year = Int32(yearValue)
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
		if label != nil{
			dictionary["label"] = label
		}
		dictionary["month"] = month
		dictionary["year"] = year
		return dictionary
	}

}
