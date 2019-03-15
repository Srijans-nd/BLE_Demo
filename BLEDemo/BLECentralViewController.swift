//
//  BLECentralViewController.swift
//  BLEDemo
//
//  Created by srijans on 05/02/19.
//  Copyright © 2019 srijan. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BLECentralViewController: UIViewController, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var centralManager: CBCentralManager?
    var peripheralsArray: [CBPeripheral] = []
    var advertiseData: [String: [String : Any]] = [:]
    var selectedPeripheral: CBPeripheral?
    @IBOutlet weak var BLEDeviceList: UITableView!
    
    override func viewDidLoad() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        let deviceCell = UINib(nibName: "BLEDeviceCell", bundle: nil)
        BLEDeviceList.register(deviceCell, forCellReuseIdentifier: "BLEDeviceCell")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state: \(central.state)")
        switch central.state {
        case CBManagerState.poweredOn:
            startScanning()
        default:
            break;
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(
            """
            \nPeripheral:
            Name: \(peripheral.name ?? "Nil")
            Id  : \(peripheral.identifier)
            Rssi: \(RSSI)
            Data: \(advertisementData)
            Services  : \(String(describing: peripheral.services))\n
            """)
        
        
        let repeatedPeripherals = peripheralsArray.filter({$0.identifier == peripheral.identifier})
        if(repeatedPeripherals.count > 0) {
            return
        } else {
            peripheralsArray.append(peripheral)
            advertiseData.updateValue(advertisementData, forKey: "\(peripheral.identifier)")
        }
        BLEDeviceList.reloadData()
    }
    
    func startScanning() {
        let scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        centralManager?.scanForPeripherals(withServices: nil, options: scanOptions)
        print("Scanning begin")
    }
    
    func stopScanning() {
        centralManager!.stopScan()
    }
    
    // Called when it succeeded
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("connected!")
    }
    // Called when it failed
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connection failed…")

    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let deviceCell =  tableView.dequeueReusableCell(withIdentifier: "BLEDeviceCell") as? BLEDeviceCell {
            print("BLEDeviceCell")

            let peripheral = peripheralsArray[indexPath.row]
            deviceCell.updateCell(with:
                """
                \nName   : \(peripheral.name ?? "Nil")
                Id       : \(peripheral.identifier)
                State    : \(peripheral.state)
                Services : \(peripheral.services ?? [])
                Data     : \(advertiseData["\(peripheral.identifier)"] ?? ["Default":0])\n
                """)
            return deviceCell
        }
        print("HERE")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPeripheral = peripheralsArray[indexPath.row]
        centralManager?.connect(selectedPeripheral!, options: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as? BLEDeviceCell
        cell?.setNeedsLayout()
        cell?.layoutIfNeeded()
        return cell?.contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height ?? 200
    }
}

