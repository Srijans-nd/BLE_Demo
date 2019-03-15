//
//  BLEDeviceCell.swift
//  BLEDemo
//
//  Created by srijans on 14/03/19.
//  Copyright © 2019 srijan. All rights reserved.
//

import Foundation
import UIKit

class BLEDeviceCell: UITableViewCell {
    
    @IBOutlet weak var cellData: UITextView!
    
    func updateCell(with data: String){
        cellData.text = data
    }
}
