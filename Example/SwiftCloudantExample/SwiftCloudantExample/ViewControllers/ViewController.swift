//
//  ViewController.swift
//  SwiftCloudantTestProject
//
//  Created by Dan Burkhardt on 7/13/23.
//

import UIKit
import SwiftCloudant

/// A UUID for use in all operations during the current session
///
/// - Note: this will set to a new random id every time the
/// application is launched.
///
var sessionUserID: String = UUID().uuidString

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBAction func getAllDBsButtonAction(_ sender: Any) {
        getAllDBs()
    }
    @IBAction func createDBButtonAction(_ sender: Any) {
        createDB()
    }
    @IBAction func createButtonAction(_ sender: Any) {
        createNote()
    }
    
    var couchClient: CouchDBClient?
    let targetDB = "notes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI config
        setDefaultMessageLabel()
        // FW config
        initSwifCloudant()
    }
    
    func setDefaultMessageLabel() {
        messageLabel.text = "(msg logs will print here)"
    }
    
    func initSwifCloudant() {
        // init local instance URL with no failure tolerance
        guard
            let couchURL = URL(string: "http://localhost:5984")
        else {
            fatalError("test instance URL error")
        }
        
        let config = ClientConfiguration(shouldBackOff: false,
                                         clientTimeoutInterval: 2.0)
        
        // init client
        couchClient = .init(url: couchURL,
                            username: "admin",
                            password: "p@ssw0rd",
                            configuration: config)
    }
    
    // utils
    func updateMessagelabel(_ msg: String) {
        DispatchQueue.main.async {
            self.messageLabel.text = msg
        }
    }
    
    func incrementedDBNumber() -> Int {
        // this is to crudely simulate randomness
        // that each attempt to create a DB avoids
        // colliding with any previous DB names without
        // requiring manual edit of name string and app re-launch
        //
        //
        // get last saved value for db name incrementation
        let defaults = UserDefaults.standard
        
        // get and increment last DB number int
        var dbNumber: Int = defaults.integer(forKey: "db-number-increment")
        dbNumber += 1
        
        // set incremented value
        UserDefaults.standard.setValue(dbNumber, forKey: "db-number-increment")
        
        // return
        return dbNumber
    }
    
    // example operations
    func getAllDBs() {
        // create new operation
        let allDbs = GetAllDatabasesOperation(
           databaseHandler: { (databaseName) in
           // do something for the database name
        }) { (response, httpInfo, error) in
            
            // handle error
           if let error = error {
               let msg = error.localizedDescription
               self.updateMessagelabel("error message: \(msg)")
           }
            
            // handle unwrapped response
            if let response = response {
                // process the response information
                var msgString = ""
                 for dbNameRaw in response {
                     if let dbName = dbNameRaw as? String {
                         msgString += " \(dbName),"
                     }
                 }
                // update message label
                self.updateMessagelabel("all couchdb databases:\n\n \(msgString)")
            }
        }
        // add to queue for execution
        couchClient?.add(operation: allDbs)
    }
    
    func createDB() {
        // create new DB name string from DB increment
        let newDBName = "client-created-db\(incrementedDBNumber())"
        
        // use DB name string in new db creation operation
        let createDB = CreateDatabaseOperation(name: newDBName) { (response, info, error) in
            
            // handle error
           if let error = error {
               let msg = error.localizedDescription
               self.updateMessagelabel("error message: \(msg)")
           }
            // handle unwrapped response
            if let response = response {
                if let error = response["error"] as? String {
                    print("ERROR:: \(error)")
                    if let errorReason = response["reason"] as? String {
                        self.updateMessagelabel("error occured:\n\n \(errorReason)")
                    }
                } else {
                    if let successMsg = response["ok"] as? String {
                        print("SUCCESS:: \(successMsg)")
                        self.updateMessagelabel("success: database named \"\(newDBName)\" was created successfully")
                    }
                }
            }
        }
        // add to queue for execution
        couchClient?.add(operation: createDB)
    }
    
    func createNote() {
        // pt 1: creation with metadata
        let createdDate = Date().timeIntervalSinceReferenceDate
        
        let newNote: SCNote = .init(title: "asdfasdtest new notes title",
                                    body: "nest note body",
                                    created: Int(createdDate),
                                    createdBy: sessionUserID)
        
        // pt 2: put the document into the database
        // using the new convenience init
        let createNoteOperation: PutDocumentOperation = .init(storableObject: newNote, databaseName: targetDB)
        
        
        // take delegation of operation lifecycle
        createNoteOperation.operationDelegate = self
        
        // queue operation for execution via client
        couchClient?.add(operation: createNoteOperation)
    }
}

extension ViewController: CouchOperationDelegate {
    
    // handles response with http info
    func operationDidRespond(with info: SwiftCloudant.HTTPInfo) {
        print("operation responded with info: \(info)")
    }
    
    // handles response with success result
    func operationDidSucceed(with result: Data) {
        print("operation succeeded with result: \(result)")
        // attempt to decode from data
        if let successRes: PutDocumentSuccess = .fromData(result) {
            print("success result prettified:\n\(successRes.prettified)")
        }        
    }
    
    // handles operation error
    func operationDidFail(with error: Error) {
        print("operation failed with error: \(error)")
    }
}
