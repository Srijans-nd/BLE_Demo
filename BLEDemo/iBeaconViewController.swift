//
//  iBeaconViewController.swift
//  BLEDemo
//
//  Created by srijans on 15/03/19.
//  Copyright © 2019 srijan. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreLocation

@objc class IBeaconBroadcaster: UIViewController, CBPeripheralManagerDelegate {
    let iBEACON_UUID = "71B2F817-2875-4835-A94E-F9B6C31A5A24"
    let iBEACON_MAJOR: CLBeaconMajorValue = 123
    let iBEACON_MINOR: CLBeaconMinorValue = 456
    
    var iBeaconRegion: CLBeaconRegion?
    var peripheralManager: CBPeripheralManager!
    var beaconData: NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        createBeaconRegion()
    }
    
    func createBeaconRegion() {
        print("createBeaconRegion")
        let uuid = UUID(uuidString: iBEACON_UUID)
        iBeaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: iBEACON_MAJOR, minor: iBEACON_MINOR, identifier: "NTDI:iBEACON")
        beaconData = iBeaconRegion?.peripheralData(withMeasuredPower: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("Peripheral state: \(peripheral.state)")        
        switch peripheral.state {
        case .poweredOn:
            startAdvertising()
            break
        case .poweredOff:
            stopAdvertising()
            break
        default:
            break;
        }
    }
    
    func startAdvertising() {
        print("startAdvertising")
        print("Beacon data: \(String(describing: beaconData))")
        
        peripheralManager!.startAdvertising(beaconData as? [String : Any]);
    }
    
    func stopAdvertising() {
        print("stopAdvertising")
        peripheralManager?.stopAdvertising()
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Advertising failed with error: \(error)")
            return
        }
        print("Succeeded!")
    }
}
