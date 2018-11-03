//
//  UIViewController.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 15/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, positiveButton: String, negativeButton: String, onPositive:@escaping ()->(), onNegative:@escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveButton, style: .default, handler: { (action) in
            
            onPositive()
        }))
        alert.addAction(UIAlertAction(title: negativeButton, style: .cancel, handler: { (action) in
            
            onNegative()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    static let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func showProgressbar() {
        
        //self.view.isUserInteractionEnabled = false
        UIViewController.activityIndicator.center = self.view.center
        UIViewController.activityIndicator.startAnimating()
        self.view.addSubview(UIViewController.activityIndicator)
    }
    
    func hideProgressbar() {
        //self.view.isUserInteractionEnabled = true
        UIViewController.activityIndicator.stopAnimating()
        UIViewController.activityIndicator.removeFromSuperview()
    }
}
