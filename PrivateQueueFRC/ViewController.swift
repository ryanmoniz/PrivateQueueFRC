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
    
    lazy var privateChildContext: NSManagedObjectContext? = {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = self.moc
        return childContext
    }()
    
    var _otherController: NSFetchedResultsController<RootClass>?
    var otherController : NSFetchedResultsController<RootClass> {
        get{
            if _otherController != nil{
                return _otherController!
            }

            let subtaskRequest = RootClass.createFetchRequest()

//            subtaskRequest.predicate = NSPredicate(format: "task.category.name == %@", "Other Vocabulary")
            subtaskRequest.sortDescriptors = [NSSortDescriptor(key: "airport.code", ascending: true)]
            
            self._otherController = NSFetchedResultsController(fetchRequest: subtaskRequest, managedObjectContext:
                self.privateChildContext!, sectionNameKeyPath: nil, cacheName: nil)
            self._otherController?.delegate = self
            return self._otherController!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.appDelegate = (UIApplication.shared.delegate as! AppDelegate)
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
                NSLog(": jsonOp completed, reloading tableview")
                self.reloadData()
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
        if let sections = self.otherController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        configureCell(cell: cell, atIndexPath: indexPath as NSIndexPath)
        return cell
    }
    
    // quellish
    // Note: Instead of calling this from tableView:cellForRowAtIndexPath: you can do so from the delegate method
    // tableView:willDisplayCell:forRowAtIndexPath:
    // which also has a counterpart, tableView:didEndDisplayingCell:forRowAtIndexPath: where you can re-fault the managed object.
    func configureCell(cell: UITableViewCell, atIndexPath: NSIndexPath){
        let object = self.otherController.object(at: atIndexPath as IndexPath)
        
        // Access the managed object property from the context's queue, asynchronously
        // This MUST be done through the queue!
        object.managedObjectContext?.perform{
            let text = "Airport:"+object.airport.code + " Carrier:" + object.carrier.name
            //let subText = "Flights cancelled:\(object.statistics.flights.cancelled)" + " Delayed:\(object.statistics.minutesdelayed.total/60)"
            
            // Set the text on the cell
            OperationQueue.main.addOperation{
                let someCell: UITableViewCell = self.tableView.cellForRow(at: atIndexPath as IndexPath)!
                someCell.textLabel?.text = text
                //someCell.detailTextLabel?.text = subText
            }
        }
    }
    
    //MARK: - NSFetchRequest methods
    
    // quellish
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        OperationQueue.main.addOperation{
            self.tableView.beginUpdates()
        }
    }
    
    // quellish
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        OperationQueue.main.addOperation{
            self.tableView.endUpdates()
        }
    }
    
    // quellish
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        OperationQueue.main.addOperation{
            switch(type){
            case NSFetchedResultsChangeType.insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: UITableView.RowAnimation.fade)
            case NSFetchedResultsChangeType.delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: UITableView.RowAnimation.fade)
            default:
                return
            }
        }
    }
    
    // quellish
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        OperationQueue.main.addOperation{
            switch(type){
            case NSFetchedResultsChangeType.insert:
                self.tableView.insertRows(at: [newIndexPath! as IndexPath], with: UITableView.RowAnimation.fade)
            case NSFetchedResultsChangeType.delete:
                self.tableView.deleteRows(at: [indexPath! as IndexPath], with: UITableView.RowAnimation.fade)
            case NSFetchedResultsChangeType.update:
                if self.tableView.cellForRow(at: indexPath! as IndexPath) != nil{
                    self.configureCell(cell: self.tableView.cellForRow(at: newIndexPath! as IndexPath)!, atIndexPath: indexPath! as NSIndexPath)
                }
            case NSFetchedResultsChangeType.move:
                self.tableView.deleteRows(at: [indexPath! as IndexPath], with: UITableView.RowAnimation.fade)
                self.tableView.insertRows(at: [indexPath! as IndexPath], with: UITableView.RowAnimation.fade)
            }
        }
    }
}

