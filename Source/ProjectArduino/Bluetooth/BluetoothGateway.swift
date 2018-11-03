//
//  BluetoothGateway.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 14/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import Foundation
import CoreBluetooth

enum Promise<T> {
    case resolve(T)
    case reject(Error)
}

struct Payload {
    var data: String?
    var characterstics: String?
    var service: String?
}

class BluetoothGateway: NSObject {
    
    fileprivate var handlerPeripheral:((_ promise: Promise<[Peripheral]>) -> ())!
    fileprivate var handlerConnectPeripheral:((_ promise: Promise<Peripheral>) -> ())!
    fileprivate var handlerDisconnectPeripheral:((_ peripheral: Promise<Peripheral>) ->())!
    fileprivate var handlerWrite:((_ status: Bool)->())!
    
    fileprivate var payload: Payload?
    
    fileprivate var sourcePeripherals:[Peripheral] = []
    fileprivate var manager: CBCentralManager!
    
    public static let instance = BluetoothGateway()
    private override init() {
        
    }
    
    //0
    public func scanPeripherals(onCompletion:@escaping (_ promise: Promise<[Peripheral]>) -> ()) {
        
        self.handlerPeripheral = onCompletion
        
        self.sourcePeripherals.removeAll()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    private func startScaning() {
        manager.scanForPeripherals(withServices: [CBUUID(string: Constant.Bluetooth.serviceName)] , options: nil)
    }
    
    public func stopScanPeripherals() {
        if manager != nil {
         manager.stopScan()
        }
    }
    
    //1
    public func connectToPeripheral(_ peripheral: CBPeripheral, onCompletion:@escaping (_ promise: Promise<Peripheral>) -> ()) {
        
        self.handlerConnectPeripheral = onCompletion
        manager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }
    
    public func disconnectPeripheral(_ peripheral: CBPeripheral, onCompletion: @escaping (_ promise:Promise<Peripheral>) -> ()) {
        manager.cancelPeripheralConnection(peripheral)
        self.handlerDisconnectPeripheral = onCompletion
    }
    
    func sendPayload(_ payload: Payload, peripheral: CBPeripheral, onCompletion:@escaping (_ status: Bool) ->()) {
        
        self.handlerWrite = onCompletion
        self.payload = payload
        peripheral.discoverServices(nil)
    }
    
    //3
    public func getCharacterstics(_ peripheral: CBPeripheral, service: CBService) {
        
        // Get Characterstics of Peripheral
        peripheral.discoverCharacteristics(nil, for: service)
    }
    
    //2
    public func getServices(_ peripheral: CBPeripheral) {
    
        // Get Service of Peripherals
        peripheral.discoverServices(nil)
    }
    
    //4
    public func write(peripheral: CBPeripheral, service: CBService, characterstics: CBCharacteristic, data: String) {
        
    }
    
    public func read(peripheral: CBPeripheral, service: CBService, characterstics: CBCharacteristic) {
        
    }
}

extension BluetoothGateway {
    
    fileprivate func isPeripheralExist(_ peripheral: CBPeripheral) -> Bool {
        
        let filteredSource = sourcePeripherals.filter { (savedPeripheral) -> Bool in
            
            if savedPeripheral.name == peripheral.name ?? "" || savedPeripheral.uuid == peripheral.identifier.uuidString {
                
                // Peripheral is already there
                return true
            }
            return false
        }
        
        return filteredSource.count > 0 ? true : false
    }
}

extension BluetoothGateway: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
            
        case .poweredOff:
            print("Bluetooth is Off")
            break
            
        case .poweredOn:
            print("Bluetooth is ON")
            
            startScaning()
            break
            
        case .resetting:
            print("Bluetooth is RESETING")
            break
            
        case .unauthorized:
            print("Bluetooth is Unauthorized")
            break
            
        case .unknown:
            print("Unknown Error")
            break
            
        case .unsupported:
            print("Bluetooth is Unsupported")
            break
            
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
        print("Restore State ...")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if !self.isPeripheralExist(peripheral) {
            
            print("Peripheral [\(peripheral.name ?? "NA")] has been saved.")
            
            sourcePeripherals.append(Peripheral(cbPeripheral: peripheral, name: peripheral.name, uuid: peripheral.identifier.uuidString, isConnected: false))
            
            if handlerPeripheral != nil {
                self.handlerPeripheral(Promise.resolve(sourcePeripherals))
            }
        }

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Connected to Peripheral [\(peripheral.name ?? "NA")]")
        
        if self.handlerConnectPeripheral != nil {
            self.handlerConnectPeripheral(Promise.resolve(Peripheral.model(peripheral)))
            
            self.manager.stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        print("Failed to Connect Peripheral [\(peripheral.name ?? "NA")]")
        
        if self.handlerConnectPeripheral != nil {
            self.handlerPeripheral(Promise.reject(AppError.failedToConnectPeripheral))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        print("Disconnected to Peripheral [\(peripheral.name ?? "NA")]")
        
        if handlerDisconnectPeripheral != nil {
            self.handlerDisconnectPeripheral(Promise.resolve(Peripheral.model(peripheral)))
        }
    }
}

extension BluetoothGateway: CBPeripheralDelegate {
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {return}
        guard let payload = self.payload else {return}
        
        print("Discovering Services for \(peripheral.name ?? "NA") ...")
        for service: CBService in services {
            if service.uuid.uuidString == payload.service ?? Constant.Bluetooth.serviceName  {
                // Request for Characterstics
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
    }
    
    @available(iOS 11.0, *)
    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characterstics = service.characteristics else { return }
        guard let payload = self.payload else {return}
        
        for characterstic in characterstics {
            
            if characterstic.uuid.uuidString == payload.characterstics ?? Constant.Bluetooth.charactersticsName  {
                
                //Write to this Characterstics
                let data = payload.data ?? "0"
                let messageWrite = data.data(using: .utf8)
                peripheral.writeValue(messageWrite!, for: characterstic, type: .withResponse)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Written Value for \(peripheral.name ?? "NA") at characterstics \(String(describing: characteristic.descriptors))")
        
        if self.handlerWrite != nil {
         self.handlerWrite(true)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
}
