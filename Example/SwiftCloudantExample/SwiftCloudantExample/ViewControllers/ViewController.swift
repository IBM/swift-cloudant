//
//  ViewController.swift
//  SwiftCloudantTestProject
//
//  Created by Dan Burkhardt on 7/13/23.
//

import UIKit
import SwiftCloudant

class ViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var couchClient: CouchDBClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testLabel.text = "cats"
        
        // init swift cloudant FW
        initSwifCloudant()
    }
    
    func initSwifCloudant() {
        
        // if let
        if let couchClient = couchClient {
            
        }
        
        // guard
        guard
            let couchClient = couchClient
        else {
            return
        }
        
        // optional invocation
        // couchClient?.add(operation: )
    }
}

