//
//  NSFetchedResultsController+SafeRetrieval.swift
//  PrivateQueueFRC
//
//  Created by Ryan Moniz on 2/9/19.
//  Copyright © 2019 Ryan Moniz. All rights reserved.
//

import UIKit
import CoreData

extension NSFetchedResultsController {
    // Determine whether provided indexPath is valid.
    //
    // - note: This method checks if self.section is greater than indexPath.section
    // and if the number of items in indexPath.section is greater than indexPath.row
    //
    // - parameter indexPath: indexPath to be checked.
    //
    // - returns: Whether indexPath has a value associated to it.
    // Swift 4 migration - added @objc to resolve the error "Extension of a generic Objective-C class cannot access the class's generic parameters at runtime"
    // CHECK!
    @objc func hasObject(at indexPath : IndexPath) -> Bool {
        guard let sections = self.sections, sections.count > indexPath.section else {
            return false
        }
        
        let sectionInfo = sections[indexPath.section]
        
        guard sectionInfo.numberOfObjects > indexPath.row else {
            return false
        }
        
        return true
    }
}
