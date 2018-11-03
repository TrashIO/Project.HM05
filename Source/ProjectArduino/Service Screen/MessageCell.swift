
//
//  MessageCellTableViewCell.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 18/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

struct MessageViewModel {
    
    var message: String
    var image: UIImage
    var isResponse: Bool
    var hasFailed: Bool
    var messageTimeStamp: Date
}

class MessageCell: UITableViewCell {

    @IBOutlet weak var labelTimestamp: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(_ viewModel: MessageViewModel) {
        self.labelMessage.text = viewModel.message
        self.imageMessage.image = viewModel.isResponse ? #imageLiteral(resourceName: "img_arduino_device") : #imageLiteral(resourceName: "app_logo")
        self.labelTimestamp.text = "2nd January 2018, 12:10 AM"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
