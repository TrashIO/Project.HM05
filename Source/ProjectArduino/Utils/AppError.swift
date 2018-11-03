//
//  AppError.swift
//  ProjectArduino
//
//  Created by Abhishek  Kumar Ravi on 16/10/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import Foundation

enum AppError: Error {
    case failedToConnectPeripheral
    case bluetoothUnavailable
}
