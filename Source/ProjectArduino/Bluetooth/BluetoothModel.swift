//
//  BluetoothModel.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 14/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Peripheral: Equatable {
    var cbPeripheral: CBPeripheral
    var name: String?
    var uuid: String?
    var isConnected: Bool?
    
    static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
        return lhs.name == rhs.name && lhs.uuid == rhs.uuid
    }
    
    static func model(_ peripheral: CBPeripheral) -> Peripheral {
        return Peripheral(cbPeripheral: peripheral, name: peripheral.name ?? "NA", uuid: peripheral.identifier.uuidString, isConnected: false)
    }
}
