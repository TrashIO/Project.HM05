//
//  DeviceCell.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 15/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

struct DeviceViewModel {
    var peripheral: Peripheral
    var name: String
    var uuid: String
    var deviceType: UIImage
}

class DeviceCell: UITableViewCell {
    
    @IBOutlet weak var imageDevice: UIImageView!
    @IBOutlet weak var labelDeviceName: UILabel!
    @IBOutlet weak var labelDeviceSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    func config(_ viewModel: DeviceViewModel) {
        
        self.imageDevice.image = viewModel.deviceType
        self.labelDeviceName.text = viewModel.name
        self.labelDeviceSubTitle.text = viewModel.uuid
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
