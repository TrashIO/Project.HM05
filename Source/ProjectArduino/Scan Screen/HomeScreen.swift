//
//  HomeScreen.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 15/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController {

    static func instance() -> ParingView {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParingView") as! ParingView
    }
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var buttonScan: UIButton!
    @IBOutlet weak var viewDefault: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: [Peripheral] = []
    private let gateway = BluetoothGateway.instance
    private var isScanning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isScanning = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stopScaning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonScanAction(_ sender: Any) {
        
        if !isScanning {
            self.scanDevices()
            isScanning = true
        }
        else {
            
            stopScaning()
            isScanning = false
        }
        
    }
    
    func showNoDevice() {
        
        let noDevice = NoData.loadView(image: #imageLiteral(resourceName: "img_ no_device"), message: "There is No HM-10 Device in your range. Please check.")
        tableView.backgroundView = noDevice
    }
    
    func stopScaning() {
        
        self.hideProgressbar()
        self.gateway.stopScanPeripherals()
        
        self.viewDefault.isHidden = false
        self.viewHeader.isHidden = true
         self.tableView.isHidden = true
         self.buttonScan.setTitle("Scan HM-10 Device", for: .normal)
    }
    
    func scanDevices() {
        
        // Remove All Old Devices
        self.dataSource.removeAll()
        
        self.viewDefault.isHidden = true
        self.viewHeader.isHidden = false
        self.tableView.isHidden = false
        self.buttonScan.setTitle("Stop Scaning", for: .normal)
        
        self.showProgressbar()
        gateway.scanPeripherals { (promise) in
            
            self.hideProgressbar()
            switch promise {
            case .resolve(let peripherals):
                
                self.prepareDeviceView(peripherals)
                break
                
            case .reject(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
}

extension HomeScreen {
    
    func initializeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func prepareDeviceView(_ peripherals: [Peripheral]) {
        
        if peripherals.count > 0 {
            self.tableView.isHidden = false
            self.viewDefault.isHidden = true
            self.viewHeader.isHidden = false
            
            self.dataSource = peripherals
            self.tableView.reloadData()
        }
        else {
            
            self.tableView.isHidden = true
            self.viewDefault.isHidden = false
            self.viewHeader.isHidden = true
        }
    }
    
    func prepareViewModel(peripheral: Peripheral) -> DeviceViewModel {
        return DeviceViewModel(peripheral: peripheral, name: peripheral.name ?? "NA", uuid: peripheral.uuid ?? "NA", deviceType: #imageLiteral(resourceName: "img_bluetooth"))
    }
}

extension HomeScreen: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        cell.config(prepareViewModel(peripheral: dataSource[indexPath.row]))
        return cell
    }
}

extension HomeScreen: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.showProgressbar()
        gateway.connectToPeripheral(dataSource[indexPath.row].cbPeripheral) { (promise) in
            
            self.hideProgressbar()
            switch promise {
            case .resolve(_):
                
                // Navigate to Passcode View
                let paringView = ParingView.instance()
                paringView.peripheral = self.dataSource[indexPath.row]
                self.present(paringView, animated: true, completion: nil)
                
                break
                
            case .reject(_):
                
                // TODO
                //Show Error
                
                break
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
