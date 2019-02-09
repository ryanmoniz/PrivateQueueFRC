//
//  Carrier.swift
//  PrivateQueueFRC
//
//  Created by Ryan Moniz on 2/9/19.
//  Copyright © 2019 Ryan Moniz. All rights reserved.
//

import Foundation
import CoreData

class Carrier : NSManagedObject{
    
    @NSManaged var rootClass : RootClass!
    @NSManaged var code : String!
    @NSManaged var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    convenience init(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)    {
        let entity = NSEntityDescription.entity(forEntityName: "Carrier", in: context)!
        self.init(entity: entity, insertInto: context)
        
        if let rootClassData = dictionary["rootClass"] as? [String:Any]{
            rootClass = RootClass(fromDictionary: rootClassData, context:context)
        }
        if let codeValue = dictionary["code"] as? String{
            code = codeValue
        }
        if let nameValue = dictionary["name"] as? String{
            name = nameValue
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
        if code != nil{
            dictionary["code"] = code
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
}
