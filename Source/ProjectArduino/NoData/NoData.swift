//
//  NoData.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 19/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

class NoData: UIView {

    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    
    static func loadView(image: UIImage, message: String) -> NoData {
        let view = Bundle.main.loadNibNamed("NoData", owner: self, options: nil)?.first as! NoData
        view.imageHeader.image = image
        view.labelMessage.text = message
        
        return view
    }
    
}
