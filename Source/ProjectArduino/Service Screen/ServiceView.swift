//
//  ServiceView.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 15/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

class ServiceView: UIViewController {
    
    static func instance() -> ServiceView {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceView") as! ServiceView
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageStatusIcon: UIImageView!
    @IBOutlet weak var labelConnectionStatus: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textfieldMessage: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewLog: UIView!
    
    var dataSource:[MessageViewModel] = []
    var peripheral: Peripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
    }
    
    func initializeView() {
        
        self.viewMessage.layer.borderWidth = 1.0
        self.viewMessage.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.viewLog.layer.borderWidth = 0.0
        self.viewLog.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        self.labelConnectionStatus.text = "Connected to \(peripheral.name ?? "NA")"
        
        registerTap()
        initializeMessageView()
        noLog()
    }
    
    func registerTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ServiceView.viewaTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewaTapped() {
        self.view.endEditing(true)
    }
    
    func noLog() {
        
        let noLog = NoData.loadView(image: #imageLiteral(resourceName: "img_ no_device"), message: "You haven't send any messsage yet. Please ensure HM-10 is connected before sending instruction.")
        tableView.backgroundView = noLog
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCloseAction(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.showAlert(title: "Disconnect", message: "Do you want to diconnect this activte session with \(peripheral.name ?? "NA") ?", positiveButton: "Yes", negativeButton: "No", onPositive: {
            
            // Disconnect Session
            if self.peripheral != nil {
                
                self.showProgressbar()
                BluetoothGateway.instance.disconnectPeripheral(self.peripheral.cbPeripheral, onCompletion: { (promise) in
                
                    self.hideProgressbar()
                    switch promise {
                        case .resolve(_):
                            // Exit The View
                            self.dismiss(animated: true, completion: nil)
                            if let current = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController, let paringView = current as? ParingView {
                                paringView.dismiss(animated: false, completion: nil)
                            }
                            break
                        
                        case .reject(_):
                            // TODO: Unhandlled
                            break
                    }
                    
                })
            }
            
        }) {
            
            // Do Nothing
        }
    }
    
    @IBAction func buttonSendAction(_ sender: Any) {
        
        guard let messageText = self.textfieldMessage.text else {return}
        
        if messageText != "" {
            
            // Send Message
            let payload = Payload(data: messageText, characterstics: Constant.Bluetooth.charactersticsName, service: Constant.Bluetooth.serviceName)
            BluetoothGateway.instance.sendPayload(payload, peripheral: peripheral.cbPeripheral) { (hasSent) in
                
            
                if hasSent {
                    self.prepareMessagesView(MessageViewModel(message: messageText, image: #imageLiteral(resourceName: "img_command"), isResponse: false, hasFailed: false, messageTimeStamp: Date()))
                    self.textfieldMessage.text = ""
                }
                else {
                    
                    // Failed While Sending
                }
                
            }
            
        }
    }
    
}

extension ServiceView {
    
    func initializeMessageView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func prepareMessagesView(_ viewModel: MessageViewModel) {
        
        tableView.backgroundView = nil
        self.dataSource.append(viewModel)
        
        self.dataSource.reverse()
        self.tableView.reloadData()
    }
}

extension ServiceView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.config(dataSource[indexPath.row])
        
        return cell
    }
}

extension ServiceView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected Message : \(dataSource[indexPath.row])")
    }
}
