//
//  NSManagedObject+Ext.swift
//  PrivateQueueFRC
//
//  Created by Ryan Moniz on 2/9/19.
//  Copyright © 2019 Ryan Moniz. All rights reserved.
//

import Foundation
import CoreData


extension NSManagedObject {
    
    class func createInContext(_ context: NSManagedObjectContext) -> Self {
        return createInContext(context, type: self)
    }
    
    class func fetchReq() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: className())
    }
    
    
    func delete() {
        self.managedObjectContext?.delete(self)
    }
    
    
    fileprivate class func createInContext<T>(_ context: NSManagedObjectContext, type: T.Type) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: className(), into: context) as! T
    }
    
    
    class func className() -> String {
        let className = NSStringFromClass(self)
        let components = className.components(separatedBy: ".")
        return components.last!
    }
    
   
}
