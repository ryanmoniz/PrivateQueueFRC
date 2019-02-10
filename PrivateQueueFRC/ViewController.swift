//
//  ViewController.swift
//  PrivateQueueFRC
//
//  Created by Ryan Moniz on 2/9/19.
//  Copyright © 2019 Ryan Moniz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    
    //operation queue to ensure writes are done in serial
    internal lazy var writeOperationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "writeOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//    lazy var moc : NSManagedObjectContext? = {
//        // quellish
//        // DONT DO THIS!
//        // You are effectively using your application delegate object as a global.
//        // This will lead to many, many problems down the line. Instead have an object (such as the previous view controller)
//        // *pass* the managed object context to this view controller through an initializer or retained property.
//        //
//
//        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
//
//
//        let _moc = appDelegate.persistentContainer.viewContext
//        return _moc
//    }()
    
    lazy var privateChildContext: NSManagedObjectContext? = {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = self.moc
        return childContext
    }()
    
    var _otherController: NSFetchedResultsController<NSFetchRequestResult>?
    var otherController : NSFetchedResultsController<NSFetchRequestResult> {
        get{
            if _otherController != nil{
                return _otherController!
            }
            var subtaskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RootClass")

//            subtaskRequest.predicate = NSPredicate(format: "task.category.name == %@", "Other Vocabulary")
//            subtaskRequest.sortDescriptors = [NSSortDescriptor(key: "task.englishTitle", ascending: true), NSSortDescriptor(key: "sortOrder", ascending: true)]
            
            self._otherController = NSFetchedResultsController(fetchRequest: subtaskRequest, managedObjectContext:
                self.privateChildContext!, sectionNameKeyPath: nil, cacheName: nil)
            self._otherController?.delegate = self
            return self._otherController!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //load the JSON file
        loadAirlineJSON()
    }
    
    func loadAirlineJSON() {
        if let path = Bundle.main.path(forResource: "airlinesShort", ofType: "json") {
            let jsonOp = JSONParsingOperation(moc: moc, jsonPath: path)
            self.writeOperationQueue.addOperation(jsonOp)
            jsonOp.completionBlock = {
                NSLog(": jsonOp completed")
            }
        }
    }
    
    func reloadData(){
        self.appDelegate.saveContext()
        
        privateChildContext!.perform {
//            self.gospelController.performFetch(nil)
//            self.missionaryController.performFetch(nil)
            do {
                try self.otherController.performFetch()
                self.moc.perform {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("error:\(error)")
            }
        }
    }

    //MARK: - UITableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = UITableViewCell()
        
        return cell!
    }
}

