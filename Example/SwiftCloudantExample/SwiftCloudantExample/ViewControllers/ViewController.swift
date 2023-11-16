//
//  ViewController.swift
//  SwiftCloudantTestProject
//
//  Created by Dan Burkhardt on 7/13/23.
//

import UIKit
import SwiftCloudant

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
    let tempUUID = UUID().uuidString
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
                                    createdBy: tempUUID)
        
        // pt 2: getting it into db
        
//        // transform into raw data
//        do {
//            // turn note into raw data
//            let noteData = try JSONEncoder().encode(newNote)
//        
//            // affirming that raw data can be turned into "[String: Any]"
//            if let json = try JSONSerialization.jsonObject(with: noteData) as? [String: Any] {
//                
//                // use serialized data to creat operation
//                let createNoteOperation = PutDocumentOperation(body: json, databaseName: targetDB) { (response, httpInfo, error) in
//                   if let error = error {
//                       print("error creating note: \(error)")
//                   } else {
//                       print("successful note creation: \(response)")
//                   }
//                }
//                
//                // add to queue for execution
//                couchClient?.add(operation: createNoteOperation)
//            }
//        } catch {
//            print("error encoding new note: \(error)")
//        }
        
        // new instantiation method
        let createNoteOperation: PutDocumentOperation = .init(storableObject: newNote, databaseName: targetDB)
        
        couchClient?.add(operation: createNoteOperation)
    }
}

