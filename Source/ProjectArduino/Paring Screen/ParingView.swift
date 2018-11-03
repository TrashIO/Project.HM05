//
//  ParingView.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 15/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

class ParingView: UIViewController {

    static func instance() -> ParingView {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParingView") as! ParingView
    }
    
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var buttonConnect: UIButton!
    
    var peripheral: Peripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
    }

    func initializeView() {
        self.buttonConnect.layer.borderWidth = 1.0
        self.buttonConnect.layer.borderColor = UIColor.white.cgColor
        self.buttonConnect.layer.cornerRadius = self.buttonConnect.frame.height / 2
        
        self.labelHeader.text = "App is trying to connect \(peripheral.name ?? "NA"). It will connect to Serial Port of device."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConnectAction(_ sender: Any) {
    
        let serviceView = ServiceView.instance()
        serviceView.peripheral = peripheral
        self.present(serviceView, animated: true, completion: nil)
    }
    
}
