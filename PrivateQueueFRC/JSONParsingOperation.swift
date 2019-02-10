//
//  JSONParsingOperation.swift
//  PrivateQueueFRC
//
//  Created by Ryan Moniz on 2/9/19.
//  Copyright © 2019 Ryan Moniz. All rights reserved.
//

import Foundation
import CoreData


class JSONParsingOperation: Operation {
    //MARK: - Properties
    
    private let context: NSManagedObjectContext
    private let jsonPath:String
    //MARK: - Init
    
    init(moc: NSManagedObjectContext, jsonPath:String) {
        NSLog("JSONParsingOperation - init() called")
        self.context = moc
        self.jsonPath = jsonPath
        super.init()
    }
    
    //MARK: - Overrides
    
    override func main() {
        NSLog("JSONParsingOperation - main() called")
        
        context.performAndWait { //ensure; the operation isn't deallocated before the save operation completes.
            //parse
            do {
                print("parsing json…")
                let data = try Data(contentsOf: URL(fileURLWithPath: self.jsonPath), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let jsonResult = jsonResult as? Array<Any> {
                    print("json is parsed")
                    //assume json is an array of dictionary objects
                    let count = jsonResult.count
                    print("jsonArray count:\(count)")
                    var index = 1
                    print("#########################")
                    for dict in jsonResult {
                        //print("dict:\(dict)")
                        print("index: \(index) of \(count) records")
                        let _ = RootClass(fromDictionary: dict as! [String : Any], context: context)
                        index += 1
                    }
                    print("#########################")
                    saveChanges()
                }
            } catch {
                print("json could not be parsed")
            }
        }
    }
    
    //MARK: - Helper Methods
    
    private func saveChanges() {
        NSLog("JSONParsingOperation - saveChanges() called")
        context.performAndWait { //ensure the operation isn't deallocated before the save operation completes.
            do {
                if self.context.hasChanges {
                    NSLog("JSONParsingOperation - saveChanges() : hasChanges = true")
                    try self.context.save()
                }
            } catch {
                NSLog("JSONParsingOperation - saveChanges() : error:\(error.localizedDescription)")
            }
        }
    }
}
