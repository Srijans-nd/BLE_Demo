//
//  BLEViewController.swift
//  BLEDemo
//
//  Created by srijans on 05/02/19.
//  Copyright © 2019 srijan. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BLEViewController: UIViewController, CBPeripheralManagerDelegate {
    
    
    var peripheralManager: CBPeripheralManager?
    var service:CBMutableService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
        switch peripheral.state {
        case CBManagerState.poweredOn:
            startAdvertising()
        default:
            break;
        }
    }
    
    func startAdvertising() {
        let advertisingData = [CBAdvertisementDataLocalNameKey: "NTDI:BLEDemo"]
        peripheralManager!.startAdvertising(advertisingData);
    }
    
    func stopAdvertising() {
        peripheralManager?.stopAdvertising()
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Advertising failed with error: \(error)")
            return
        }
        print("Succeeded!")
    }
    
    func createService() {
        let serviceUUID = CBUUID(string: "AC063F51-6652-44F8-85E5-310546EE2037")
        service = CBMutableService(type: serviceUUID, primary: true)
        
        let characteristicsUUID = CBUUID(string: "B4D406E2-03CC-437A-B1BD-39099D49EE44")
        let properties: CBCharacteristicProperties = [.notify, .read, .write]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        let characteristic = CBMutableCharacteristic(type: characteristicsUUID, properties:properties, value: nil, permissions: permissions)
        
        service?.characteristics = [characteristic]
        peripheralManager?.add(service!)
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        if let error = error {
            print("error: \(error)")
            return
        }
        print("service: \(service)")
    }
}
