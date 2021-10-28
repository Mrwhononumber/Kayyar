//
//  AddressSingelton.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/15/21.
//

import Foundation
import CoreLocation

class AddressSingelton {
    
    static let shared = AddressSingelton()
    
    var singeltonLocation : CLLocation?
}
