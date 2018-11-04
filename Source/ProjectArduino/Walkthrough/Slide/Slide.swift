//
//  Slide.swift
//  ProjectArduino
//
//  Created by Abhishek Kumar Ravi on 04/11/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

class Slide: UIView {

    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!

    var isLast:Bool?

    override func awakeFromNib() {
        super.awakeFromNib()

        guard let isLast = isLast else {return}

        print("State: \(isLast)")
        buttonDismiss.isHidden = !isLast
    }

    func getView(image: UIImage, message: String) -> Slide {

        let slideView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slideView.imageView.image = image
        slideView.labelMessage.text = message
        return slideView
    }

    @IBAction func actionDimiss(_ sender: Any) {

        if let presentedView = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            presentedView.dismiss(animated: true, completion: nil)
        }
    }

}
