//
//  ViewController.swift
//  BLEDemo
//
//  Created by srijans on 05/02/19.
//  Copyright © 2019 srijan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func emitBLE(_ sender: Any) {
        performSegue(withIdentifier: "HomeToBLE", sender: self)
    }
    
    @IBAction func findBLEPeripherals(_ sender: Any) {
        performSegue(withIdentifier: "HomeToBLECentral", sender: self)
        
    }
    @IBAction func broadcastiBeacon(_ sender: Any) {
        performSegue(withIdentifier: "HomeToiBeacon", sender: self)
    }
}

